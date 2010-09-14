<cfset factory_obj = createObject("component", "cfc.MetadataFactory") />
<cfset builder_obj = createObject("component", "cfc.DocumentBuilder") />

<cfset model = structNew() />
<cfset local = structNew() />

<cfset path_str = "C:\development\docGen\data" />
<cfset library_struct = structNew() />
<cfset model.packages_struct = structNew() />
<cfset factory_obj.browseDirectory(path_str, path_str, library_struct, model.packages_struct) />

<cfset model.rendering_obj = createObject("component", "cfc.TemplateRendering") />
<cfset model.rendering_obj.setLibrary(library_struct) />

<cfset model.components_arr = builder_obj.descriptionArray(library_struct) />
<cfset componentName_str = model.components_arr[11].name />
<cfset model.libraryRef_struct = library_struct />
<cfset model.cfMetadata_obj = model.libraryRef_struct[componentName_str] />

<cfset model.properties_arr = builder_obj.propertyArray(componentName_str, library_struct) />
<cfset model.methods_arr = builder_obj.methodArray(componentName_str, library_struct) />

<cfscript>
	savecontent variable="page_str"
	{
		include "./templates/componentDetail.cfm";
	}
	writeOutput(page_str);
</cfscript>

<cfabort />
<cfloop collection="#packages_struct#" item="key_str">
	<cfoutput>
		#key_str# - #packages_struct[key_str].component#<br />
	</cfoutput>
</cfloop>

<!--- 
<cfset newDir_str = "c:/development/docGen/apiDoc/cfc/" />
<cfif not directoryExists(newDir_str)>
	<cfset directoryCreate(newDir_str) />
</cfif>
<cfset fileWrite(newDir_str & "test.html", "<html></html>") />
 --->
