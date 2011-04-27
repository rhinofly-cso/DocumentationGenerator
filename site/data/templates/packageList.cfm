<!--- 
	This template requires a struct packages in the model scope containing the names 
	of all packages as keys. A package is a collection of components found in a single 
	directory. These components all have the same name up to the last dot. The package name is 
	then given by this collective path name.
 --->
<cfif not isDefined("renderLink")>
	<cfinclude template="includes/fnc_renderFunctions.cfm" />
</cfif>

<cfset localVar.packages_str = listSort(structKeyList(model.packages), "textnocase") />

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

<ul class="plainList">
	<cfoutput>
		<cfloop list="#localVar.packages_str#" index="localVar.packageKey_str">
			<li>
				#packageLink(localVar.packageKey_str)#
			</li>
		</cfloop>
	</cfoutput>
</ul>

</body>
</html>