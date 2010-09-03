<cfset factory_obj = createObject("component", "cfc.MetadataFactory") />
<cfset builder_obj = createObject("component", "cfc.DocumentBuilder") />

<html>
<head>
<title>Document generator</title>
</head>

<body>

<cfset path_str = "C:\development\libraries\RhinoflyLibrary\src" />
<cfoutput>#path_str#<br /></cfoutput>

<cfset library_struct = structNew() />
<cfset packages_struct = structNew() />
<cfset factory_obj.browseDirectory(path_str, path_str, library_struct, packages_struct) />

<cfset components_str = structKeyList(library_struct) />
<cfset components_str = builder_obj.sortByLastName(components_str) />
<cfset components_arr = builder_obj.descriptionArrayFromList(components_str, library_struct) />

<cfsavecontent variable="page_str">
	<table border="0">
		<cfloop from="1" to="#arrayLen(components_arr)#" index="i">
			<tr>
				<td>
					<cfoutput>#builder_obj.convertToLink(components_arr[i].name, library_struct, "", true)#<br /></cfoutput>
				</td>
				<td>
					<cfoutput>#components_arr[i].description#</cfoutput>
				</td>
			</tr>
		</cfloop>
	</table>
</cfsavecontent>
<cfoutput>#page_str#</cfoutput>

<h3>Tests</h3>
<cfset data = getComponentMetaData("cfc.TestInterface") />
<cfdump var="#data#" expand="false" />
<cfset data = getComponentMetaData("cfc.TestImplementation") />
<cfdump var="#data#" expand="false" />

</body>
</html>
</head>
