<cfset factory_obj = createObject("component", "cfc.MetadataFactory") />

<html>
<head>
<title>Document generator</title>
</head>

<body>

<cfset path_str = "C:\development\docGen\data" />
<cfoutput>#path_str#</cfoutput>

<cfset library_struct = structNew() />

<cfset factory_obj.browseDirectory(path_str, path_str, library_struct) />
<cfdump var="#library_struct["cfc.CFCMetadata"]#" expand="false" />

<cfflush />

<h3>Tests</h3>
<cfset data = getComponentMetaData("cfc.TestInterface") />
<cfdump var="#data#" expand="false" />
<cfset data = getComponentMetaData("cfc.TestImplementation") />
<cfdump var="#data#" expand="false" />

</body>
</html>
</head>
