<cfset factory_obj = createObject("component", "cfc.MetadataFactory") />

<html>
<head>
<title>Document generator</title>
</head>

<body>

<cfset path_str = "C:\development\libraries\RhinoflyLibrary\src" />
<cfoutput>#path_str#</cfoutput>

<cfset library_struct = structNew() />
<cfset packages_struct = structNew() />
<cfset factory_obj.browseDirectory(path_str, path_str, library_struct, packages_struct) />
<cfdump var="#packages_struct#" expand="false" />

<cfabort />

<cfset interfaces_str = "" />
<cfset components_str = "" />
<cfloop collection="#library_struct#" item="key_str">
	<cfset cfcMetadata_obj = library_struct[key_str] />
	<cfif isInstanceOf(cfcMetadata_obj, "cfc.cfcMetadata.cfcInterface")>
		<cfset interfaces_str = listAppend(interfaces_str, listLast(key_str, ".")) />
	<cfelseif isInstanceOf(cfcMetadata_obj, "cfc.cfcMetadata.cfcComponent")>
		<cfset components_str = listAppend(components_str, listLast(key_str, ".")) />
	</cfif>
	
</cfloop>
<cfset interfaces_str = listSort(interfaces_str, "textnocase") />
<cfset components_str = listSort(components_str, "textnocase") />
<p><cfoutput>#listLen(interfaces_str)#, #listLen(components_str)#</cfoutput></p>
<p><cfoutput>#interfaces_str#</cfoutput></p>
<p><cfoutput>#components_str#</cfoutput></p>
<cfflush />

<cfset packages_arr = arrayNew(1) />
<cfloop collection="#packages_struct#" item="key_str">
	<cfset arrayAppend(packages_arr, key_str) />
</cfloop>
<cfset arraySort(packages_arr, "textnocase") />
<cfdump var="#packages_arr#" expand="false" />

<cfflush />

<h3>Tests</h3>
<cfset data = getComponentMetaData("cfc.TestInterface") />
<cfdump var="#data#" expand="false" />
<cfset data = getComponentMetaData("cfc.TestImplementation") />
<cfdump var="#data#" expand="false" />

</body>
</html>
</head>
