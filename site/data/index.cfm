<cfset factory_obj = createObject("component", "cfc.MetadataFactory") />
<cfset builder_obj = createObject("component", "cfc.DocumentBuilder") />

<!--- <cfset test_obj = createObject("component", "fly.cso.domain.letter.Letter") /> --->

<cfset documentRoot_str = "C:\development\docGen\test" />
<cfset library_struct = structNew() />
<cfset packages_struct = structNew() />

<p><cfoutput>#documentRoot_str#</cfoutput></p>

<cfloop list="#application.customTagPaths#" index="libraryPath_str">
	<cfset factory_obj.browseDirectory(libraryPath_str, libraryPath_str, library_struct, packages_struct) />
</cfloop>

<cfset builder_obj.generateDocumentation(documentRoot_str, packages_struct, library_struct) />