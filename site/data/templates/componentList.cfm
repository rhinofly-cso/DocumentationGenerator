<!--- 
	This template requires the string packageKey in the model scope.
	Also, it requires an alphabetically sorted array interfaces of metadata objects in the 
	model scope for all interfaces in the library (sorted by last name) and a similar array 
	components for the (non-interface) components.
 --->
<cfif not isDefined("renderLink")>
	<cfinclude template="includes/fnc_renderFunctions.cfm" />
</cfif>

<!doctype html public "-//w3c//dtd HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" />
<html>


<cfif model.packageKey eq "_topLevel">
	<cfset localVar.rootPath_str = "" />
	<cfset local.packageDisplayName_str = "Top Level" />
<cfelse>
	<cfset localVar.rootPath_str = repeatString("../", listLen(model.packageKey, ".")) />
	<cfset local.packageDisplayName_str = model.packageKey />
</cfif>

<cfoutput>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>#local.packageDisplayName_str# - CSO-API Documentation</title>
		<base target="classFrame" />
		<link rel="stylesheet" href="#localVar.rootPath_str#style.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="#localVar.rootPath_str#print.css" type="text/css" media="print" />
		<link rel="stylesheet" href="#localVar.rootPath_str#override.css" type="text/css" />
	</head>

	<body class="classFrameContent">
	<h3>
		<a href="package-detail.html" target="classFrame" style="color:black">
			Package #local.packageDisplayName_str#</a>
	</h3>
	
	<cfif arrayLen(model.interfaces) gt 0>
		<a href="package-detail.html##interfaceSummary" style="color:black">
			<b>Interfaces</b>
		</a>
		<ul class="plainList">
			<cfloop from="1" to="#arrayLen(model.interfaces)#" index="localVar.row_num">
				<li>
					#renderLink(model.interfaces[localVar.row_num].getName(), "", true, false, true)#
				</li>
			</cfloop>
		</ul>
	</cfif>

	<cfif arrayLen(model.components) gt 0>
		<a href="package-detail.html##componentSummary" style="color:black">
			<b>Components</b>
		</a>
		<ul class="plainList">
			<cfloop from="1" to="#arrayLen(model.components)#" index="localVar.row_num">
				<li>
					#renderLink(model.components[localVar.row_num].getName(), "", true, false, true)#
				</li>
			</cfloop>
		</ul>
	</cfif>
	
	</body>
</cfoutput>

</html>