<cfset factory_obj = createObject("component", "cfc.MetadataFactory") />
<cfset generator_obj = createObject("component", "cfc.DocumentBuilder") />

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
<cfset components_str = generator_obj.sortByLastName(components_str) />
<cfset components_arr = generator_obj.descriptionArrayFromList(components_str, library_struct) />

<cfsavecontent variable="page_str">
	<table border="0">
		<cfloop from="1" to="#arrayLen(components_arr)#" index="i">
			<tr>
				<td>
					<cfset component_str = components_arr[i].name />
					<cfif isInstanceOf(library_struct[component_str], "cfc.cfcMetadata.CFInterface")>
						<cfoutput>
							<i>#generator_obj.convertToLink(component_str, library_struct)#</i><br />
						</cfoutput>
					<cfelseif isInstanceOf(library_struct[component_str], "cfc.cfcMetadata.CFComponent")>
						<cfoutput>
							#generator_obj.convertToLink(component_str, library_struct)#<br />
						</cfoutput>
					</cfif>
				</td>
				<td>
					<cfoutput>
							#components_arr[i].description#
					</cfoutput>
				</td>
			</tr>
		</cfloop>
	</table>
</cfsavecontent>
<cfoutput>#page_str#</cfoutput>

<cfabort />

<cfset packages_str = structKeyList(packages_struct) />
<cfset packages_str = listSort(packages_str, "textnocase") />
<cfloop list="#packages_str#" index="key_str">
<!--- 	<cfdump var="#packages_struct[key_str]#" label="package #key_str#"> --->
	<cfset started_bool = false />
	<cfset output_str = "" />
	<cfloop list="#packages_struct[key_str].component#" index="component_str">
		<cfif started_bool>
			<cfset output_str &= ", " />
		<cfelse>
			<cfset started_bool = true />
		</cfif>
		<cfset output_str &= listLast(library_struct[component_str].getName(), ".") />
	</cfloop>
	<cfoutput>#key_str#: #output_str#<br /></cfoutput>
</cfloop>

<cfset interfaces_str = "" />
<cfset components_str = "" />
<cfloop collection="#library_struct#" item="key_str">
	<cfset cfcMetadata_obj = library_struct[key_str] />
	<cfif isInstanceOf(cfcMetadata_obj, "cfc.cfcMetadata.CFInterface")>
		<cfset interfaces_str = listAppend(interfaces_str, listLast(key_str, ".")) />
	<cfelseif isInstanceOf(cfcMetadata_obj, "cfc.cfcMetadata.CFComponent")>
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
