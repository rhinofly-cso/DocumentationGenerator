<!--- 
	This template requires a list components_str in the variables scope containing the names of 
	all components ordered alphabetically by last name.
	Also, it requires (a reference to) a library structure libraryRef_struct containing 
	component metadata objects for all components in the library.
 --->
<!doctype html public "-//w3c//dtd HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" />
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>All Classes - CSO-API Documentation</title>
	<base target="classFrame" />
	<link rel="stylesheet" href="style.css" type="text/css" media="screen" />
	<link rel="stylesheet" href="print.css" type="text/css" media="print" />
	<link rel="stylesheet" href="override.css" type="text/css" />
</head>

<body class="classFrameContent">
<h3>
	<a href="class-summary.html" style="color:black">
		All Classes
	</a>
</h3>

<ul>
	<cfoutput>
		<cfloop list="variables.components_str" index="componentName_str">
			<cfset componentPage_str = replace(componentName_str, ".", "/") & ".html" />
			<cfif isInstanceOf(libraryRef_struct[componentName_str], "cfc.cfcMetadata.CFInterface")>
				<li>
					<i><a href="#variables.componentPage_str#" title="#componentName_str#">
						#listLast(componentName_str, ".")#</a></i>
				</li>
			<cfelse>
				<li>
					<a href="#variables.componentPage_str#" title="#componentName_str#">
						#listLast(componentName_str, ".")#</a>
				</li>
			</cfif>
		</cfloop>
	</cfoutput>
</ul>

</body>
</html>