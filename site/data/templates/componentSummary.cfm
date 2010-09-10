<!--- 
	This template requires an array of structs components_arr in the model scope containing 
	the names of all components in the library (ordered alphabetically by last name), 
	together with their short descriptions. Struct keys are "name" and "description".
	Also, it requires an object rendering_obj of the type cfc.TemplateRendering.
 --->
<!doctype html public "-//w3c//dtd HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" />
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>All Classes</title>
	<link rel="stylesheet" href="style.css" type="text/css" media="screen" />
	<link rel="stylesheet" href="print.css" type="text/css" media="print" />
	<link rel="stylesheet" href="override.css" type="text/css" />
</head>

<body>
	<script language="javascript" type="text/javascript" src="asdoc.js">
	</script>
	<script language="javascript" type="text/javascript" src="help.js">
	</script>
	<script language="javascript" type="text/javascript" src="cookies.js">
	</script>
	<script language="javascript" type="text/javascript"><!--
		asdocTitle = 'All Classes - API Documentation';
		var baseRef = '';
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
				API Documentation
			</td>
			<td class="titleTableTopNav" align="right">
				<a href="package-summary.html" 
					onclick="loadClassListFrame('all-classes.html')">
					All Packages
				</a>
				&nbsp;|&nbsp;
				<a id="framesLink1" 
					href="index.html?class-summary.html&amp;all-classes.html">
					Frames
				</a>
				<a id="noFramesLink1" 
					style="display:none" 
					href="" 
					onclick="parent.location=document.location">
					No Frames
				</a>
			</td>
			<td class="titleTableLogo" align="right" rowspan="3">
				<img src="images/logo.png" class="logoImage" title="Rhinofly Logo" alt="Rhinofly Logo">
			</td>
		</tr>
		<tr class="titleTableRow2">
			<td class="titleTableSubTitle" id="subTitle" align="left">
				All Classes
			</td>
			<td class="titleTableSubNav" id="subNav" align="right">
			</td>
		</tr>
		<tr class="titleTableRow3">
			<td colspan="3">
				&nbsp;
			</td>
		</tr>
	</table>
	
	<script language="javascript" type="text/javascript" xml:space="preserve"><!--
					if (!isEclipse() || window.name != ECLIPSE_FRAME_NAME) {titleBar_setSubTitle("All Classes"); titleBar_setSubNav(false,false,false,false,false,false,false,false,false,false,false	,false,false,false,false,false);}	
	--></script>
	
	<div class="MainContent"><br />
	<p>
		Documentation for components includes syntax and usage information for methods and 
		properties for those APIs that belong to a specific library. The components are 
		listed alphabetically.
	</p>

	<table cellpadding="3" cellspacing="0" class="summaryTable">
		<tr>
			<th>
				&nbsp;
			</th>
			<th width="20%">
				Component
			</th>
			<th width="20%">
				Package
			</th>
			<th width="60%">
				Description
			</th>
		</tr>

		<cfset rowOdd_num = 0 />
		
		<cfloop from="1" to="arrayLen(model.components_arr)" index="local.row_num">
			<cfset local.componentName_str = model.components_arr[local.row_num].name />
			<cfset local.packageName_str = listDeleteAt(local.componentName_str, listLen(local.componentName_str, "."), ".") />
			<cfset local.packagePath_str = replace(local.packageName_str, ".", "/", "all") & "/" />
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
						#model.rendering_obj.convertToLink(local.componentName_str, "", true)#
					</td>
					<td class="summaryTableCol">
						<a href="#local.packagePath_str#package-detail.html" 
							onclick="javascript:loadClassListFrame('#local.packagePath_str#class-list.html');">
							#local.packageName_str#</a>
					</td>
					<td class="summaryTableLastCol">
						#model.components_arr[local.row_num].description#
					</td>
				</tr>
			</cfoutput>
		</cfloop>
	</table>
	</div>

</body>
</html>