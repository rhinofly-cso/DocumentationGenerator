<!--- 
	This template requires the name packageName_str of the package in the model scope.
	Also, it requires an array of structs components_arr containing the names of all 
	components in the package, together with their short descriptions and a similar array of 
	structs interfaces_arr for the interfaces. These arrays are also used in packageDetail.cfm.
	Finally, it requires an object rendering_obj of the type cfc.TemplateRendering.
 --->
<!doctype html public "-//w3c//dtd HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" />
<html>

<cfset local.rootPath_str = repeatString("../", listLen(model.packageName_str, ".")) />

<cfoutput>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>#model.packageName_str# - CSO-API Documentation</title>
		<base target="classFrame" />
		<link rel="stylesheet" href="#local.rootPath_str#style.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="#local.rootPath_str#print.css" type="text/css" media="print" />
		<link rel="stylesheet" href="#local.rootPath_str#override.css" type="text/css" />
	</head>

	<body class="classFrameContent">
	<h3>
		<a href="package-detail.html" target="classFrame" style="color:black">
			Package #model.packageName_str#
		</a>
	</h3>
	
	<ul>
		<cfif arrayLen(model.interfaces_arr) gt 0>
			<li>
				<a href="package-detail.html##interfaceSummary" style="color:black">
					<b>Interfaces</b>
				</a>
			</li>

			<cfloop from="1" to="arrayLen(model.interfaces_arr)" index="local.row_num">
				<li>
					#model.rendering_obj.convertToLink(model.interfaces_arr[local.row_num].name, "", true, false, true)#
				</li>
			</cfloop>
		
			<li>&nbsp;</li>
		</cfif>

		<cfif arrayLen(model.components_arr) gt 0>
			<li>
				<a href="package-detail.html##componentSummary" style="color:black">
					<b>Components</b>
				</a>
			</li>

			<cfloop from="1" to="arrayLen(model.components_arr)" index="local.row_num">
				<li>
					#model.rendering_obj.convertToLink(model.components_arr[local.row_num].name, "", true, false, true)#
				</li>
			</cfloop>
		
			<li></li>
		</cfif>
	</ul>
	
	</body>
</cfoutput>

</html>