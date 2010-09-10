<cfset factory_obj = createObject("component", "cfc.MetadataFactory") />
<cfset builder_obj = createObject("component", "cfc.DocumentBuilder") />

<cfset path_str = "C:\development\docGen\data" />
<cfset library_struct = structNew() />
<cfset packages_struct = structNew() />
<cfset factory_obj.browseDirectory(path_str, path_str, library_struct, packages_struct) />

<cfset components_arr = builder_obj.descriptionArray(library_struct) />
<cfset componentName_str = components_arr[8].name />
<cfset libraryRef_struct = library_struct />
<cfset cfMetadata_obj = libraryRef_struct[componentName_str] />

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
