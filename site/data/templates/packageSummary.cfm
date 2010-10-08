<!--- 
	This template requires a struct packages in the model scope containing the names 
	of all packages as keys. Although this template creates a summary-like page, there are no 
	descriptions for packages. Therefore, essentially, this is the same list as constructed in 
	packageList.cfm.
	Finally, it requires an object rendering of the type cfc.TemplateRendering.
 --->
<cfif not isDefined("renderLink")>
	<cfinclude template="./includes/fnc_renderLink.cfm" />
</cfif>

<cfset localVar.packages_str = listSort(structKeyList(model.packages), "textnocase") />

<!doctype html public "-//w3c//dtd HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" />
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>All Packages</title>
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
		asdocTitle = 'All Packages - API Documentation';
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
				CSO-API Documentation
			</td>
			<td class="titleTableTopNav" align="right">
				<a href="class-summary.html" 
					onclick="loadClassListFrame('all-classes.html')">
					All Classes
				</a>
				&nbsp;|&nbsp;
				<a id="framesLink1" 
					href="index.html?package-summary.html&amp;all-classes.html">
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
				All Packages
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
		if (!isEclipse() || window.name != ECLIPSE_FRAME_NAME) {titleBar_setSubTitle("All Packages"); titleBar_setSubNav(false,false,false,false,false,false,false,false,false,false,false	,false,false,false,false,false);}
	--></script>
	
	<div class="MainContent">
	<table cellpadding="3" cellspacing="0" class="summaryTable">
		<tr>
			<th>
				&nbsp;
			</th>
			<th width="30%">
				Package
			</th>
			<th width="70%">
				&nbsp;
			</th>
		</tr>

		<cfset localVar.rowOdd_num = 0 />
		
		<cfoutput>
			<cfloop list="#localVar.packages_str#" index="localVar.packageKey_str">
				<cfif localVar.rowOdd_num>
					<cfset localVar.rowOdd_num = 0 />
				<cfelse>
					<cfset localVar.rowOdd_num = 1 />
				</cfif>
				<tr class="prow#localVar.rowOdd_num#">
					<td class="summaryTablePaddingCol">
						&nbsp;
					</td>
					<td class="summaryTableSecondCol">
						#packageLink(localVar.packageKey_str)#
					</td>
					<td class="summaryTableLastCol">
					</td>
				</tr>
			</cfloop>
		</cfoutput>
	</table>
	</div>
</body>
</html>