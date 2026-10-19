/*
 This source file is part of the Swift.org open source project

 Copyright (c) 2026 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
 See https://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

// Usage: swift bin/minify-static-html-css.swift
//
// This script bundles Sources/DocCHTML/Styles/reference/reference.css, and the files that it imports, into a single minified
// style sheet and embeds it in Sources/DocCHTML/StaticResources.swift.
//
// It uses Lightning CSS (https://lightningcss.dev) with the same options as Vite's production build: minification and Vite's
// default "baseline-widely-available" browser targets (https://vite.dev/config/build-options#build-csstarget).
// The script downloads Lightning CSS's native executable from the npm registry, verifies its checksum, and caches it in ".build".

import Foundation

let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()

@discardableResult
func run(_ arguments: String...) throws -> String {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = arguments
    let output = Pipe()
    process.standardOutput = output
    try process.run()
    let data = output.fileHandleForReading.readDataToEndOfFile() // Read before waiting, so that a full pipe can't block the process.
    process.waitUntilExit()
    guard process.terminationStatus == 0 else { fatalError("'\(arguments[0])' exited with code \(process.terminationStatus)") }
    return String(decoding: data, as: UTF8.self)
}

// MARK: Download Lightning CSS

#if os(macOS) && arch(arm64)
let platform = "darwin-arm64"
#elseif os(macOS)
let platform = "darwin-x64"
#elseif arch(arm64)
let platform = "linux-arm64-gnu"
#else
let platform = "linux-x64-gnu"
#endif

// The SHA-512 checksums of the "lightningcss-cli-<platform>" packages, from their npm integrity metadata.
let version = "1.33.0"
let checksum = [
    "darwin-arm64":    "b2ca3985214f8acee5770d85701a29b19be2495017591197f326d4c0c8501ecb1394445e9d027cf168a166cd3cb427529d050ba3692e9e7ac6861e158d1c3c16",
    "darwin-x64":      "fda0d8a4cbf640aa49a12230bf0a48b38b485fd48253cf787a8b294a6e79151e4cc43664243cb87c45fa7a5b179070810ea6c09276f8a9dda1fe80cc2d30b813",
    "linux-x64-gnu":   "f50e03020966d7b6cb840f8764f07ebf18eb1d776147ff14e38cf273c310340e51c3eb62b2f72847f96fe22b815059f6aab798551590ab4c0fd2b81d8534b1c9",
    "linux-arm64-gnu": "0e46269018b1de270064a66cc46b230408f9f42215d337e566db13eba9423dddb3dcea812c9961291af0e139405bb98891878e11858a573fc6d346465cdb1ee0",
][platform]!

let cache = root.appendingPathComponent(".build/lightningcss-\(version)-\(platform)")
let lightningCSS = cache.appendingPathComponent("lightningcss").path

if !FileManager.default.fileExists(atPath: lightningCSS) {
    let archive = cache.appendingPathComponent("lightningcss.tgz").path
    try FileManager.default.createDirectory(at: cache, withIntermediateDirectories: true)
    try run("curl", "--fail", "--silent", "--show-error", "--location", "--output", archive,
            "https://registry.npmjs.org/lightningcss-cli-\(platform)/-/lightningcss-cli-\(platform)-\(version).tgz")
    // Verify the download before running anything from it.
    guard try run("shasum", "-a", "512", archive).hasPrefix(checksum) else { fatalError("Unexpected checksum for \(archive)") }
    try run("tar", "-xzf", archive, "-C", cache.path, "--strip-components=1", "package/lightningcss")
}

// MARK: Minify and embed

let css = try run(lightningCSS, "--bundle", "--minify", "--targets", "chrome 111, edge 111, firefox 114, safari 16.4, ios_saf 16.4",
                  root.appendingPathComponent("Sources/DocCHTML/Styles/reference/reference.css").path)

// Replace the contents of the `referenceStyleSheet` string literal. It's a raw string so that backslashes in the CSS stay as-is.
let swiftFile = root.appendingPathComponent("Sources/DocCHTML/StaticResources.swift")
var source = try String(contentsOf: swiftFile, encoding: .utf8)
let literal = #/(?<start>static let referenceStyleSheet = File\(filename: "reference.css", data: Data\()#?""".*?"""#?\.utf8\)\)/#.dotMatchesNewlines()
guard source.contains(literal) else { fatalError("Couldn't find the `referenceStyleSheet` string literal") }
source.replace(literal) { "\($0.start)#\"\"\"\n\(css.trimmingCharacters(in: .newlines))\n\"\"\"#.utf8))" }
try source.write(to: swiftFile, atomically: true, encoding: .utf8)
