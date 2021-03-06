<cfsilent>
	<cfset factory_obj = createObject("component", "cfc.MetadataFactory") />
	<cfset builder_obj = createObject("component", "cfc.DocumentBuilder") />
	
	<cfset library_struct = structNew() />
	<cfset packages_struct = structNew() />
	
	<cfloop list="#application.sourcePaths#" index="libraryPath_str">
		<cfset factory_obj.browseDirectory(libraryPath_str, libraryPath_str, library_struct, packages_struct) />
	</cfloop>
	
	<cfset builder_obj.generateDocumentation(application.documentRoot, packages_struct, library_struct) />
</cfsilent>
<html><head><title>Documentation Generator</title></head></html>