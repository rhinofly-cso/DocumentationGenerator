<cfset factory_obj = createObject("component", "cfc.MetadataFactory") />

<html>
<head>
<title>Document generator</title>
</head>

<body>
	
<cfset currentDirectory = GetDirectoryFromPath(GetTemplatePath()) & "newDir" />
<cfoutput>#currentDirectory#<br /></cfoutput>
<cfoutput>#expandPath("\")#<br /></cfoutput>
<cfset path_str = "C:\development\hobby" />
<cfoutput>#path_str#</cfoutput>

<cfset library_struct = structNew() />
<cfset factory_obj.browseDirectory(path_str, path_str, library_struct) />
<cfdump var="#library_struct#" expand="true">

<cfset €euro$ = "geld" />
<pre>
<cfoutput>#€euro$#</cfoutput>
</pre>

<cfset string = "component displayname=""cfc.Soep"" extends=""cfc.Object""#chr(10)#" />
<!--- <cfset string = "public void function soep(required string kip)#chr(10)#" /> --->
<!--- <cfset string = "string property soep" /> --->
<cfset pos_num = 1 />
<cfset started_bool = false />
<cfset output_str = "" />

<cfloop condition="true">
	<cfset match_struct = reFind("[\w\.\$]+(?=[\s=""\(\)])|[\w\.]+$", string, pos_num, true) />
	<cfset pos_num = match_struct.pos[1] />
	
	<cfif pos_num>
		<cfif started_bool>
			<cfset output_str &= "," />
		<cfelse>
			<cfset started_bool = true />
		</cfif>
		<cfset output_str &= mid(string, pos_num, match_struct.len[1]) />
		<cfset pos_num = pos_num + match_struct.len[1] />
	<cfelse>
		<cfbreak />
	</cfif>
</cfloop>
<cfoutput>#output_str#</cfoutput>

<cfset data = getComponentMetaData("cfc.TestImplementation") />
<cfdump var="#data#">
<cfset data = getComponentMetaData("cfc.TestInterface") />
<cfdump var="#data#">

</body>
</html>
</head>
