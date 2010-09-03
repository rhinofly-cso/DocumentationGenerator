<!--- 
	This template requires the name packageName_str of the package.
	Also, it requires a list components_str in the variables scope containing the names of all 
	components in the package and a list interfaces_str containing the names of all interfaces.
 --->
<!doctype html public "-//w3c//dtd HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" />
<html>

<cfset rootPath_str = repeatString("../", listLen(packageName_str, ".")) />

<cfoutput>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>#packageName_str# - CSO-API Documentation</title>
		<base target="classFrame" />
		<link rel="stylesheet" href="#variables.rootPath_str#style.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="#variables.rootPath_str#print.css" type="text/css" media="print" />
		<link rel="stylesheet" href="#variables.rootPath_str#override.css" type="text/css" />
	</head>

	<body class="classFrameContent">
	<h3>
		<a href="package-detail.html" target="classFrame" style="color:black">
			Package #packageName_str#
		</a>
	</h3>
	
	<ul>
		<cfif listLen(variables.interfaces_str) gt 0>
			<li>
				<a href="package-detail.html##interfaceSummary" style="color:black">
					<b>Interfaces</b>
				</a>
			</li>

			<cfloop list="variables.interfaces_str" index="componentName_str">
				<li>
					#variables.builder_obj.convertToLink(componentName_str, variables.libraryRef_struct, "", true, true)#
				</li>
			</cfloop>
		
			<li>&nbsp;</li>
		</cfif>

		<cfif listLen(variables.components_str) gt 0>
			<li>
				<a href="package-detail.html##componentSummary" style="color:black">
					<b>Components</b>
				</a>
			</li>

			<cfloop list="variables.components_str" index="componentName_str">
				<li>
					#variables.builder_obj.convertToLink(componentName_str, variables.libraryRef_struct, "", true, true)#
				</li>
			</cfloop>
		
			<li></li>
		</cfif>
	</ul>
	
	</body>
</cfoutput>

</html>