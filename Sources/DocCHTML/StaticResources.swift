/*
 This source file is part of the Swift.org open source project

 Copyright (c) 2026 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
 See https://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

// This file defines data constants for resource files that make up Swift-DocC's base "template" for static HTML output.
//
// We're defining these data constants like this ourselves to workaround restrictions with `.embedInCode()` package resources.
// https://github.com/swiftlang/swift-package-manager/issues/6969
//
// If we instead used real files in a subdirectory, we would need to handle them the same as the Swift-DocC Render template, meaning:
// - DocC would need to find these resources at runtime and handle the case when the resources are missing.
// - We would need to update the script that installs Swift-DocC into the Swift toolchain to copy these resources into a suitable location.
// - In order to support local development workflows would need to support a runtime override of this resource location.
//
// Conceptually these two groups of files are very alike but practically there are two big differences between them:
// - These resources for the static HTML output are defined and developed inside the Swift-DocC repo.
// - These resources for the static HTML output are about two orders of magnitude smaller than the Swift-DocC Render template.
// Thus, in order to facilitate easier development of the static HTML output, it makes sense to handle these resources differently, at least for now.

package import struct Foundation.Data

// When working with these resources, a decent workflow is to build some static HTML output and then in-place modify the copied resources in the output directory.
// This way, you can make adjustments to the CSS or add a new icon and refresh the page to see the changes reflected as you make quick iterations.
// If you're happy with your changes or if you need to make modifications to the static HTML that DocC outputs, you can copy the contents of the modified files back here.
//
// The style sheet is the exception. Its readable source is "Styles/reference/reference.css" and the files it imports, and the data below is generated from them.
// To iterate on it, copy the files in the "Styles/reference" directory into the output directory, replacing the minified "reference.css" file.
// Browsers load the `@import` rules directly, so you can edit the files there. Then copy your changes back
// and run `swift bin/minify-static-html-css.swift` to update the bundled and minified data below.

/// The group of resource files that make up DocC's base "template" for static HTML output.
package enum StaticResources {
    // This type is only responsible for naming the blobs of data. It's the caller's responsibility to work with the file system to write these files into the output location.
    
    package struct File {
        package let filename: String
        package let data: Data
    }
    
    package static let allFiles = [
        referenceStyleSheet,
        // Page kind icons
        apiCollectionIcon,
        articleIcon,
        moduleIcon,
        // UI element icons
        anchorIcon,
        sidebarIcon,
    ]
    
    // MARK: Stylesheets
    
    // For the future; the idea is that tutorial documentation would have its own stylesheet so that each page's `<head>` can link to only the style information that it needs.
    
    /// The style sheet that DocC uses to define the layout and appearance of "reference" documentation (symbols and articles).
    ///
    /// - Important: Don't edit this data directly. Edit "Styles/reference/reference.css" or the files it imports and run `swift bin/minify-static-html-css.swift` instead.
    static let referenceStyleSheet = File(filename: "reference.css", data: Data(#"""
:root{--color-header-text:#1d1d1f;--color-code-background:#f7f7f7;--color-secondary-label:#6e6e73;--color-grid:#ccc;--color-fill-gray:#ccc;--color-fill-gray-quaternary:#f0f0f0;--color-fill-gray-secondary:#f5f5f5;--color-fill-gray-tertiary:#f0f0f0;--color-badge-deprecated:#bf4800;--color-standard-blue:#06c;--color-standard-gray:#afafaf;--color-standard-green:#509ca3;--color-standard-orange:#ff5a00;--color-standard-purple:#bf6af7;--color-standard-red:#d82797;--color-standard-yellow:#ff9f2c;--color-figure-gray-secondary:#666;--color-figure-blue:#36f;--font-default:"Helvetica Neue", Helvetica, Arial, sans-serif;--font-mono:Menlo, monospace}.swift-only{display:unset}.occ-only{display:none}*{margin:0}body{font-family:var(--font-default);font-synthesis:none;-moz-font-feature-settings:"kern";-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale;text-align:start;overflow-wrap:break-word;--spacing-stacked-margin-small:.4em;--spacing-stacked-margin-large:.8em;--spacing-stacked-margin-xlarge:calc(var(--spacing-stacked-margin-large) * 2);--spacing-param:28px;--declaration-code-listing-margin:30px 0 0 0;--code-block-style-elements-padding:8px 14px}picture>img{width:100%}section{max-width:820px;margin:0 auto}@media only screen and (width<=1250px){section{padding-left:80px;padding-right:80px}}@media only screen and (width<=735px){section{padding-left:20px;padding-right:20px}}@media only screen and (width>=1500px){section{max-width:920px}}:is(article>section:not(#hero)+#Topics,article>section:not(#hero)+#See-Also,article>section:first-of-type:not(#hero)+section):before{content:"";background:var(--color-grid);width:100%;height:1px;margin-bottom:40px;display:block}hr{max-width:820px;margin:0 auto}@media only screen and (width<=1250px){hr{max-width:660px}}@media only screen and (width<=820px){hr{margin:0 80px}}@media only screen and (width<=735px){hr{margin:0 20px}}@media only screen and (width>=1500px){hr{max-width:920px}}section{box-sizing:border-box;padding-top:40px;padding-bottom:40px}@media print{section{max-width:none;padding-left:80px;padding-right:80px}}section+section{padding-top:0}hr{background:var(--color-grid);border:none;height:1px}section :first-child{margin-top:0}h1,h2,h3{font-weight:400}h4,h5,h6{font-weight:600}h1{margin-top:1.6em;font-size:40px;line-height:44px}@media only screen and (width<=1250px){h1{font-size:32px;line-height:36px}}@media only screen and (width<=735px){h1{font-size:28px;line-height:32px}}h2{margin-top:1.6em;font-size:32px;line-height:36px}@media only screen and (width<=1250px){h2{font-size:28px;line-height:32px}}@media only screen and (width<=735px){h2{font-size:24px;line-height:28px}}h3{padding-top:36px;font-size:28px;line-height:32px}@media only screen and (width<=1250px){h3{font-size:24px;line-height:28px}}@media only screen and (width<=735px){h3{font-size:21px;line-height:25px}}h4{font-size:24px;line-height:28px}@media only screen and (width<=1250px){h4{font-size:21px;line-height:25px}}h5{font-size:22px;line-height:26px}@media only screen and (width<=1250px){h5{font-size:20px;line-height:24px}}@media only screen and (width<=735px){h5{font-size:18px;line-height:26px}}h6{font-size:17px;line-height:25px}h1,h2,h3,h4,h5,h6{padding-inline-end:23px}:is(h1,h2,h3,h4,h5,h6)>a{color:#000;text-decoration:none}:is(h1,h2,h3,h4,h5,h6)>a:hover:after{content:url(anchor.svg);margin-left:7px}section:first-of-type>hgroup>p{color:var(--color-figure-gray-secondary);margin:0 0 15px;font-size:21px;line-height:25px}@media only screen and (width<=1250px){section:first-of-type>hgroup>p{font-size:19px;line-height:23px}}section:first-of-type>hgroup>p+h1{margin-top:0}#breadcrumbs>ul{margin-bottom:20px;padding:0;list-style-type:none;display:flex}#breadcrumbs>ul>li{font-size:14px;line-height:20px}#breadcrumbs>ul>li a{color:#000}#breadcrumbs>ul>li:not(:first-child):before{content:"/";width:5px;margin-inline:5px}#availability{flex-wrap:wrap;align-items:center;gap:11px;margin-top:15px;margin-bottom:20px;padding:0;list-style-type:none;display:flex}#availability>li{height:20px;font-size:14px;line-height:20px}#availability>li:not(:last-child):after{content:"";background-color:#000;width:1px;height:14px;margin-left:10px;display:inline-block;position:relative;top:2px}#hero{clip-path:inset(0 -50%);margin-bottom:40px;position:relative}#hero:before{content:"";z-index:-2;background:#f0f0f0;width:200%;height:100%;position:absolute;top:0;left:-50%}#hero.article:after{background:url(article.svg)}#hero.api-collection:after{background:url(api-collection.svg)}#hero.module:after{background:url(module.svg)}#hero.article:after,#hero.api-collection:after,#hero.module:after{content:"";--icon-size:250px;top:calc(50% - var(--icon-size) / 2);opacity:.15;z-index:-1;width:var(--icon-size);height:var(--icon-size);background-size:var(--icon-size) var(--icon-size);position:absolute;right:25px}section:first-of-type>p{margin-top:12px;font-size:21px;line-height:29px}@media only screen and (width<=735px){section:first-of-type>p{font-size:19px;line-height:27px}}#declaration,pre{background:var(--color-code-background);border-color:var(--color-grid);padding:var(--code-block-style-elements-padding);--color-syntax-attributes:#947100;--color-syntax-characters:#272ad8;--color-syntax-comments:#707f8c;--color-syntax-deletion:var(--color-figure-red);--color-syntax-documentation-markup:#506375;--color-syntax-documentation-markup-keywords:#506375;--color-syntax-heading:#ba2da2;--color-syntax-highlighted:#0071e333;--color-syntax-keywords:#ad3da4;--color-syntax-marks:#000;--color-syntax-numbers:#272ad8;--color-syntax-other-class-names:#703daa;--color-syntax-other-constants:#4b21b0;--color-syntax-other-declarations:#047cb0;--color-syntax-other-function-and-method-names:#4b21b0;--color-syntax-other-instance-variables-and-globals:#703daa;--color-syntax-other-preprocessor-macros:#78492a;--color-syntax-other-type-names:#703daa;--color-syntax-param-internal-name:#404040;--color-syntax-plain-text:#000;--color-syntax-preprocessor-statements:#78492a;--color-syntax-project-class-names:#3e8087;--color-syntax-project-constants:#2d6469;--color-syntax-project-function-and-method-names:#2d6469;--color-syntax-project-instance-variables-and-globals:#3e8087;--color-syntax-project-preprocessor-macros:#78492a;--color-syntax-project-type-names:#3e8087;--color-syntax-strings:#d12f1b;--color-syntax-type-declarations:#03638c;--color-syntax-urls:#1337ff;border-style:solid;border-width:1px;border-radius:4px;margin-top:40px;line-height:25px}:is(#declaration,pre)>code{font-size:15px;line-height:25px;display:block}:is(#declaration,pre)>code .keyword,:is(#declaration,pre)>code .attribute{color:var(--color-syntax-keywords)}:is(#declaration,pre)>code .internalParam{color:var(--color-syntax-param-internal-name)}:is(#declaration,pre)>code .typeIdentifier{color:var(--color-syntax-other-type-names)}:is(#declaration,pre)>code .typeIdentifier:not(:hover){text-decoration:none}pre{-webkit-overflow-scrolling:auto;white-space:pre;overflow-wrap:normal;margin-top:2.1em;overflow:auto}p{margin-top:.8em;font-size:17px;line-height:24px}dl{margin-top:.85em}dl dt{font-size:17px;font-weight:600;line-height:25px;font-family:var(--font-mono);padding-left:17px;padding-top:var(--spacing-param)}dl dt:first-child{padding-top:0}@media only screen and (width<=735px){dl dt{padding-left:0}}dl dd{padding-left:34px}dl dd p{margin:0;line-height:23px}@media only screen and (width<=735px){dl dd{padding-left:0}}table{border-collapse:collapse;border-spacing:0;margin-top:1.6em;margin-bottom:1.6em;font-size:17px;line-height:25px}table th,table td{text-align:start;border:1px solid #f0f0f0;padding:10px}table th{border-top:none}table th:first-of-type{border-left:none}table th:last-of-type{border-right:none}table tr:last-of-type>td{border-bottom:none}table tr td:first-of-type{border-left:none}table tr td:last-of-type{border-right:none}aside{border:0 solid #666;background-color:#f5f5f5;border-inline-start-width:6px;border-radius:4px;margin-top:27px;padding:16px}aside .label{margin-top:0;font-weight:600}aside>p:nth-of-type(2){margin-top:.4em}:is(#Topics,#See-Also)>ul{padding:0}:is(#Topics,#See-Also)>ul>li{margin-top:15px;list-style:none}:is(#Topics,#See-Also)>ul>li>a{padding:5px 0;font-size:1rem;text-decoration:none;display:inline-flex}:is(#Topics,#See-Also)>ul>li>a:hover{text-decoration:underline}:is(#Topics,#See-Also)>ul>li>a>code{color:#666;font-size:17px;line-height:24px}:is(#Topics,#See-Also)>ul>li>a>code>.identifier{color:var(--color-figure-blue)}:is(#Topics,#See-Also)>ul>li>p{margin:0;margin-inline-start:2.294em;line-height:24px}:is(#Topics,#See-Also)>ul>li .api-collection,:is(#Topics,#See-Also)>ul>li .article{margin-top:0}:is(:is(#Topics,#See-Also)>ul>li .api-collection,:is(#Topics,#See-Also)>ul>li .article):before{content:url(api-collection.svg);width:36px;margin-left:4px;margin-right:20px;position:relative;top:2px}:is(#Topics,#See-Also)>ul>li .article:before{content:url(article.svg)}:is(#Topics,#See-Also)>h3{padding-top:39px;font-size:24px;line-height:28px}@media only screen and (width<=1250px){:is(#Topics,#See-Also)>h3{font-size:21px;line-height:25px}}:is(#Topics,#See-Also)>h2{margin-top:0}:is(#Topics,#See-Also)>p{margin-top:15px}#Mentioned-In>ul{padding:0}#Mentioned-In>ul>li{margin-top:10px;list-style:none}#Mentioned-In>ul>li>a{padding:5px 0;font-size:17px;text-decoration:none;display:inline-flex}#Mentioned-In>ul>li>a:hover{text-decoration:underline}#Mentioned-In>ul>li>p{margin:0;margin-inline-start:2.294em;line-height:24px}#Mentioned-In>ul>li:before{content:url(article.svg);width:36px;margin-left:2px;margin-right:8px;position:relative;top:2px}a{color:var(--color-figure-blue)}b,strong{font-weight:600}em,i,cite,dfn{font-style:italic}sup{vertical-align:top;font-size:.6em;position:relative;bottom:-.2em}h1 :is(sup),h2 :is(sup),h3 :is(sup){font-size:.4em}sup a{vertical-align:inherit;color:inherit}sup a:hover{color:var(--color-figure-blue);text-decoration:none}sub{line-height:1}abbr{border:0}code{font-weight:inherit;letter-spacing:0}body>header{z-index:5;border-bottom:1px solid var(--color-grid);-webkit-backdrop-filter:saturate(1.8)blur(20px);backdrop-filter:saturate(1.8)blur(20px);background-color:#ffffffb3;justify-content:space-between;align-items:center;width:100%;height:52px;line-height:25px;display:flex;position:sticky;top:0}body>header h2{float:left;margin-top:0;font-size:21px;font-weight:600;line-height:25px}body>header h2:before{content:url(sidebar.svg);width:30px;display:inline-block}body>header h2{margin-left:22px}body>header span{float:right;margin-right:22px;font-size:14px;line-height:18px;display:inline-block}body>footer{border-top:1px solid var(--color-grid);justify-content:space-between;align-items:center;width:100%;height:63px;line-height:25px;display:flex}body>footer fieldset legend{clip:rect(1px,1px,1px,1px);clip-path:inset(0 0 99.9% 99.9%);width:1px;height:1px;position:absolute;overflow:hidden}body>footer fieldset{--color:#00f;border:1px solid var(--color);border-radius:4px;padding:1px;display:inline-flex;position:absolute;right:15%}body>footer fieldset label{cursor:pointer;text-align:center;width:42px;color:var(--color);box-sizing:border-box;border-radius:2px;margin:0;padding:2px 6px;font-size:12px;line-height:15px}body>footer fieldset label:has(input:checked){color:#fff;background-color:var(--color)}body>footer fieldset label input{display:none}
"""#.utf8))
    
    // MARK: Icons

    /// The icon that DocC displays for API collection pages and their references in curation or the navigation hierarchy.
    static let apiCollectionIcon = File(filename: "api-collection.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="14px" height="14px" viewBox="0 0 14 14" fill="#666">
  <path d="m1 1v12h12v-12zm11 11h-10v-10h10z"/>
  <path d="m3 4h8v1h-8zm0 2.5h8v1h-8zm0 2.5h8v1h-8z"/>
  <path d="m3 4h8v1h-8z"/>
  <path d="m3 6.5h8v1h-8z"/>
  <path d="m3 9h8v1h-8z"/>
</svg>
""".utf8))

    /// The icon that DocC displays for article pages and their references in curation or the navigation hierarchy.
    static let articleIcon = File(filename: "article.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="15px" height="15px" viewBox="0 0 14 14" fill="#666">
  <path d="M8.033 1l3.967 4.015v7.985h-10v-12zM7.615 2h-4.615v10h8v-6.574z"></path>
  <path d="M7 1h1v4h-1z"></path>
  <path d="M7 5h5v1h-5z"></path>
</svg>
""".utf8))

    /// The icon that DocC displays for module/framework pages and their references in curation or the navigation hierarchy.
    static let moduleIcon = File(filename: "module.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="15px" height="15px" viewBox="0 0 14 14" fill="#666">
  <path d="M3.39,9l3.16,1.84.47.28.47-.28L10.61,9l.45.26,1.08.63L7,12.91l-5.16-3,1.08-.64L3.39,9M7,0,0,4.1,2.47,5.55,0,7,2.47,8.44,0,9.9,7,14l7-4.1L11.53,8.45,14,7,11.53,5.56,14,4.1ZM7,7.12,5.87,6.45l-1.54-.9L3.39,5,1.85,4.1,7,1.08l5.17,3L10.6,5l-.93.55-1.54.91ZM7,10,3.39,7.9,1.85,7,3.4,6.09,4.94,7,7,8.2,9.06,7,10.6,6.1,12.15,7l-1.55.9Z"/>
</svg>
""".utf8))

    /// The icon that DocC uses for the button to show and hide the on-page sidebar / navigation hierarchy.
    static let sidebarIcon = File(filename: "sidebar.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="19px" height="19px" viewBox="0 -1 14 14">
  <path d="M6.533 1.867h-6.533v10.267h14v-10.267zM0.933 11.2v-8.4h4.667v8.4zM13.067 11.2h-6.533v-8.4h6.533z M1.867 5.133h2.8v0.933h-2.8z M1.867 7.933h2.8v0.933h-2.8z" />
</svg>

""".utf8))

    /// The icon that DocC displays, on-hover, next to headings that are links to themselves.
    static let anchorIcon = File(filename: "anchor.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="16px" height="16px" viewBox="0 0 20 20" fill="#666">
  <path d="M19.34,4.88L15.12,.66c-.87-.87-2.3-.87-3.17,0l-3.55,3.56-1.38,1.38-1.4,1.4c-.47,.47-.68,1.09-.64,1.7,.02,.29,.09,.58,.21,.84,.11,.23,.24,.44,.43,.63l4.22,4.22h0l.53-.53,.53-.53h0l-4.22-4.22c-.29-.29-.29-.77,0-1.06l1.4-1.4,.91-.91,.58-.58,.55-.55,2.9-2.9c.29-.29,.77-.29,1.06,0l4.22,4.22c.29,.29,.29,.77,0,1.06l-2.9,2.9c.14,.24,.24,.49,.31,.75,.08,.32,.11,.64,.09,.96l3.55-3.55c.87-.87,.87-2.3,0-3.17Z"/>
  <path d="M14.41,9.82s0,0,0,0l-4.22-4.22h0l-.53,.53-.53,.53h0l4.22,4.22c.29,.29,.29,.77,0,1.06l-1.4,1.4-.91,.91-.58,.58-.55,.55h0l-2.9,2.9c-.29,.29-.77,.29-1.06,0L1.73,14.04c-.29-.29-.29-.77,0-1.06l2.9-2.9c-.14-.24-.24-.49-.31-.75-.08-.32-.11-.64-.09-.97L.68,11.93c-.87,.87-.87,2.3,0,3.17l4.22,4.22c.87,.87,2.3,.87,3.17,0l3.55-3.55,1.38-1.38,1.4-1.4c.47-.47,.68-1.09,.64-1.7-.02-.29-.09-.58-.21-.84-.11-.22-.24-.44-.43-.62Z"/>
</svg>
""".utf8))

}
