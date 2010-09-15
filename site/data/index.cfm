<cfset factory_obj = createObject("component", "cfc.MetadataFactory") />
<cfset builder_obj = createObject("component", "cfc.DocumentBuilder") />

<cfset apiDocSource_str = reReplace(getBaseTemplatePath(), "[/\\]+", "/", "all") />
<cfset apiDocSource_str = listDeleteAt(apiDocSource_str, listLen(apiDocSource_str, "/"), "/") />
<cfset apiDocSource_str &= "/apiDoc/" />

<cfset model = structNew() />
<cfset local = structNew() />

<cfset path_str = "C:\development\docGen\data" />
<cfset documentRoot_str = "C:\development\docGen\test" />
<cfset library_struct = structNew() />
<cfset packages_struct = structNew() />

<p><cfoutput>#documentRoot_str#</cfoutput></p>

<cfset factory_obj.browseDirectory(path_str, path_str, library_struct, packages_struct) />
<cfset builder_obj.generateDocumentation(documentRoot_str, packages_struct, library_struct) />

<cfabort />

<cfset model.packages_struct = packages_struct />
<cfset model.rendering_obj = createObject("component", "cfc.TemplateRendering") />
<cfset model.rendering_obj.setLibrary(library_struct) />
<cfset model.libraryRef_struct = library_struct />
<cfset model.components_arr = builder_obj.componentArray(structKeyList(library_struct), library_struct) />
<cfset model.cfMetadata_obj = model.components_arr[1] />


<cfset componentName_str = model.cfMetadata_obj.getName() />
<cfset model.properties_arr = builder_obj.propertyArray(componentName_str, library_struct) />
<cfset model.methods_arr = builder_obj.methodArray(componentName_str, library_struct) />

<cfscript>
	savecontent variable="page_str"
	{
		include "./templates/componentSummary.cfm";
	}
	writeOutput(page_str);
</cfscript>

<p>
	<cfloop collection="#model.packages_struct#" item="key_str">
		<cfoutput>
			#key_str# - #model.packages_struct[key_str].component#<br />
		</cfoutput>
	</cfloop>
</p>

<!--- 
<cfset newDir_str = "c:/development/docGen/apiDoc/cfc/" />
<cfif not directoryExists(newDir_str)>
	<cfset directoryCreate(newDir_str) />
</cfif>
<cfset fileWrite(newDir_str & "test.html", "<html></html>") />
 --->
