<cfset factory_obj = createObject("component", "cfc.MetadataFactory") />
<cfset builder_obj = createObject("component", "cfc.DocumentBuilder") />

<html>
<head>
<title>Document generator</title>
</head>

<body>

<cfset path_str = "C:\development\docGen\data\cfc" />
<cfoutput>#path_str#<br /></cfoutput>

<cfset library_struct = structNew() />
<cfset packages_struct = structNew() />
<cfset factory_obj.browseDirectory(path_str, path_str, library_struct, packages_struct) />

<cfset components_arr = builder_obj.descriptionArray(library_struct) />
<cfset componentName_str = components_arr[3].name />

<cfset libraryRef_struct = library_struct />
<cfset cfMetadata_obj = libraryRef_struct[componentName_str] />

<cfset componentPage_str = replace(variables.componentName_str, ".", "/", "all") & ".html" />
<cfset packageName_str = listDeleteAt(variables.componentName_str, listLen(variables.componentName_str), ".") />
<cfset packagePath_str = replace(variables.packageName_str, ".", "/", "all") & "/" />
<cfset rootPath_str = repeatString("../", listLen(variables.packageName_str, ".")) />
<cfset properties_arr = builder_obj.propertyArray(componentName_str, libraryRef_struct) />
<cfsavecontent variable="page_str">
	<a name="methodSummary"></a>
	<div class="summarySection">
		<cfinclude template="./templates/includes/dsp_PropertySummary.cfm">
	</div>
</cfsavecontent>
<cfoutput>#page_str#</cfoutput>
<cfabort />

<cfsavecontent variable="page_str">
	<table border="0">
		<cfloop from="1" to="#arrayLen(components_arr)#" index="i">
			<tr>
				<td>
					<cfoutput>#builder_obj.convertToLink(components_arr[i].name, library_struct, "", true)#<br /></cfoutput>
				</td>
				<td colspan="3">
					<cfoutput>#components_arr[i].description#</cfoutput>
				</td>
			</tr>
			<cfset properties_arr = builder_obj.propertyArray(components_arr[i].name, library_struct) />
			<cfif arrayLen(properties_arr) gt 0>
				<tr>
					<td></td>
					<td colspan="2">
						<b>Properties</b>
					</td>
				</tr>
			</cfif>
			<cfloop from="1" to="#arrayLen(properties_arr)#" index="j">
				<cfif not properties_arr[j].metadata.getPrivate()>
					<tr>
						<td></td>
						<td>
							<cfoutput>#properties_arr[j].name#</cfoutput>
						</td>
						<td>
							<cfoutput>#properties_arr[j].metadata.getShortHint()#</cfoutput>
						</td>
						<td>
							<cfoutput>#properties_arr[j].definedBy#</cfoutput>
						</td>
					</tr>
				</cfif>
			</cfloop>
			<cfset methods_arr = builder_obj.methodArray(components_arr[i].name, library_struct) />
			<cfset publicMethods_bool = false />
			<cfset privateMethods_bool = false />
			<cfloop from="1" to="#arrayLen(variables.methods_arr)#" index="i">
				<cfif variables.methods_arr[i].metadata.getAccess() eq "public" and not variables.methods_arr[i].metadata.getPrivate()>
					<cfset publicMethods_bool = true />
				<cfelseif variables.methods_arr[i].metadata.getAccess() eq "private" and not variables.methods_arr[i].metadata.getPrivate()>
					<cfset privateMethods_bool = true />
				</cfif>
			</cfloop>
			<cfif publicMethods_bool>
				<tr>
					<td></td>
					<td colspan="2">
						<b>Public Methods</b>
					</td>
				</tr>
				<cfloop from="1" to="#arrayLen(methods_arr)#" index="j">
					<cfif methods_arr[j].metadata.getAccess() eq "public" and not methods_arr[j].metadata.getPrivate()>
						<tr>
							<td></td>
							<td>
								<cfoutput>#methods_arr[j].name#</cfoutput>
							</td>
							<td>
								<cfoutput>#methods_arr[j].metadata.getShortHint()#</cfoutput>
							</td>
							<td>
								<cfoutput>#methods_arr[j].definedBy#</cfoutput>
							</td>
						</tr>
					</cfif>
				</cfloop>
			</cfif>
			<cfif privateMethods_bool>
				<tr>
					<td></td>
					<td colspan="2">
						<b>Private Methods</b>
					</td>
				</tr>
				<cfloop from="1" to="#arrayLen(methods_arr)#" index="j">
					<cfif methods_arr[j].metadata.getAccess() eq "private" and not methods_arr[j].metadata.getPrivate()>
						<tr>
							<td></td>
							<td>
								<cfoutput>#methods_arr[j].name#</cfoutput>
							</td>
							<td>
								<cfoutput>#methods_arr[j].metadata.getShortHint()#</cfoutput>
							</td>
							<td>
								<cfoutput>#methods_arr[j].definedBy#</cfoutput>
							</td>
						</tr>
					</cfif>
				</cfloop>
			</cfif>
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
