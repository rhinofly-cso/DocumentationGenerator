<!--- 
	This template requires a list packages_str in the variables scope containing the names of 
	all packages. A package is a collection of components found in a single directory. These 
	components all have the same name up to the last dot. The package name is then given by 
	this collective path name.
 --->
<!doctype html public "-//w3c//dtd HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" />
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Package List - CSO-API Documentation</title>
	<base target="classFrame">
	<link rel="stylesheet" href="style.css" type="text/css" media="screen">
	<link rel="stylesheet" href="print.css" type="text/css" media="print">
	<link rel="stylesheet" href="override.css" type="text/css">
	<script language="javascript" src="asdoc.js" type="text/javascript">
	</script>
</head>

<body class="classFrameContent">
<h3>
	<!--- <a href="package-summary.html?listAllClasses" style="color:black"> --->
	<a href="package-summary.html"
		onclick="javascript:loadClassListFrame('all-classes.html');"
		style="color:black">
		Packages
	</a>
</h3>

<ul>
	<cfoutput>
		<cfloop list="variables.packages_str" index="packageName_str">
			<cfset packagePath_str = replace(packageName_str, ".", "/") & "/" />
			<li>
				<!--- <a href="#variables.packagePath_str#package-detail.html?listPackageClasses"> --->
				<a href="#variables.packagePath_str#package-detail.html"
					onclick="javascript:loadClassListFrame('#variables.packagePath_str#class-list.html');">
					#packageName_str#
				</a>
			</li>
		</cfloop>
	</cfoutput>
</ul>

</body>
</html>