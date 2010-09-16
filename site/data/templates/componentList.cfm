<!--- 
	This template requires the name packageName_str of the package in the model scope.
	Also, it requires an alphabetically sorted array of metadata objects interfaces_arr in 
	the model scope for all interfaces in the library (sorted by last name) and a similar 
	array of components_arr for the (non-interface) components.
	Finally, it requires an object rendering_obj of the type cfc.TemplateRendering.
 --->
<!doctype html public "-//w3c//dtd HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" />
<html>


<cfif len(model.packageName_str) eq 0>
	<cfset localVar.rootPath_str = "" />
	<cfset local.displayName_str = "Top Level" />
<cfelse>
	<cfset localVar.rootPath_str = repeatString("../", listLen(model.packageName_str, ".")) />
	<cfset local.displayName_str = model.packageName_str />
</cfif>

<cfoutput>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>#local.displayName_str# - CSO-API Documentation</title>
		<base target="classFrame" />
		<link rel="stylesheet" href="#localVar.rootPath_str#style.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="#localVar.rootPath_str#print.css" type="text/css" media="print" />
		<link rel="stylesheet" href="#localVar.rootPath_str#override.css" type="text/css" />
	</head>

	<body class="classFrameContent">
	<h3>
		<a href="package-detail.html" target="classFrame" style="color:black">
			Package #local.displayName_str#</a>
	</h3>
	
	<cfif arrayLen(model.interfaces_arr) gt 0>
		<a href="package-detail.html##interfaceSummary" style="color:black">
			<b>Interfaces</b>
		</a>
		<ul>
			<cfloop from="1" to="#arrayLen(model.interfaces_arr)#" index="localVar.row_num">
				<li>
					#model.rendering_obj.convertToLink(model.interfaces_arr[localVar.row_num].getName(), "", true, false, true)#
				</li>
			</cfloop>
		</ul>
	</cfif>

	<cfif arrayLen(model.components_arr) gt 0>
		<a href="package-detail.html##componentSummary" style="color:black">
			<b>Components</b>
		</a>
		<ul>
			<cfloop from="1" to="#arrayLen(model.components_arr)#" index="localVar.row_num">
				<li>
					#model.rendering_obj.convertToLink(model.components_arr[localVar.row_num].getName(), "", true, false, true)#
				</li>
			</cfloop>
		</ul>
	</cfif>
	
	</body>
</cfoutput>

</html>