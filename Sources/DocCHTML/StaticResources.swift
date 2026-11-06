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

/// The group of resource files that make up DocC's base "template" for static HTML output.
package enum StaticResources {
    // This type is only responsible for naming the blobs of data. It's the caller's responsibility to work with the file system to write these files into the output location.
    
    package struct File {
        package let filename: String
        package let data: Data
    }
    
    package static let allFiles = [
        referenceStyleSheet,
        // Scripts
        navigatorScript,
        // Page kind icons
        apiCollectionIcon,
        articleIcon,
        moduleIcon,
        // Navigator sidebar icons
        classIcon,
        dictionaryIcon,
        enumerationIcon,
        extensionIcon,
        functionIcon,
        learnIcon,
        macroIcon,
        methodIcon,
        namespaceIcon,
        operatorIcon,
        propertyIcon,
        propertyListKeyIcon,
        protocolIcon,
        sampleCodeIcon,
        structureIcon,
        subscriptIcon,
        tutorialIcon,
        typeAliasIcon,
        unionIcon,
        variableIcon,
        // UI element icons
        anchorIcon,
        sidebarIcon,
        chevronIcon,
        closeIcon,
    ]
    
    // MARK: Stylesheets
    
    // For the future; the idea is that tutorial documentation would have its own stylesheet so that each page's `<head>` can link to only the style information that it needs.
    
    /// The style sheet that DocC uses to define the layout and appearance of "reference" documentation (symbols and articles).
    static let referenceStyleSheet = File(filename: "reference.css", data: Data("""
:root {
  --color-header-text: #1d1d1f;
  --color-code-background: #f7f7f7;
  --color-secondary-label: #6e6e73;
  
  --color-grid: rgb(204, 204, 204);
  
  --color-fill-gray: #ccc;
  --color-fill-gray-quaternary: #f0f0f0;
  --color-fill-gray-secondary: #f5f5f5;
  --color-fill-gray-tertiary: #f0f0f0;
  
  --color-badge-deprecated: #bf4800;
  
  --color-standard-blue: #06c;
  --color-standard-gray: #afafaf;
  --color-standard-green: #509ca3;
  --color-standard-orange: #ff5a00;
  --color-standard-purple: #bf6af7;
  --color-standard-red: #d82797;
  --color-standard-yellow: #ff9f2c;
  
  --color-figure-gray-secondary: rgb(102, 102, 102);
  --color-figure-blue: rgb(51, 102, 255);
  
  --font-default: "Helvetica Neue", Helvetica, Arial, sans-serif;
  --font-mono: Menlo, monospace;
}

/* Hide and show language specific content by modifying these classes through JS */
.swift-only {
  display: unset;
}
.occ-only {
  display: none;
}

* {
  margin: 0;
}

body {
  font-family: var(--font-default);
  
  font-synthesis: none;
  -moz-font-feature-settings: 'kern';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: start;
  overflow-wrap: break-word;
  
  /* Default margin for stacked elements. */
  --spacing-stacked-margin-small: 0.4em;

  /* Default margin-top for subsequent elements. */
  --spacing-stacked-margin-large: 0.8em;

  /* Default margin for elements that require extra spacing */
  --spacing-stacked-margin-xlarge: calc(var(--spacing-stacked-margin-large) * 2);

  /* Default param spacing */
  --spacing-param: 28px;

  /* Default margin for Code Listing in Declaration */
  --declaration-code-listing-margin: 30px 0 0 0;

  /* Default padding for Code Blocks */
  --code-block-style-elements-padding: 8px 14px;
}

section {
  max-width: 820px;
  margin: 0 auto;
  
  @media only screen and (max-width: 1250px) {
    padding-left: 80px;
    padding-right: 80px;
  }
  
  @media only screen and (max-width: 735px) {
    padding-left: 20px;
    padding-right: 20px;
  }
  
  @media only screen and (min-width: 1500px) {
    max-width: 920px;
  }
}

/* Draw a separator between the Topics section and any non-"hero" section (with a background) before it */
article > section:not(#hero) + #Topics,
/* Draw a separator between the See Also section and any non-"hero" section (with a background) before it */
article > section:not(#hero) + #See-also,
/* Draw a separator between the Relationships section and any non-"hero" section (with a background) before it */
article > section:not(#hero) + #Relationships,
/* Draw a separator between the Default Implementations section and any non-"hero" section (with a background) before it */
article > section:not(#hero) + #Default-implementations,
/* Draw a separator between a symbol's first and second sections */
article > section:first-of-type:not(#hero) + section
{
  &:before {
    content: "";
    display: block;
    width: 100%;
    background: var(--color-grid);
    height: 1px;
    margin-bottom: 40px;
  }
}

hr {
  max-width: 820px;
  margin: 0 auto;
  
  @media only screen and (max-width: 1250px) {
    max-width: 660px;
  }
  
  @media only screen and (max-width: 820px) {
    margin: 0 80px;
  }
  
  @media only screen and (max-width: 735px) {
    margin: 0 20px;
  }
  
  @media only screen and (min-width: 1500px) {
    max-width: 920px;
  }
}

section {
  box-sizing: border-box;

  padding-top: 40px;
  padding-bottom: 40px;
  
  @media print {
    padding-left: 80px;
    padding-right: 80px;
    max-width: none;
  }
}

section + section {
  /* avoid double padding between sections */
  padding-top: 0;
}

hr {
  border: none;
  background: var(--color-grid);
  height: 1px;
}

h1, h2, h3 {
  font-weight: 400;
}

h4, h5, h6 {
  font-weight: 600;
}

h1 {
  font-size: 40px;
  line-height: 44px;
  margin-top: 1.6em;
  
  @media only screen and (max-width: 1250px) {
    font-size: 32px;
    line-height: 36px;
  }
  
  @media only screen and (max-width: 735px) {
    font-size: 28px;
    line-height: 32px;
  }
}

h2 {
  font-size: 32px;
  line-height: 36px;
  margin-top: 1.6em;
  
  @media only screen and (max-width: 1250px) {
    font-size: 28px;
    line-height: 32px;
  }
  
  @media only screen and (max-width: 735px) {
    font-size: 24px;
    line-height: 28px;
  }
}

h3 {
  /* Note that this is different inside a Topics/SeeAlso section */
  font-size: 28px;
  line-height: 32px;
  padding-top: 36px;
  
  @media only screen and (max-width: 1250px) {
    font-size: 24px;
    line-height: 28px;
  }
  
  @media only screen and (max-width: 735px) {
    font-size: 21px;
    line-height: 25px;
  }
}

h4 {
  font-size: 24px;
  line-height: 28px;
  
  @media only screen and (max-width: 1250px) {
    font-size: 21px;
    line-height: 25px;
  }
}

h5 {
   font-size: 22px;
   line-height: 26px;
   
   @media only screen and (max-width: 1250px) {
     font-size: 20px;
     line-height: 24px;
   }
   
   @media only screen and (max-width: 735px) {
     font-size: 18px;
     line-height: 26px;
   }
}

h6 {
  font-size: 17px;
  line-height: 25px;
}

a {
  color: var(--color-figure-blue);
}

picture > img {
  width: 100%;
}

/* The "eyebrow" subheading */
section:first-of-type > hgroup > p {
  font-size: 21px;
  line-height: 25px;
  margin: 0;
  margin-bottom: 15px;
  color: var(--color-figure-gray-secondary);
  
  @media only screen and (max-width: 1250px) {
    font-size: 19px;
    line-height: 23px;
  }

  /* Workaround some margin issues with H1 elements in the authored content. */
  &+ h1 {
    margin-top: 0;
  }
}

#breadcrumbs > ul {
  padding: 0;
  margin-bottom: 20px;
  display: flex;
  list-style-type: none;
  
  &>li {
    font-size: 14px;
    line-height: 20px;
    a {
      color: #000;
    }
    
    &:not(:first-child):before {
      content: "/";
      width: 5px;
      margin-inline: 5px;
    }
  }
}

#availability {
  padding: 0;
  margin-top: 15px;
  margin-bottom: 20px;
  display: flex;
  flex-wrap: wrap;
  gap: 11px;
  list-style-type: none;
  
  align-items: center;
  
  &>li {
    font-size: 14px;
    line-height: 20px;
    height: 20px;
    
    &:not(:last-child):after {
      content: "";
      display: inline-block;
      height: 14px;
      width: 1px;
      position: relative;
      top: 2px;
      margin-left: 10px;
      
      background-color: black; /* TODO: dark mode */
    }
  }
}

h1, h2, h3, h4, h5, h6 {
  padding-inline-end: 23px; /* for the hover icon */
  
  &> a {
    text-decoration: none;
    color: black; /* TODO: dark mode */
    &:hover {
      &:after {
        margin-left: 7px;
        content: url(anchor.svg)
      }
    }
  }
}

#hero {
  margin-bottom: 40px;
  
  position: relative;
  clip-path: inset(0 -50%);
  
  /* Draw the background in a pseudo element so that it can move behind the icon */
  &:before {
    content: "";
    background: #f0f0f0;
    
    position: absolute;
    top: 0;
    left: calc(50% - 50cqw);
    width: 100cqw;
    height: 100%;
    z-index: -2;
  }
}

/* Add background icons for articles, API collections, and module pages */

#hero.article:after {
  background: url(article.svg);
}

#hero.api-collection:after {
  background: url(api-collection.svg);
}

#hero.module:after {
  background: url(module.svg);
}

#hero.article:after, #hero.api-collection:after, #hero.module:after {
  content: "";
  --icon-size: 250px;
  
  position: absolute;
  top: 10px;
  /* 25px inset from the right edge of the 'main' container */
  right: calc(50% - 50cqw + 25px);
  opacity: 0.15;
  z-index: -1;
  
  width: var(--icon-size);
  height: var(--icon-size);
  background-size: var(--icon-size) var(--icon-size);
}

section :first-child {
  margin-top: 0;
}

/* Abstract */
section:first-of-type > p {
  font-size: 21px;
  line-height: 29px;
  
  margin-top: 12px;
  
  @media only screen and (max-width: 735px) {
    font-size: 19px;
    line-height: 27px;
  }
}

#declaration, pre {
  margin-top: 40px;
  
  background: var(--color-code-background);
  border-color: var(--color-grid);
  border-radius: 4px;
  border-style: solid;
  border-width: 1px;
  padding: var(--code-block-style-elements-padding);
  line-height: 25px;
  
  /* We probably don't need most of these colors because they don't appear in declarations */
  --color-syntax-attributes: rgb(148, 113, 0);
  --color-syntax-characters: rgb(39, 42, 216);
  --color-syntax-comments: rgb(112, 127, 140);
  --color-syntax-deletion: var(--color-figure-red);
  --color-syntax-documentation-markup: rgb(80, 99, 117);
  --color-syntax-documentation-markup-keywords: rgb(80, 99, 117);
  --color-syntax-heading: rgb(186, 45, 162);
  --color-syntax-highlighted: rgba(0, 113, 227, 0.2);
  --color-syntax-keywords: rgb(173, 61, 164);
  --color-syntax-marks: rgb(0, 0, 0);
  --color-syntax-numbers: rgb(39, 42, 216);
  --color-syntax-other-class-names: rgb(112, 61, 170);
  --color-syntax-other-constants: rgb(75, 33, 176);
  --color-syntax-other-declarations: rgb(4, 124, 176);
  --color-syntax-other-function-and-method-names: rgb(75, 33, 176);
  --color-syntax-other-instance-variables-and-globals: rgb(112, 61, 170);
  --color-syntax-other-preprocessor-macros: rgb(120, 73, 42);
  --color-syntax-other-type-names: rgb(112, 61, 170);
  --color-syntax-param-internal-name: rgb(64, 64, 64);
  --color-syntax-plain-text: rgb(0, 0, 0);
  --color-syntax-preprocessor-statements: rgb(120, 73, 42);
  --color-syntax-project-class-names: rgb(62, 128, 135);
  --color-syntax-project-constants: rgb(45, 100, 105);
  --color-syntax-project-function-and-method-names: rgb(45, 100, 105);
  --color-syntax-project-instance-variables-and-globals: rgb(62, 128, 135);
  --color-syntax-project-preprocessor-macros: rgb(120, 73, 42);
  --color-syntax-project-type-names: rgb(62, 128, 135);
  --color-syntax-strings: rgb(209, 47, 27);
  --color-syntax-type-declarations: rgb(3, 99, 140);
  --color-syntax-urls: rgb(19, 55, 255);
  
  &> code {
    display: block;
    
    font-size: 15px;
    line-height: 25px;
    
    .keyword, .attribute {
      color: var(--color-syntax-keywords);
    }
    .internalParam {
      color: var(--color-syntax-param-internal-name);
    }
    .typeIdentifier {
      color: var(--color-syntax-other-type-names);
      &:not(:hover) {
        text-decoration: none;
      }
    }
  }
}

pre {
  margin-top: 2.1em;
}

p {
  font-size: 17px;
  line-height: 24px;
  
  margin-top: 0.8em;
}

/* Parameter and term definition lists */

dl {
  margin-top: 0.85em;
  
  dt {
    font-weight: 600;
    font-size: 17px;
    line-height: 25px;
    font-family: var(--font-mono);
    padding-left: 17px;
    padding-top: var(--spacing-param);
    
    &:first-child {
      padding-top: 0;
    }
    
    @media only screen and (max-width: 735px) {
      padding-left: 0;
    }
  }
  
  dd {
    padding-left: 34px;
    
    p {
      margin: 0;
      line-height: 23px;
    }
    
    @media only screen and (max-width: 735px) {
      padding-left: 0;
    }
  }
}

#Topics, #See-also, #Relationships, #Default-implementations {
  &> ul {
    padding: 0;
    &> li {
      margin-top: 15px;
      list-style: none;
      &> a {
        padding: 5px 0;
        display: inline-flex;
        
        text-decoration: none;
        font-size: 1rem;
        
        &:hover {
          text-decoration: underline;
        }
        
        &> code {
          font-size: 17px;
          line-height: 24px;
          color: rgb(102, 102, 102);
          
          &>b {
            color: var(--color-figure-blue);
            font-weight: normal;
          }
        }
      }
      &> p {
        margin: 0;
        margin-inline-start: 2.294em; /* it's defined like this in DocC Render */
        line-height: 24px;
      }
      
      /* Display icons for articles and API collections */
      .api-collection, .article {
        margin-top: 0px; /* avoid the top padding of other paragraphs */
        
        &:before {
          margin-right: 20px;
          margin-left: 4px;
          width: 36px;
          position: relative;
          top: 2px;
          content: url(api-collection.svg);
        }
      }
      .article:before {
        content: url(article.svg)
      }
    }
  }
  &> h3 {
    font-size: 24px;
    line-height: 28px;
    padding-top: 39px;
    
    @media only screen and (max-width: 1250px) {
      font-size: 21px;
      line-height: 25px;
    }
  }
  &> h2 {
    margin-top: 0px;
  }
  &> p {
    margin-top: 15px;
  }
}

#Relationships > ul {
  &> li {
    margin-top: 0;
    &> a {
      padding: 0;
      &> code {
        line-height: 25px;
        color: var(--color-figure-blue);
      }
    }
  }
  
  &> li:first-child {
      margin-top: 15px;
  }
}

table {
  margin-top: 1.6em;
  margin-bottom: 1.6em;
  
  font-size: 17px;
  line-height: 25px;
  
  border-collapse: collapse;
  border-spacing: 0;
  
  th, td {
    text-align: start;
    padding: 10px;
    
    border: 1px solid #f0f0f0;
  }
  
  /* No border on the outside of the table */
  th {
    border-top: none;
  }
  th:first-of-type {
    border-left: none;
  }
  th:last-of-type {
    border-right: none;
  }
  tr:last-of-type > td {
    border-bottom: none;
  }
  
  tr {
    td:first-of-type {
      border-left: none;
    }
    td:last-of-type {
      border-right: none;
    }
  }
}

#Mentioned-in > ul {
  padding: 0;
  &> li {
    margin-top: 10px;
    list-style: none;
    &> a {
      padding: 5px 0;
      display: inline-flex;
      
      text-decoration: none;
      font-size: 17px;
      
      &:hover {
        text-decoration: underline;
      }
    }
    &> p {
      margin: 0;
      margin-inline-start: 2.294em; /* it's defined like this in DocC Render */
      line-height: 24px;
    }
    
    /* Display an article icons*/
    &:before {
      margin-right: 8px;
      margin-left: 2px;
      width: 36px;
      position: relative;
      top: 2px;
      content: url(article.svg);
    }
  }
}

/* Asides */

aside {
  background-color: rgb(245, 245, 245);
  border: 0px solid rgb(102, 102, 102);
  border-inline-start-width: 6px;
  
  border-radius: 4px;
  padding: 16px;
  
  margin-top: 27px;
  
  .label {
    font-weight: 600;
    margin-top: 0;
  }
  
  
  &> p:nth-of-type(2) {
    margin-top: 0.4em;
  }
}

/* Links */
a {
  color: var(--color-figure-blue);
}

/* Inline Elements */

b, strong {
  font-weight: 600;
}

em, i, cite, dfn {
  font-style: italic;
}

sup {
  font-size: .6em;
  vertical-align: top;
  position: relative;
  bottom: -.2em;
  
  h1 &,
  h2 &,
  h3 & {
    font-size: .4em;
  }
  
  a {
    vertical-align: inherit;
    color: inherit;
    
    &:hover {
      color: var(--color-figure-blue);
      text-decoration: none;
    }
  }
}

sub {
  line-height: 1;
}

abbr {
  border: 0;
}

code {
  font-weight: inherit;
  letter-spacing: 0;
}

/* Scroll the code inside of code blocks */
pre {
  overflow: auto;
  -webkit-overflow-scrolling: auto;
  white-space: pre;
  overflow-wrap: normal;
}

body > header {
  /* The width of the sidebar icon before the header's title */
  --header-icon-width: 30px;
  
  position: sticky;
  top: 0;
  box-sizing: border-box;
  width: 100%;
  height: 52px;
  /* On wide screens, center the header's content in at most 1920px, like the navigator and the page's content. */
  padding-inline: calc(max(0px, (100% - 1920px) / 2) + 22px);
  z-index: 5;
  
  display: flex;
  align-items: center;
  justify-content: space-between;
  
  border-bottom: 1px solid var(--color-grid);
  line-height: 25px;
  
  /* Aim for a light visual effects appearance */
  backdrop-filter: saturate(1.8) blur(20px);
  background-color: rgba(255, 255, 255, 0.7);
  
  h2 {
    float: left;
    font-size: 21px;
    line-height: 25px;
    font-weight: 600;
    margin-top: 0;
    
    &:before {
      width: var(--header-icon-width);
      display: inline-block;
      content: url(sidebar.svg)
    }
  }
  
  /* When the page has a navigator, the button that shows and hides it displays the sidebar icon before the title instead. */
  #navigator-toggle {
    width: var(--header-icon-width);
    height: 25px;
    padding: 0;
    border: none;
    background: url(sidebar.svg) no-repeat left center;
    cursor: pointer;
    
    + h2 {
      margin-right: auto;
      
      &:before {
        content: none;
      }
    }
  }
  
  span {
    float: right;
    line-height: 18px;
    font-size: 14px;
    display: inline-block;
  }
}

.tabnavigator {
  --count: 1;
  --tab-gutter: 30px;
  display: grid;
  /* Size each tab to fit its title and let a trailing column fill the remaining space */
  grid-template-columns: repeat(var(--count), auto) minmax(0, 1fr);
  grid-template-rows: auto 1fr;

  &:not(:first-child) {
    margin-block-start: var(--spacing-stacked-margin-xlarge);
  }

  /* Collapses with the next element's top margin so that elements with larger margins keep them */
  &:not(:last-child) {
    margin-block-end: var(--spacing-stacked-margin-xlarge);
  }

  details {
    --index: 1;
    display: grid;
    grid-column: 1 / -1;
    grid-row: 1 / span 2;
    grid-template-columns: subgrid;
    grid-template-rows: subgrid;

    /* Prevent closing the open tab by clicking its own title, without disabling the tab's content */
    &[open] > summary {
      pointer-events: none;
    }

    /* Closed tabs overlap the open tab's content in the grid, so only their titles should receive clicks */
    &:not([open]) {
      pointer-events: none;

      > summary {
        pointer-events: auto;
      }
    }

    &::details-content {
      grid-column: 1 / -1;
      grid-row: 2;
      min-width: 0;
      padding-block-start: 25px;
    }

    &:not([open])::details-content {
      display: none;
    }

    &:first-child > summary {
      --tab-gutter: 0px;
    }

    /* The tab's content is already spaced out from the titles */
    > summary + * {
      margin-block-start: 0;
    }
  }

  summary {
    position: relative;
    display: grid;
    grid-column: var(--index) / span 1;
    grid-row: 1;
    z-index: 1;
    padding-block: 10px;
    padding-inline-start: var(--tab-gutter);
    border-bottom: 1px solid var(--color-grid);
    color: var(--color-figure-gray-secondary);
    font-size: 14px;
    line-height: 14px;
    cursor: pointer;

    &:focus-visible {
      outline-offset: -1px;
    }

    /* The open tab's indicator only underlines its title, not the gutter before it */
    &::after {
      content: '';
      position: absolute;
      bottom: -1px;
      inset-inline-start: var(--tab-gutter);
      inset-inline-end: 0;
      border-bottom: 1px solid transparent;
    }

    details[open] > & {
      color: inherit;
      cursor: default;

      &::after {
        border-bottom-color: currentColor;
      }
    }
  }
}

/*
 The navigator sidebar.
 Its sizes are in pixels, computed for a 17px root font size.
 */
#navigator {
  --color-figure-orange: rgb(204, 51, 0);
  --color-navigator-item-hover: rgba(0, 0, 255, 0.05);
  /* The space between the navigator's edges and its items, and between the start of an item and its title, so that the titles line up. */
  --navigator-inset: 20px;
  
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  padding-top: 10px;
  border-inline-end: 1px solid var(--color-grid);
  background: white;
  font-size: 17px;
  line-height: 25px;
  
  /* The panel's title and the module's title. */
  h2 {
    margin: 0;
    padding: 0;
    color: black;
    font-weight: 600;
  }
  
  &> header {
    display: none;
    flex: none;
    align-items: center;
    height: 48px;
    margin-inline: var(--navigator-inset);
    
    h2 {
      flex: 1;
      font-size: 17px;
      line-height: 17px;
    }
    
    button {
      width: 19px;
      height: 19px;
      padding: 0;
      border: none;
      background: url(close.svg);
      cursor: pointer;
    }
  }
  
  .technology-title {
    display: flex;
    margin-inline: var(--navigator-inset);
    padding-block: 8px;
    padding-inline: var(--navigator-inset) 10px;
    border-radius: 4px;
    white-space: nowrap;
    text-decoration: none;
    
    h2 {
      overflow: hidden;
      text-overflow: ellipsis;
      font-size: 19px;
      line-height: 23px;
    }
    
    &[aria-current="page"] {
      background: var(--color-fill-gray-quaternary);
    }
    
    &:hover {
      background: var(--color-navigator-item-hover);
    }
  }
  
  /* A "Beta" or "Deprecated" badge after a title */
  .technology-title > span, li > a + span, summary > a + span {
    margin: auto;
    margin-inline-start: 5px;
    padding: 2px 4px;
    border-radius: 1px;
    color: white;
    background-color: var(--color-figure-gray-secondary);
    font-size: 12px;
    line-height: 16px;
    white-space: nowrap;
    
    &.deprecated {
      background-color: var(--color-figure-orange);
    }
  }
  
  &> ul {
    flex: 1 1 auto;
    overflow-y: auto;
    padding: 0 var(--navigator-inset) 10px;
    list-style: none;
    
    /* The lists of an item's children, which indent their items by 15px for each level. */
    ul {
      margin: 0;
      padding: 0;
      list-style: none;
    }
    
    /* Each row is a heading, a list item with a link, or for an item with children, the `<summary>` of a `<details>` element. */
    li > h3, li:has(> a), summary {
      position: relative;
      padding: 5px var(--navigator-inset);
      padding-inline-start: calc(var(--navigator-inset) + var(--depth) * 15px);
    }
    
    /* A row with a badge displays it after the title, which shortens with an ellipsis. */
    li:has(> a + span), summary:has(> a + span) {
      display: flex;
    }
    
    /* The current page's row has a background, behind its title. */
    li:has(> a[aria-current="page"]), summary:has(> a[aria-current="page"]) {
      border-radius: 4px;
      background: var(--color-fill-gray-quaternary);
    }
    
    summary {
      display: block;
      cursor: pointer;
      
      /* The chevron opens and closes the item, so it's above the link's click target. It fills the space before the title, so that it's easy to click. */
      &:before {
        content: "";
        position: absolute;
        z-index: 1;
        top: calc(50% - var(--navigator-inset) / 2);
        inset-inline-start: calc(var(--depth) * 15px);
        width: var(--navigator-inset);
        height: var(--navigator-inset);
        background: url(chevron.svg) no-repeat center / 10px;
        transition: transform 0.15s ease-in;
      }
      
      details[open] > &:before {
        transform: rotate(90deg);
      }
      
      &:is(:hover, :focus-visible) > a:after {
        background: var(--color-navigator-item-hover);
      }
    }
    
    /* The reader moves the focus between the titles with the arrow keys, and the focused title's row displays the focus ring. */
    li:has(> :is(a, h3):focus-visible), summary:has(> a:focus-visible) {
      outline: 4px solid rgba(0, 125, 250, 0.6);
      outline-offset: -4px;
    }
    
    li {
      a, h3 {
        outline: none;
        display: block;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }
      
      a {
        color: inherit;
        text-decoration: none;
        
        /* Make the entire row a click target for the link, with a background on hover or keyboard focus */
        &:after {
          content: "";
          position: absolute;
          inset: 0;
          border-radius: 4px;
        }
        
        &:is(:hover, :focus-visible):after {
          background: var(--color-navigator-item-hover);
        }
        
        /* The current page and the items leading to it are bold. */
        &[aria-current="page"], details:has([aria-current="page"]) > summary > & {
          font-weight: 600;
        }
        
        /* The icon for the item's type. Each type's icon is an SVG file, so that a custom style sheet can replace it. Other types use the API collection icon. */
        &[data-type="article"] { --navigator-icon: url(article.svg); }
        &[data-type="case"], &[data-type="enum"], &[data-type="httpRequest"] { --navigator-icon: url(enumeration.svg); }
        &[data-type="class"] { --navigator-icon: url(class.svg); }
        &[data-type="dictionarySymbol"] { --navigator-icon: url(dictionary.svg); }
        &[data-type="extension"] { --navigator-icon: url(extension.svg); }
        &[data-type="func"] { --navigator-icon: url(function.svg); }
        &[data-type="init"], &[data-type="method"] { --navigator-icon: url(method.svg); }
        &[data-type="learn"], &[data-type="overview"], &[data-type="resources"] { --navigator-icon: url(learn.svg); }
        &[data-type="macro"] { --navigator-icon: url(macro.svg); }
        &[data-type="module"] { --navigator-icon: url(module.svg); }
        &[data-type="namespace"] { --navigator-icon: url(namespace.svg); }
        &[data-type="op"] { --navigator-icon: url(operator.svg); }
        &[data-type="project"], &[data-type="tutorial"] { --navigator-icon: url(tutorial.svg); }
        &[data-type="property"] { --navigator-icon: url(property.svg); }
        &[data-type="propertyListKey"], &[data-type="propertyListKeyReference"] { --navigator-icon: url(property-list-key.svg); }
        &[data-type="protocol"] { --navigator-icon: url(protocol.svg); }
        &[data-type="sampleCode"] { --navigator-icon: url(sample-code.svg); }
        &[data-type="struct"] { --navigator-icon: url(structure.svg); }
        &[data-type="subscript"] { --navigator-icon: url(subscript.svg); }
        &[data-type="typealias"] { --navigator-icon: url(type-alias.svg); }
        &[data-type="union"] { --navigator-icon: url(union.svg); }
        &[data-type="var"] { --navigator-icon: url(variable.svg); }
        
        &:before {
          content: "";
          display: inline-block;
          width: 1em;
          height: 1em;
          margin-inline-end: 7px;
          margin-top: calc((25px - 1em) / 2);
          vertical-align: top;
          background: var(--navigator-icon, url(api-collection.svg)) no-repeat center / contain;
        }
      }
      
      h3 {
        color: var(--color-figure-gray-secondary);
        font-size: inherit;
        line-height: inherit;
        font-weight: 600;
      }
    }
  }
}

/* On narrow screens, the navigator is a panel that slides in over the page's content when the reader opens it, and hides after it slides out. */
@media only screen and (max-width: 1023px) {
  #navigator {
    position: fixed;
    inset: 0;
    z-index: 6;
    padding-top: 0;
    border-inline-end: none;
    visibility: hidden;
    transform: translateX(-100%);
    /* The panel stays visible while it slides out, because `visibility` transitions as visible until it ends. */
    transition: transform 0.15s ease-in, visibility 0.15s;
  }
  
  body.navigator-open #navigator {
    visibility: visible;
    transform: none;
    /* The panel is visible as soon as it opens, so that its close button can have the focus. */
    transition-property: transform;
  }
  
  #navigator > header {
    display: flex;
  }
  
  /* Scrolling past the end of the panel's items doesn't scroll the page behind it. */
  #navigator > ul {
    overscroll-behavior: contain;
  }
}

/* The navigator and the page's main content display next to each other. */
.full-width-container {
  display: flex;
  max-width: 1920px;
  margin-inline: auto;
  
  > main {
    flex: 1;
    min-width: 0;
    container-type: inline-size;
  }
}

@media only screen and (min-width: 1920px) {
  .full-width-container {
    box-sizing: border-box;
    border-inline: 1px solid var(--color-grid);
  }
}

/* On wider screens, the navigator displays in a column next to the page's content, unless the reader hides it. */
@media only screen and (min-width: 1024px) {
  #navigator {
    /*
     The width is 400px, or 543px on wide windows, unless the reader resizes it,
     but always between 30% and 40% of the window width, up to a 1521px wide window.
     */
    --navigator-default-width: 400px;
    
    flex: none;
    width: clamp(calc(min(100vw, 1521px) * 0.3), var(--navigator-preferred-width, var(--navigator-default-width)), calc(min(100vw, 1521px) * 0.4));
    position: sticky;
    top: 52px;
    height: calc(100vh - 52px);
    /* The column stays visible while it narrows or widens, because `visibility` transitions as visible until it ends. */
    transition: width 0.3s ease-in, visibility 0.3s;
  }
  
  @media (min-width: 1521px) {
    #navigator {
      --navigator-default-width: 543px;
    }
  }
  
  /* The navigator narrows to nothing when the reader hides it, and hides after that. */
  body.navigator-collapsed #navigator {
    width: 0;
    /* The navigator's border doesn't take up space either. */
    margin-inline-end: -1px;
    visibility: hidden;
  }
  
  /* The handle on the navigator's edge that resizes it, which the navigator script adds */
  #navigator .resize-handle {
    position: absolute;
    inset-block: 0;
    inset-inline-end: 0;
    z-index: 1;
    width: 5px;
    transform: translateX(50%);
    cursor: col-resize;
    touch-action: none;
    transition: background-color 0.15s;
    
    &:hover {
      background: var(--color-fill-gray-tertiary);
    }
  }
  
  body.navigator-resizing * {
    cursor: col-resize !important;
    user-select: none;
  }
  
  /* The navigator follows the pointer without a transition. */
  body.navigator-resizing #navigator {
    transition: none;
  }
}

@media (prefers-reduced-motion: reduce) {
  #navigator {
    transition: none;
  }
}

body > footer {
  width: 100%;
  height: 63px;
  
  display: flex;
  align-items: center;
  justify-content: space-between;
  
  border-top: 1px solid var(--color-grid);
  line-height: 25px;
  
  fieldset {
    legend {
      /* This is copied from Swift-DocC Render to make the legend "invisible" without display:none */
      position: absolute;
      clip: rect(1px,1px,1px,1px);
      clip-path: inset(0 0 99.9% 99.9%);
      overflow: hidden;
      height: 1px;
      width: 1px;
    }
    
    display: inline-flex;
    --color: rgb(0, 0, 255);
    
    border: 1px solid var(--color);
    border-radius: 4px;
    padding: 1px;
    
    position: absolute;
    right: 15%; /* FIXME: Position this properly */
    
    label {
      margin: 0;
      cursor: pointer;
      
      width: 42px;
      text-align: center;
      
      color: var(--color);
      font-size: 12px;
      padding: 2px 6px;
      line-height: 15px;
      border-radius: 2px;
      
      box-sizing: border-box;
      
      &:has(input:checked) {
        color: white;
        background-color: var(--color);
      }
      
      input {
        display: none;
      }
    }
  }
}

figure, picture {
    display: block;
    margin-top: var(--spacing-stacked-margin-xlarge);
}

figcaption {
    text-align: center;
    
    p {
      font-size: 0.82rem;
    }
}

.row {
    display: flex;
    flex-wrap: wrap;
    gap: 1.5rem;
    margin-top: var(--spacing-stacked-margin-xlarge);
}

.row > div {
    /* column-size acts as a proportion; */
    flex: var(--column-size, 1) 1 0;
    text-align: var(--alignment, center);
    min-width: 0; /* lets long columns shrink below their content's width and scroll */
    
    @media only screen and (max-width: 735px) {
        flex-basis: 100%;
    }
}
""".utf8))
    
    // MARK: Scripts
    
    /// The script that renders the navigator sidebar from the navigator index and lets the reader show and hide it.
    package static let navigatorScript = File(filename: "navigator.js", data: Data("""
// Renders the navigator sidebar from the navigator index in the output's "index/index.json" file.
//
// Each page is a separate document. To keep the navigator's state across pages,
// this script stores which items are open, which item the reader clicked, and the scroll position in the session storage.
(async () => {
  // The script reads its own element before it waits for the navigator index, because `document.currentScript` is only set until then.
  const script = document.currentScript;
  // Browsers don't let pages from a "file://" URL fetch other files, so the navigator needs the output to be on a web server.
  const index = await fetch(new URL("index/index.json", script.src)).then((response) => response.ok ? response.json() : null).catch(() => null);
  if (!index) {
    return;
  }
  
  // This script is in the root of the output.
  const rootURL = new URL(".", script.src);
  // Like the page's own links, the navigator's links are relative to the page, for example "../../", so that the output works from any location or hosting path.
  const pathToRoot = script.getAttribute("src").replace(/[^/]*$/, "");
  
  // Returns the navigator index path, for example "/documentation/mykit/myclass", of a link to a page in this output.
  function indexPathForLink(href) {
    const path = new URL(href, location.href).pathname.slice(rootURL.pathname.length).replace(/[/]?(index[.]html)?$/, "");
    return "/" + decodeURIComponent(path).toLowerCase();
  }
  const currentPath = indexPathForLink(location.href);
  
  // Returns the link to a page's file, without encoding characters that are common in symbol names, like ":" or "(".
  function hrefForPath(path) {
    const components = path.split("/").filter(Boolean).map((component) => encodeURI(component).replace(/[#?]/g, encodeURIComponent));
    return pathToRoot + components.join("/") + "/index.html";
  }
  
  // Accessing storage throws when the browser or the reader disables it. Then the navigator's state only lasts for the page.
  function withStorage(body) {
    try {
      return body();
    } catch {}
  }
  
  // MARK: Navigator data
  
  const languages = index.interfaceLanguages;
  const modules = languages.swift?.length ? languages.swift : Object.values(languages).find((modules) => modules.length);
  // In rare cases there are multiple top-level roots. Prefer the one whose path matches the current page.
  const rootPath = currentPath.split("/").slice(0, 3).join("/");
  const rootModule = modules?.find(({ path }) => path?.toLowerCase() === rootPath) ?? modules?.[0];
  if (!rootModule?.path || !rootModule.children?.length) {
    return;
  }
  const technologyPath = rootModule.path.toLowerCase();
  
  // Returns the first item with the path and the items leading to it, searching the items and their children depth first.
  function findItemPath(items, path) {
    for (const item of items) {
      if (item.path?.toLowerCase() === path) {
        return [item];
      }
      const childPath = findItemPath(item.children ?? [], path);
      if (childPath) {
        return [item, ...childPath];
      }
    }
    return null;
  }
  
  // Follow the page's breadcrumbs, excluding the technology root, to find the current page in the location that it belongs.
  function breadcrumbsActivePath() {
    const breadcrumbs = [...document.querySelectorAll("#breadcrumbs a[href]")].map((link) => indexPathForLink(link.href));
    const activePath = [];
    for (const path of [...breadcrumbs.slice(1), currentPath]) {
      const items = activePath.length
        ? (activePath.at(-1).children ?? []).filter((child) => child.path?.toLowerCase() === path).slice(0, 1)
        : findItemPath(rootModule.children, path) ?? [];
      if (!items.length) {
        break;
      }
      activePath.push(...items);
    }
    return activePath;
  }
  
  // The previous page's state. Items are identified by their trail, the paths of the items leading to them and their own, from the top of the hierarchy.
  // The key includes the output's location, so that outputs on the same origin don't share their state.
  const storageKey = `docc.navigator.${rootURL.pathname}${technologyPath.slice(1)}`;
  const restoredState = withStorage(() => JSON.parse(sessionStorage.getItem(storageKey))) ?? {};
  
  // Returns the items along a trail, if the navigator has all of them.
  function itemsForTrail(trail) {
    const items = [];
    let candidates = rootModule.children;
    for (const path of trail) {
      const item = candidates.find((child) => child.path?.toLowerCase() === path);
      if (!item) {
        return null;
      }
      items.push(item);
      candidates = item.children ?? [];
    }
    return items;
  }
  
  // If the reader navigated from another item in the navigator, prefer that item, or one of its children, siblings, or the items leading to it,
  // so that a page that's curated in more than one place stays in the location where the reader clicked it.
  function restoredActivePath(trail) {
    if (!Array.isArray(trail) || !trail.length) {
      return null;
    }
    const candidates = [trail, [...trail, currentPath], [...trail.slice(0, -1), currentPath], ...trail.map((_, end) => trail.slice(0, end + 1))];
    for (const candidate of candidates) {
      const items = candidate.at(-1) === currentPath ? itemsForTrail(candidate) : null;
      if (items) {
        return items;
      }
    }
    return null;
  }
  
  const activePath = restoredActivePath(restoredState.activeTrail) ?? breadcrumbsActivePath();
  const activeItems = new Set(activePath);
  
  function makeBadge(variant) {
    const badge = document.createElement("span");
    badge.className = variant;
    badge.textContent = variant === "deprecated" ? "Deprecated" : "Beta";
    return badge;
  }
  
  // The functions that create the children of each item that has them, by the item's `<details>` element, until the item's children exist.
  const childListMakers = new WeakMap();
  
  // Creates the item's children, unless it already has them.
  function makeChildren(details) {
    const makeChildList = childListMakers.get(details);
    if (makeChildList) {
      childListMakers.delete(details);
      details.append(makeChildList());
    }
  }
  
  // Opens or closes an item, which creates the item's children the first time it opens.
  function setOpen(details, shouldOpen) {
    if (shouldOpen) {
      makeChildren(details);
    }
    details.open = shouldOpen;
  }
  
  // Opens or closes an item and all the items inside it.
  function setFullTreeOpen(details, shouldOpen) {
    setOpen(details, shouldOpen);
    for (const child of details.querySelectorAll(":scope > ul > li > details")) {
      setFullTreeOpen(child, shouldOpen);
    }
  }
  
  let labelCount = 0;
  
  // Each item is a list item with a link to its page, or with a heading for a group of pages.
  // An item with children holds a `<details>` element whose `<summary>` holds the link, and the script creates the item's children the first time it opens, so that large hierarchies stay fast.
  function makeRow(item, depth, isInBetaItem, position, siblingsCount, parentTitle) {
    const isGroupMarker = item.type === "groupMarker";
    
    const title = document.createElement(isGroupMarker ? "h3" : "a");
    if (!isGroupMarker) {
      title.href = hrefForPath(item.path);
    }
    title.textContent = item.title;
    // The reader moves the focus between the titles with the arrow keys, and the Tab key only stops at one of them.
    title.tabIndex = -1;
    // Each title describes its position among its siblings to screen readers.
    const label = document.createElement("span");
    label.hidden = true;
    label.id = `navigator-label-${labelCount++}`;
    const childrenCount = isGroupMarker ? 0 : item.children?.length ?? 0;
    label.textContent = `${position + 1} of ${siblingsCount} symbols inside ${parentTitle}`
      + (childrenCount ? ` containing ${childrenCount === 1 ? "one symbol" : `${childrenCount} symbols`}` : "");
    title.setAttribute("aria-describedby", `${label.id} navigator-usage`);
    // The active item can be an ancestor of the current page, when the page isn't in the navigator.
    if (item === activePath.at(-1) && item.path?.toLowerCase() === currentPath) {
      title.setAttribute("aria-current", "page");
    }
    if (!isGroupMarker) {
      // The style sheet displays the icon for the item's type, unless the page has its own icon image.
      title.dataset.type = item.type;
      const imageURL = index.references?.[item.icon]?.variants?.[0]?.url;
      if (imageURL) {
        title.style.setProperty("--navigator-icon", `url(${JSON.stringify(pathToRoot + imageURL.slice(1))})`);
      }
    }
    
    // If the item's parent or the module is beta, the item doesn't display its own "Beta" badge.
    const badge = item.deprecated ? makeBadge("deprecated") : item.beta && !isInBetaItem ? makeBadge("beta") : null;
    
    const row = document.createElement("li");
    if (isGroupMarker || !item.children?.length) {
      row.append(label, title, ...(badge ? [badge] : []));
      return row;
    }
    
    const summary = document.createElement("summary");
    // The summary's title has the focus instead of the summary.
    summary.tabIndex = -1;
    summary.append(title, ...(badge ? [badge] : []));
    const details = document.createElement("details");
    details.append(summary);
    childListMakers.set(details, () => makeList(item.children, depth + 1, isInBetaItem || item.beta, item.title));
    details.addEventListener("toggle", () => {
      if (details.open) {
        makeChildren(details);
        return;
      }
      // If the title that the reader can focus with the Tab key is inside the item, the item's own title takes its place.
      const tabbableTitle = details.querySelector(':scope > ul [tabindex="0"]');
      if (tabbableTitle) {
        tabbableTitle.tabIndex = -1;
        title.tabIndex = 0;
      }
    });
    // The items leading to the active item, and the active item, start open with their children, so that the navigator can scroll to the active item.
    if (activeItems.has(item)) {
      setOpen(details, true);
    }
    row.append(label, details);
    return row;
  }
  
  function makeList(items, depth, isInBetaItem, parentTitle) {
    const list = document.createElement("ul");
    list.style.setProperty("--depth", depth);
    list.append(...items.map((item, position) => makeRow(item, depth, isInBetaItem, position, items.length, parentTitle)));
    return list;
  }
  
  const technologyTitle = document.createElement("a");
  technologyTitle.className = "technology-title";
  technologyTitle.href = hrefForPath(technologyPath);
  technologyTitle.innerHTML = `<h2></h2>`;
  technologyTitle.firstChild.textContent = rootModule.title;
  if (rootModule.beta) {
    technologyTitle.append(makeBadge("beta"));
  }
  if (technologyPath === currentPath) {
    technologyTitle.setAttribute("aria-current", "page");
  }
  
  const list = makeList(rootModule.children, 0, rootModule.beta, rootModule.title);
  const usageLabel = document.createElement("span");
  usageLabel.hidden = true;
  usageLabel.id = "navigator-usage";
  usageLabel.textContent = "To navigate the symbols, press Up Arrow, Down Arrow, Left Arrow or Right Arrow";
  
  // Scrolls the current page's item into view, unless it's already visible.
  function scrollToActiveItem() {
    const element = list.querySelector('[aria-current="page"]')?.closest("summary, li");
    if (!element?.checkVisibility()) {
      return;
    }
    const listBounds = list.getBoundingClientRect();
    const elementBounds = element.getBoundingClientRect();
    if (elementBounds.top < listBounds.top || elementBounds.bottom > listBounds.bottom) {
      list.scrollTop += elementBounds.top - listBounds.top;
    }
  }
  
  // On narrow screens, the navigator has a title and a button that closes it.
  const head = document.createElement("header");
  head.innerHTML = `<h2>Documentation</h2><button type="button" aria-label="Close Documentation Navigator"></button>`;
  const closeButton = head.lastChild;
  
  // The navigator goes before the page's main content, in the container below the page's header, and the button that shows and hides the navigator goes in the header.
  const navigator = document.createElement("nav");
  navigator.id = "navigator";
  navigator.setAttribute("aria-label", "Documentation Navigator");
  navigator.append(head, technologyTitle, list, usageLabel);
  const container = document.querySelector("body > .full-width-container");
  const main = container.querySelector(":scope > main");
  main.before(navigator);
  // The page's default header is right before the container, after any custom header. The button goes before its title, so that it isn't part of the heading.
  const headerTitle = container.previousElementSibling.querySelector("h2");
  headerTitle.insertAdjacentHTML("beforebegin", `<button type="button" id="navigator-toggle" aria-controls="navigator" aria-label="Documentation Navigator"></button>`);
  const toggle = headerTitle.previousElementSibling;
  
  // Returns the `<details>` element of the title's item, if the item has children.
  const detailsForTitle = (title) => title.parentElement.localName === "summary" ? title.parentElement.parentElement : null;
  // Returns the title of the item that contains the title's item, if there is one.
  const parentItemTitle = (title) => title.closest("ul").parentElement.querySelector(":scope > summary > a");
  // The titles of the items inside open items, in the order that the navigator displays them.
  const visibleTitles = () => [...list.querySelectorAll("a, h3")].filter((title) => title.checkVisibility());
  
  // The title that has the focus is the only title that the reader can focus with the Tab key.
  // When an item's summary gets the focus, for example when the reader clicks its chevron, its title gets the focus instead.
  list.addEventListener("focusin", (event) => {
    if (event.target.localName === "summary") {
      event.target.querySelector(":scope > a").focus({ preventScroll: true });
      return;
    }
    list.querySelector('[tabindex="0"]')?.setAttribute("tabindex", "-1");
    event.target.tabIndex = 0;
    event.target.closest("summary, li").scrollIntoView({ block: "nearest" });
  });
  
  list.addEventListener("keydown", (event) => {
    const title = event.target.closest("a, h3");
    if (!title) {
      return;
    }
    const details = detailsForTitle(title);
    const hasModifiers = event.metaKey || event.ctrlKey || event.shiftKey;
    const isDown = event.key === "ArrowDown";
    switch (event.key) {
      case "ArrowUp":
      case "ArrowDown":
        if (event.altKey || !hasModifiers) {
          event.preventDefault();
          // Option-Up and Option-Down move the focus to the first and last item.
          const titles = visibleTitles();
          titles[event.altKey ? (isDown ? titles.length - 1 : 0) : titles.indexOf(title) + (isDown ? 1 : -1)]?.focus({ preventScroll: true });
        }
        break;
      case "ArrowLeft":
        // Shortcuts like Command-Left, which goes back in the browser's history, keep working.
        if (hasModifiers) {
          break;
        }
        event.preventDefault();
        // Close the item or, if it's already closed, move the focus to the item that contains it.
        if (details?.open) {
          setOpen(details, false);
        } else {
          parentItemTitle(title)?.focus({ preventScroll: true });
        }
        break;
      case "ArrowRight":
        if (hasModifiers) {
          break;
        }
        event.preventDefault();
        // Option-Right opens or closes the item and all the items inside it.
        if (details && event.altKey) {
          setFullTreeOpen(details, !details.open);
        } else if (details) {
          setOpen(details, true);
        }
        break;
    }
  });
  
  // Returns the trail of the item with the title.
  function trailForTitle(title) {
    const trail = [];
    for (let row = title.closest("li"); row; row = row.parentElement.closest("li")) {
      trail.unshift(indexPathForLink(row.querySelector(":scope > a, :scope > details > summary > a").href));
    }
    return trail;
  }
  
  let clickedTrail = null;
  
  // Option-clicking an item opens or closes it and all the items inside it, and Command-clicking an item's chevron opens or closes it and its siblings.
  list.addEventListener("click", (event) => {
    const row = event.target.closest("summary, li");
    const details = row?.localName === "summary" ? row.parentElement : null;
    if (event.altKey && details) {
      event.preventDefault();
      setFullTreeOpen(details, !details.open);
    } else if (event.metaKey && event.target.localName === "summary") {
      event.preventDefault();
      const shouldOpen = !details.open;
      for (const sibling of details.parentElement.parentElement.querySelectorAll(":scope > li > details")) {
        setOpen(sibling, shouldOpen);
      }
    } else if (event.target.closest("a") && !event.metaKey && !event.ctrlKey && !event.shiftKey && !event.altKey) {
      // Remember which item the reader clicked, so that the next page displays it as the active item, even if the page is curated in more than one place.
      clickedTrail = trailForTitle(event.target.closest("a"));
    }
  });
  
  // Option-clicking the module's title opens or closes all items.
  let areAllItemsOpen = false;
  technologyTitle.addEventListener("click", (event) => {
    if (event.altKey) {
      event.preventDefault();
      areAllItemsOpen = !areAllItemsOpen;
      for (const details of list.querySelectorAll(":scope > li > details")) {
        setFullTreeOpen(details, areAllItemsOpen);
      }
    }
  });
  
  window.addEventListener("pagehide", () => withStorage(() => {
    // The open items include the ones inside closed items, so that opening those items again on the next page brings back the same state.
    const openItems = [...list.querySelectorAll("details[open] > summary > a")].map(trailForTitle);
    const activeTrail = clickedTrail ?? activePath.map((item) => item.path.toLowerCase());
    sessionStorage.setItem(storageKey, JSON.stringify({ openItems, activeTrail, scrollTop: list.scrollTop }));
  }));
  
  // Keep the items that were open on the previous page open.
  for (const trail of Array.isArray(restoredState.openItems) ? restoredState.openItems.filter(Array.isArray) : []) {
    let container = list;
    let details = null;
    for (const path of trail) {
      details = [...container.querySelectorAll(":scope > li > details")].find((candidate) => indexPathForLink(candidate.querySelector(":scope > summary > a").href) === path);
      if (!details) {
        break;
      }
      // The items leading to an open item stay open or closed as they were, but they need their children.
      makeChildren(details);
      container = details.querySelector(":scope > ul");
    }
    if (details) {
      setOpen(details, true);
    }
  }
  
  // The current page's item is the one that the reader can focus with the Tab key.
  (list.querySelector('[aria-current="page"]') ?? list.querySelector("a, h3")).tabIndex = 0;
  
  // On wide screens the navigator is visible unless the reader hides it. On narrow screens it's hidden unless the reader opens it.
  const wideScreen = matchMedia("(min-width: 1024px)");
  const collapsedStorageKey = "docc.navigator.collapsed";
  
  function updateToggle() {
    const isVisible = wideScreen.matches
      ? !document.body.classList.contains("navigator-collapsed")
      : document.body.classList.contains("navigator-open");
    toggle.setAttribute("aria-expanded", isVisible);
    if (isVisible) {
      scrollToActiveItem();
    }
  }
  
  document.body.classList.toggle("navigator-collapsed", withStorage(() => localStorage.getItem(collapsedStorageKey)) === "true");
  
  // On narrow screens the navigator is a panel over the page, so the rest of the page is inert while the panel is open,
  // the panel's close button has the focus when it opens, and the button that opened it has the focus when it closes.
  function setPanelOpen(isOpen) {
    const isChanging = document.body.classList.contains("navigator-open") !== isOpen;
    document.body.classList.toggle("navigator-open", isOpen);
    for (const element of [...document.body.children, main]) {
      element.inert = isOpen && element !== container;
    }
    updateToggle();
    if (isChanging) {
      (isOpen ? closeButton : toggle).focus();
    }
  }
  
  wideScreen.addEventListener("change", () => {
    // The navigator switches between the column and the panel without a transition.
    navigator.style.transition = "none";
    setPanelOpen(false);
    // Reading a layout value applies the new styles while the transition is off.
    navigator.offsetWidth;
    navigator.style.transition = "";
  });
  
  toggle.addEventListener("click", () => {
    if (wideScreen.matches) {
      const isCollapsed = document.body.classList.toggle("navigator-collapsed");
      withStorage(() => localStorage.setItem(collapsedStorageKey, isCollapsed));
      updateToggle();
    } else {
      setPanelOpen(!document.body.classList.contains("navigator-open"));
    }
  });
  
  closeButton.addEventListener("click", () => setPanelOpen(false));
  
  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && document.body.classList.contains("navigator-open")) {
      setPanelOpen(false);
    }
  });
  
  // The reader can drag the navigator's edge to resize it, and drag it past half of its minimum width to hide it.
  // The style sheet keeps the width between the minimum and maximum widths.
  const widthStorageKey = "docc.navigator.width";
  const setPreferredWidth = (width) => document.body.style.setProperty("--navigator-preferred-width", `${width}px`);
  const storedWidth = Number(withStorage(() => localStorage.getItem(widthStorageKey)));
  if (storedWidth > 0) {
    setPreferredWidth(storedWidth);
  }
  
  const resizeHandle = document.createElement("div");
  resizeHandle.className = "resize-handle";
  navigator.append(resizeHandle);
  
  // The width to restore when dragging the edge hides the navigator.
  let widthBeforeResizing = "";
  resizeHandle.addEventListener("pointerdown", (event) => {
    if (event.button !== 0 || !event.isPrimary) {
      return;
    }
    event.preventDefault();
    widthBeforeResizing = document.body.style.getPropertyValue("--navigator-preferred-width");
    resizeHandle.setPointerCapture(event.pointerId);
    document.body.classList.add("navigator-resizing");
  });
  resizeHandle.addEventListener("pointermove", (event) => {
    if (!resizeHandle.hasPointerCapture(event.pointerId)) {
      return;
    }
    const width = event.clientX - navigator.getBoundingClientRect().left;
    if (width > Math.min(innerWidth, 1521) * 0.3 / 2) {
      setPreferredWidth(width);
    } else {
      // The navigator can only be resized when it's visible on a wide screen, where the button hides it.
      document.body.classList.remove("navigator-resizing");
      resizeHandle.releasePointerCapture(event.pointerId);
      document.body.style.setProperty("--navigator-preferred-width", widthBeforeResizing);
      toggle.click();
    }
  });
  resizeHandle.addEventListener("lostpointercapture", () => {
    // Dragging the edge past half of the minimum width already finished resizing, and hid the navigator.
    if (!document.body.classList.contains("navigator-resizing")) {
      return;
    }
    document.body.classList.remove("navigator-resizing");
    // Keep the width that the style sheet limited the dragged width to.
    if (navigator.offsetWidth) {
      setPreferredWidth(navigator.offsetWidth);
      withStorage(() => localStorage.setItem(widthStorageKey, navigator.offsetWidth));
    }
  });
  
  // Restore the previous page's scroll position so that the navigator doesn't jump, and then reveal the active item if it isn't visible.
  list.scrollTop = restoredState.scrollTop ?? 0;
  updateToggle();
})();

""".utf8))
    
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

    /// The icon that the navigator sidebar displays for classes.
    static let classIcon = File(filename: "class.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="16px" height="16px" viewBox="0 0 16 16">
  <rect x="1" y="1" width="14" height="14" fill="none" stroke="#666"/>
  <text x="49%" y="12" fill="#666" font-family="Helvetica Neue, Helvetica, Arial, sans-serif" font-size="11" font-weight="bold" text-anchor="middle">C</text>
</svg>
""".utf8))

    /// The icon that the navigator sidebar displays for dictionaries.
    static let dictionaryIcon = File(filename: "dictionary.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="16px" height="16px" viewBox="0 0 16 16">
  <rect x="1" y="1" width="14" height="14" fill="none" stroke="#666"/>
  <text x="49%" y="12" fill="#666" font-family="Helvetica Neue, Helvetica, Arial, sans-serif" font-size="11" font-weight="bold" text-anchor="middle">O</text>
</svg>
""".utf8))

    /// The icon that the navigator sidebar displays for enumerations, their cases, and HTTP requests.
    static let enumerationIcon = File(filename: "enumeration.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="16px" height="16px" viewBox="0 0 16 16">
  <rect x="1" y="1" width="14" height="14" fill="none" stroke="#666"/>
  <text x="49%" y="12" fill="#666" font-family="Helvetica Neue, Helvetica, Arial, sans-serif" font-size="11" font-weight="bold" text-anchor="middle">E</text>
</svg>
""".utf8))

    /// The icon that the navigator sidebar displays for extensions.
    static let extensionIcon = File(filename: "extension.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="16px" height="16px" viewBox="0 0 16 16">
  <rect x="1.5" y="1.5" width="13" height="13" fill="none" stroke="#666"/>
  <text x="2.7" y="12" fill="#666" font-family="Helvetica Neue, Helvetica, Arial, sans-serif" font-size="11" font-weight="bold">E</text>
  <text x="9.2" y="12" fill="#666" font-family="Helvetica Neue, Helvetica, Arial, sans-serif" font-size="8" font-weight="bold">x</text>
</svg>
""".utf8))

    /// The icon that the navigator sidebar displays for functions.
    static let functionIcon = File(filename: "function.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="14px" height="14px" viewBox="0 0 14 14" fill="#666">
  <path d="M13 1v12h-12v-12zM12.077 1.923h-10.154v10.154h10.154z"/>
  <path d="M5.191 9.529c0.044 0.002 0.089 0.004 0.133 0.004 0.108 0 0.196-0.025 0.262-0.074s0.122-0.113 0.166-0.188c0.044-0.077 0.078-0.159 0.103-0.247s0.049-0.173 0.074-0.251l0.598-2.186h-0.709l0.207-0.702h0.702l0.288-1.086c0.083-0.384 0.256-0.667 0.517-0.849s0.591-0.273 0.99-0.273c0.108 0 0.212 0.007 0.314 0.022s0.203 0.027 0.306 0.037l-0.207 0.761c-0.054-0.006-0.106-0.011-0.155-0.018s-0.102-0.011-0.155-0.011c-0.108 0-0.196 0.016-0.262 0.048s-0.122 0.075-0.166 0.129-0.080 0.115-0.107 0.185c-0.028 0.068-0.055 0.14-0.085 0.214l-0.222 0.842h0.768l-0.192 0.702h-0.783l-0.628 2.319c-0.059 0.222-0.129 0.419-0.21 0.594s-0.182 0.322-0.303 0.443-0.269 0.214-0.443 0.281-0.385 0.1-0.631 0.1c-0.084 0-0.168-0.004-0.251-0.011s-0.168-0.014-0.251-0.018l0.207-0.768c0.040 0 0.081 0.001 0.126 0.004z"/>
</svg>
""".utf8))

    /// The icon that the navigator sidebar displays for tutorial overviews and resources.
    static let learnIcon = File(filename: "learn.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="14px" height="14px" viewBox="0 0 14 14" fill="#666">
  <path d="M0 0.948h2.8v2.8h-2.8z"/>
  <path d="M11.2 10.252h2.8v2.8h-2.8z"/>
  <path d="M6.533 1.852h0.933v10.267h-0.933z"/>
  <path d="M2.8 1.852h4.667v0.933h-4.667z"/>
  <path d="M6.533 11.186h4.667v0.933h-4.667z"/>
</svg>
""".utf8))

    /// The icon that the navigator sidebar displays for macros.
    static let macroIcon = File(filename: "macro.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="16px" height="16px" viewBox="0 0 16 16">
  <rect x="1" y="1" width="14" height="14" fill="none" stroke="#666"/>
  <text x="49%" y="12" fill="#666" font-family="Helvetica Neue, Helvetica, Arial, sans-serif" font-size="11" font-weight="bold" text-anchor="middle">#</text>
</svg>
""".utf8))

    /// The icon that the navigator sidebar displays for methods and initializers.
    static let methodIcon = File(filename: "method.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="16px" height="16px" viewBox="0 0 16 16">
  <rect x="1" y="1" width="14" height="14" fill="none" stroke="#666"/>
  <text x="49%" y="12" fill="#666" font-family="Helvetica Neue, Helvetica, Arial, sans-serif" font-size="11" font-weight="bold" text-anchor="middle">M</text>
</svg>
""".utf8))

    /// The icon that the navigator sidebar displays for namespaces.
    static let namespaceIcon = File(filename: "namespace.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="16px" height="16px" viewBox="0 0 16 16">
  <rect x="1" y="1" width="14" height="14" fill="none" stroke="#666"/>
  <text x="49%" y="12" fill="#666" font-family="Helvetica Neue, Helvetica, Arial, sans-serif" font-size="11" font-weight="bold" text-anchor="middle">N</text>
</svg>
""".utf8))

    /// The icon that the navigator sidebar displays for operators.
    static let operatorIcon = File(filename: "operator.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="14px" height="14px" viewBox="0 0 14 14" fill="#666">
  <path d="M13 13h-12v-12h12zM1.923 12.077h10.154v-10.154h-10.154z"/>
  <path d="M5.098 4.968v-1.477h-0.738v1.477h-1.477v0.738h1.477v1.477h0.738v-1.477h1.477v-0.738z"/>
  <path d="M8.030 4.807l-2.031 5.538h0.831l2.031-5.538z"/>
  <path d="M8.894 8.805v0.923h2.215v-0.923z"/>
</svg>
""".utf8))

    /// The icon that the navigator sidebar displays for properties.
    static let propertyIcon = File(filename: "property.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="16px" height="16px" viewBox="0 0 16 16">
  <rect x="1" y="1" width="14" height="14" fill="none" stroke="#666"/>
  <text x="49%" y="12" fill="#666" font-family="Helvetica Neue, Helvetica, Arial, sans-serif" font-size="11" font-weight="bold" text-anchor="middle">P</text>
</svg>
""".utf8))

    /// The icon that the navigator sidebar displays for property list keys.
    static let propertyListKeyIcon = File(filename: "property-list-key.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="16px" height="16px" viewBox="0 0 16 16">
  <rect x="1" y="1" width="14" height="14" fill="none" stroke="#666"/>
  <text x="49%" y="12" fill="#666" font-family="Helvetica Neue, Helvetica, Arial, sans-serif" font-size="11" font-weight="bold" text-anchor="middle">K</text>
</svg>
""".utf8))

    /// The icon that the navigator sidebar displays for protocols.
    static let protocolIcon = File(filename: "protocol.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="16px" height="16px" viewBox="0 0 16 16">
  <rect x="1.5" y="1.5" width="13" height="13" fill="none" stroke="#666"/>
  <text x="2.7" y="12" fill="#666" font-family="Helvetica Neue, Helvetica, Arial, sans-serif" font-size="11" font-weight="bold">P</text>
  <text x="9.2" y="12" fill="#666" font-family="Helvetica Neue, Helvetica, Arial, sans-serif" font-size="8" font-weight="bold">r</text>
</svg>
""".utf8))

    /// The icon that the navigator sidebar displays for sample code projects.
    static let sampleCodeIcon = File(filename: "sample-code.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="14px" height="14px" viewBox="0 0 14 14" fill="#666">
  <path d="M9.987 14h-0.814v-0.916h0.36c0.137 0 0.253-0.038 0.349-0.116 0.099-0.080 0.179-0.188 0.239-0.318 0.064-0.134 0.11-0.298 0.139-0.483 0.031-0.186 0.045-0.38 0.045-0.58v-2.115c0-0.417 0.046-0.781 0.139-1.083 0.092-0.3 0.2-0.554 0.322-0.754 0.127-0.203 0.246-0.353 0.366-0.458 0.087-0.076 0.155-0.131 0.207-0.169-0.052-0.037-0.12-0.093-0.207-0.167-0.12-0.105-0.239-0.255-0.366-0.459-0.122-0.2-0.23-0.453-0.322-0.754-0.093-0.3-0.139-0.665-0.139-1.082v-2.13c0-0.199-0.014-0.392-0.045-0.572-0.029-0.182-0.076-0.345-0.139-0.483-0.060-0.137-0.141-0.246-0.239-0.328-0.095-0.076-0.212-0.115-0.349-0.115h-0.36v-0.916h0.814c0.442 0 0.788 0.18 1.030 0.538 0.238 0.352 0.358 0.826 0.358 1.407v2.236c0 0.3 0.015 0.597 0.044 0.886 0.030 0.287 0.086 0.544 0.164 0.765 0.077 0.216 0.184 0.392 0.318 0.522 0.129 0.124 0.298 0.188 0.503 0.188h0.058v0.916h-0.058c-0.206 0-0.374 0.064-0.503 0.188-0.134 0.129-0.242 0.305-0.318 0.521-0.078 0.223-0.134 0.48-0.164 0.766-0.029 0.288-0.044 0.587-0.044 0.884v2.236c0 0.582-0.12 1.055-0.358 1.409-0.242 0.358-0.588 0.538-1.030 0.538z"/>
  <path d="M4.827 14h-0.814c-0.442 0-0.788-0.18-1.030-0.538-0.238-0.352-0.358-0.825-0.358-1.409v-2.221c0-0.301-0.015-0.599-0.045-0.886-0.029-0.287-0.085-0.544-0.163-0.764-0.077-0.216-0.184-0.393-0.318-0.522-0.131-0.127-0.296-0.188-0.503-0.188h-0.058v-0.916h0.058c0.208 0 0.373-0.063 0.503-0.188 0.135-0.129 0.242-0.304 0.318-0.522 0.078-0.22 0.134-0.477 0.163-0.765 0.030-0.286 0.045-0.585 0.045-0.886v-2.251c0-0.582 0.12-1.055 0.358-1.407 0.242-0.358 0.588-0.538 1.030-0.538h0.814v0.916h-0.36c-0.138 0-0.252 0.038-0.349 0.116-0.099 0.079-0.179 0.189-0.239 0.327-0.064 0.139-0.11 0.302-0.141 0.483-0.029 0.18-0.044 0.373-0.044 0.572v2.13c0 0.417-0.046 0.782-0.138 1.082-0.092 0.302-0.201 0.556-0.324 0.754-0.123 0.201-0.246 0.356-0.366 0.459-0.086 0.074-0.153 0.13-0.206 0.167 0.052 0.038 0.12 0.093 0.206 0.169 0.12 0.103 0.243 0.258 0.366 0.458s0.232 0.453 0.324 0.754c0.092 0.302 0.138 0.666 0.138 1.083v2.115c0 0.2 0.015 0.394 0.044 0.58 0.030 0.186 0.077 0.349 0.139 0.482 0.062 0.132 0.142 0.239 0.241 0.32 0.096 0.079 0.21 0.116 0.349 0.116h0.36z"/>
</svg>
""".utf8))

    /// The icon that the navigator sidebar displays for structures.
    static let structureIcon = File(filename: "structure.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="16px" height="16px" viewBox="0 0 16 16">
  <rect x="1" y="1" width="14" height="14" fill="none" stroke="#666"/>
  <text x="49%" y="12" fill="#666" font-family="Helvetica Neue, Helvetica, Arial, sans-serif" font-size="11" font-weight="bold" text-anchor="middle">S</text>
</svg>
""".utf8))

    /// The icon that the navigator sidebar displays for subscripts.
    static let subscriptIcon = File(filename: "subscript.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="14px" height="14px" viewBox="0 0 14 14" fill="#666">
  <path d="M13 13h-12v-12h12zM1.923 12.077h10.154v-10.154h-10.154z"/>
  <path d="M4.133 3.633v6.738h1.938v-0.831h-0.923v-5.077h0.923v-0.831z"/>
  <path d="M9.856 10.371v-6.738h-1.938v0.831h0.923v5.077h-0.923v0.831z"/>
</svg>
""".utf8))

    /// The icon that the navigator sidebar displays for tutorials.
    static let tutorialIcon = File(filename: "tutorial.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="14px" height="14px" viewBox="0 0 14 14" fill="#666">
  <path d="M0.933 6.067h3.733v1.867h-3.733v-1.867z"/>
  <path d="M0.933 1.867h3.733v1.867h-3.733v-1.867z"/>
  <path d="M13.067 1.867v10.267h-7.467v-10.267zM12.133 2.8h-5.6v8.4h5.6z"/>
  <path d="M0.933 10.267h3.733v1.867h-3.733v-1.867z"/>
</svg>
""".utf8))

    /// The icon that the navigator sidebar displays for type aliases.
    static let typeAliasIcon = File(filename: "type-alias.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="16px" height="16px" viewBox="0 0 16 16">
  <rect x="1" y="1" width="14" height="14" fill="none" stroke="#666"/>
  <text x="49%" y="12" fill="#666" font-family="Helvetica Neue, Helvetica, Arial, sans-serif" font-size="11" font-weight="bold" text-anchor="middle">T</text>
</svg>
""".utf8))

    /// The icon that the navigator sidebar displays for unions.
    static let unionIcon = File(filename: "union.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="16px" height="16px" viewBox="0 0 16 16">
  <rect x="1" y="1" width="14" height="14" fill="none" stroke="#666"/>
  <text x="49%" y="12" fill="#666" font-family="Helvetica Neue, Helvetica, Arial, sans-serif" font-size="11" font-weight="bold" text-anchor="middle">U</text>
</svg>
""".utf8))

    /// The icon that the navigator sidebar displays for variables.
    static let variableIcon = File(filename: "variable.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="16px" height="16px" viewBox="0 0 16 16">
  <rect x="1" y="1" width="14" height="14" fill="none" stroke="#666"/>
  <text x="49%" y="12" fill="#666" font-family="Helvetica Neue, Helvetica, Arial, sans-serif" font-size="11" font-weight="bold" text-anchor="middle">V</text>
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

    /// The icon that DocC displays next to items in the navigator sidebar that have children, which rotates when the item opens.
    static let chevronIcon = File(filename: "chevron.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="10px" height="10px" viewBox="0 0 14 14" fill="#666">
  <path d="M2.964 1.366l0.649-0.76 7.426 6.343-7.423 6.445-0.655-0.755 6.545-5.683-6.542-5.59z"/>
</svg>
""".utf8))

    /// The icon that DocC uses for the button to close the navigator sidebar on narrow screens.
    static let closeIcon = File(filename: "close.svg", data: Data("""
<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="19px" height="19px" viewBox="0 0 14 14">
  <path d="M11.91 1l1.090 1.090-4.917 4.915 4.906 4.905-1.090 1.090-4.906-4.905-4.892 4.894-1.090-1.090 4.892-4.894-4.903-4.904 1.090-1.090 4.903 4.904z"/>
</svg>
""".utf8))

}
