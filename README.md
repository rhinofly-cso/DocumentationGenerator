# Introduction

The documentation generator is designed to make ColdFusion developers' lives easier. It generates static pages in HTML, which can then be used similar to language reference documentation. Just select the library or libraries of ColdFusion components (.cfc files) you are using.
The layout is based on Adobe's ASDoc (for documenting ActionScript) and the documentation tag syntax is based on both ASDoc and JavaDoc.

# Directions

To generate documentation, follow these steps:

  1. Obtain all relevant checkouts.
  2. Select the libraries that you want to document.
  3. Select the destination folder
  4. Run the documentation generator

### Requirements

To run this tool, you need:

  * a local installation of the ColdFusion 9 server, with the 9.0.1 update (or later)
  * to enable template caching (highly recommended)
  * a checkout of the documentation generator
  * checkouts of all libraries that need to be included in the documentation

### Settings

The settings.xml file contains all the tags that determine how the documentation is generated. The most important are:

  * `<sourcePath>` – an absolute path to a library up for documentation; use as many tags as you like
  * `<documentDestination>` – the destination folder (also an absolute path)

Additionally, you can specify regular expressions for library folders that need to be skipped in `<reExcludeFolder>`. The tag adds REs in addition to the default value `"^\."`, which means that the generator always skips folders which have a name starting with a dot. Alternatively, specify an absolute path to a folder – and all of its subdirectories – that needs to be skipped in `<excludePath>`. You can also denote separate components that need to be skipped using `<excludeComponent>`. All tags can be used multiple times.

### Tag specifications

In the [specifications][1], I show which of the tags are specified and how to use them. This specification is loosely based on ASDoc and Javadoc. An important detail is that the multiple use of the @param tag is replaced by using separate tags in the form of @_argument name_.

### Reading

To find the generated reference documentation, just go to the destination folder and open the `index.html` file.

# Design

The generator comprises of ColdFusion components, HTML templates, static files, and the faithful trio: `settings.xml`, `Application.cfc`, and `index.cfm`.

### Components

There are five components that essentially contain functions for generating documentation:

  * `MetadataFactory.cfc` – Collects metadata from the library and assigns relevant information to metadata objects. It then adds those to a library struct, as well as the component name to a packages struct.
  * `HintResolver.cfc` – Reads the hint attribute of any metadata object, and applies any unresolved tags in it to the object. In the case of (multiple) usage of @throws or @see tags in CFScript, it parses the corresponding comment in the .cfc file. It is called from the methods in MetadataFactory.cfc.
  * `DocumentBuilder.cfc` – Runs through the package struct to create a directory structure for the documentation pages and generates HTML pages (from the templates) to write to these directories. It also copies all static files to the document root.
  * `TemplateRendering.cfc` – Contains functions to convert strings containing links to HTML. Instances of this class are created in DocumentBuilder.cfc to be called from the HTML templates.
  * `TagUtils.cfc` – Contains one method from the CSOShared Library, to get access to the `cfinvoke` tag from within CFScript.

Also, a number of components are used as classes for metadata objects:

  * `CFMetadata.cfc` – Is the base class for all other classes. Also, it is used to store exception-type--hint value pairs that are produced by the @throws tag.
  * `CFC.cfc` – Is the base class for the CFComponent and CFInterface classes.
  * `CFComponent.cfc` – Is used to store metadata for components.
  * `CFPersistentComponent.cfc` – Is used to store metadata for persistent components (ORM).
  * `CFInterface.cfc` – Is used to store metadata for interfaces.
  * `CFProperty.cfc` – Is used to store metadata for component properties.
  * `CFMapping.cfc` – Is used to store metadata for persistent component properties (ORM).
  * `CFFunction.cfc` – Is used to store metadata for methods.
  * `CFArgument.cfc` – Is used to store metadata for method parameters.

### Templates

The main page of the reference documentation contains lists and summaries of all packages and components. These are created using:

  * `componentListAll.cfm`
  * `componentSummary.cfm`
  * `packageList.cfm`
  * `packageSummary.cfm`

Additionally, for each individual package, a component list and summary is created using:

  * `componentList.cfm`
  * `packageDetail.cfm`

Finally, for each component in the package, a component detail page is created using componentDetail.cfm. This template introduces includes for different aspects of the page:

  * `dsp_classHeader.cfm` – Displays all component details other than those associated with properties and methods.
  * `fnc_collectProperties.cfm` - Assigns all properties associated with the component to different parts of the page by whether it is persistent and whether it is defined in that component.
  * `fnc_collectMethods.cfm` – Assigns all methods associated with the component to different parts of the page by access (public, remote, or private) and whether it is defined in that component.
  * `dsp_propertySummary.cfm` – Displays the summary for all properties.
  * `dsp_persistentPropertySummary.cfm` – Displays the summary for all persistent properties.
  * `dsp_propertyDetail.cfm` – Displays the details for the properties defined by the component.
  * `dsp_methodSummary.cfm` – Displays the summary for all public methods.
  * `dsp_remoteMethodSummary.cfm` – Displays the summary for all remote methods.
  * `dsp_protectedMethodSummary.cfm` – Displays the summary for all private methods.
  * `dsp_methodDetail.cfm` – Displays the details for the methods defined by the component.

The last of the included files, `fnc_renderLink.cfm`, is included by the component `TemplateRendering.cfc`, which in turn is called from the templates mentioned above. It contains two functions: one for rendering general hyperlinks and another for rendering links to package-detail pages. However, it _is_ considered a template, since it determines the html-layout of all generated hyperlinks.

### Static files

A number of files do not have to be generated dynamically. These files are directly copied from the apiDoc folder to the root directory of the reference documentation page:

  * `index.html`
  * `package-frame.html`
  * `title-bar.html`
  * `AC_OETags.js`
  * `asdoc.js`
  * `cookies.js`
  * `help.js`
  * `override.css`
  * `print.css`
  * `style.css`
  * all files in the images folder

### Webroot

The `Application.cfc` file applies some settings (see Settings). The `index.cfm` file first creates instances of `MetadataFactory.cfc` and `DocumentBuilder.cfc`. Then, it creates the library and packages structs. Next, it calls the necessary methods to insert elements for all components into the library struct and for all packages into the packages struct. Finally, it uses this data to create the reference documentation pages.

   [1]: ColdFusion%20Tag%20Specifications.md
