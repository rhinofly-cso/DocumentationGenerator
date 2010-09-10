<!--- 
	This template requires the name packageName_str of the package in the model scope.
	Also, it requires an array of structs components_arr containing the names of all 
	components in the package, together with their short descriptions and a similar array of 
	structs interfaces_arr for the interfaces. Struct keys for both array structs are "name" 
	and "description". Elements are sorted alphabetically by name.
	Finally, it requires an object rendering_obj of the type cfc.TemplateRendering.
 --->
<!doctype html public "-//w3c//dtd HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" />
<html>

<cfset local.rootPath_str = repeatString("../", listLen(model.packageName_str, ".")) />
<cfset local.packagePath_str = replace(model.packageName_str, ".", "/", "all") & "/" />

<cfoutput>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="#local.rootPath_str#style.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="#local.rootPath_str#print.css" type="text/css" media="print" />
		<link rel="stylesheet" href="#local.rootPath_str#override.css" type="text/css" />
		<title>#model.packageName_str# Summary</title>
	</head>

	<body>
	<script language="javascript" type="text/javascript" src="#local.rootPath_str#asdoc.js">
	</script>
	<script language="javascript" type="text/javascript" src="#local.rootPath_str#help.js">
	</script>
	<script language="javascript" type="text/javascript" src="#local.rootPath_str#cookies.js">
	</script>
	<script language="javascript" type="text/javascript"><!--
		asdocTitle = '#packageName_str# package - API Documentation';
		var baseRef = '#local.rootPath_str#';
		window.onload = configPage;
	--></script>
	<script type="text/javascript">
		scrollToNameAnchor();
	</script>
	
	<table class="titleTable" 
		cellpadding="0" 
		cellspacing="0" 
		id="titleTable" 
		style="display:none">
		<tr>
			<td class="titleTableTitle" align="left">
				CSO-API Documentation
			</td>
			<td class="titleTableTopNav" align="right">
				<a href="#local.rootPath_str#package-summary.html" 
					onclick="loadClassListFrame('#local.rootPath_str#all-classes.html')">
					All Packages</a>
				|
				<a href="#local.rootPath_str#class-summary.html" 
					onclick="loadClassListFrame('#local.rootPath_str#all-classes.html')">
					All Classes</a>
				|
				<a id="framesLink1" 
					href="#local.rootPath_str#index.html?#local.packagePath_str#package-detail.html&amp;#local.packagePath_str#class-list.html">
					Frames</a>
				<a id="noFramesLink1" 
					style="display:none" 
					href="" 
					onclick="parent.location=document.location">
					No Frames</a>
			</td>
			<td class="titleTableLogo" align="right" rowspan="3">
				<img src="#local.rootPath_str#images/logo.png" class="logoImage" title="Rhinofly Logo" alt="Rhinofly Logo">
			</td>
		</tr>
		<tr class="titleTableRow2">
			<td class="titleTableSubTitle" id="subTitle" align="left">
				#packageName_str#
			</td>
		</tr>
		<tr class="titleTableRow3">
			<td colspan="3">
				&nbsp;
			</td>
		</tr>
	</table>
	
	<script language="javascript" type="text/javascript" xml:space="preserve"><!--
		if (!isEclipse() || window.name != ECLIPSE_FRAME_NAME)
		{
			titleBar_setSubTitle("#packageName_str#");
			titleBar_setSubNav(false,false,false,false,false,false,false,false,false,false,false,false,false,true,false,false);
		}
	--></script>
</cfoutput>
	
<div class="MainContent">

<cfif arrayLen(model.interfaces_arr) gt 0>
	<a name="interfaceSummary"></a>
	<div class="summaryTableTitle">
		Interfaces
	</div>

	<table cellpadding="3" cellspacing="0" class="summaryTable">
		<tr>
			<th>
				&nbsp;
			</th>
			<th width="30%">
				Interface
			</th>
			<th width="70%">
				Description
			</th>
		</tr>

		<cfset local.rowOdd_num = 0 />
		
		<cfloop from="1" to="arrayLen(model.interfaces_arr)" index="local.row_num">
			<cfif local.rowOdd_num>
				<cfset local.rowOdd_num = 0 />
			<cfelse>
				<cfset local.rowOdd_num = 1 />
			</cfif>
			<cfoutput>
				<tr class="prow#local.rowOdd_num#">
					<td class="summaryTablePaddingCol">
						&nbsp;
					</td>
					<td class="summaryTableSecondCol">
						#model.rendering_obj.convertToLink(model.interfaces_arr[local.row_num].name, "", true, false, true)#
					</td>
					<td class="summaryTableLastCol">
						#model.interfaces_arr[local.row_num].description#
					</td>
				</tr>
			</cfoutput>
		</cfloop>
	</table>

	<cfif arrayLen(model.components_arr) gt 0>
		<br />
	</cfif>
</cfif>

<cfif arrayLen(model.components_arr) gt 0>
	<a name="componentSummary"></a>
	<div class="summaryTableTitle">
		Components
	</div>

	<table cellpadding="3" cellspacing="0" class="summaryTable">
		<tr>
			<th>
				&nbsp;
			</th>
			<th width="30%">
				Component
			</th>
			<th width="70%">
				Description
			</th>
		</tr>

		<cfset local.rowOdd_num = 0 />
		
		<cfloop from="1" to="arrayLen(model.components_arr)" index="local.row_num">
			<cfif local.rowOdd_num>
				<cfset local.rowOdd_num = 0 />
			<cfelse>
				<cfset local.rowOdd_num = 1 />
			</cfif>
			<cfoutput>
				<tr class="prow#local.rowOdd_num#">
					<td class="summaryTablePaddingCol">
						&nbsp;
					</td>
					<td class="summaryTableSecondCol">
						#model.rendering_obj.convertToLink(model.components_arr[local.row_num].name, "", true, false, true)#
					</td>
					<td class="summaryTableLastCol">
						#model.components_arr[local.row_num].description#
					</td>
				</tr>
			</cfoutput>
		</cfloop>
	</table>
</cfif>

</div>
</body>
</html>