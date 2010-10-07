<!--- 
	This template requires an alphabetically sorted array of metadata objects components_arr 
	in the model scope for all components in the library (sorted by last name).
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
		Documentation for classes includes syntax and usage information for methods and 
		properties.
	</p>

	<table cellpadding="3" cellspacing="0" class="summaryTable">
		<tr>
			<th>
				&nbsp;
			</th>
			<th width="20%">
				Class
			</th>
			<th width="20%">
				Package
			</th>
			<th width="60%">
				Description
			</th>
		</tr>

		<cfset localVar.rowOdd_num = 0 />
		
		<cfloop from="1" to="#arrayLen(model.components)#" index="localVar.row_num">
			<cfset localVar.componentName_str = model.components[localVar.row_num].getName() />
			<cfset localVar.packageName_str = listDeleteAt(localVar.componentName_str, listLen(localVar.componentName_str, "."), ".") />
			<cfif localVar.rowOdd_num>
				<cfset localVar.rowOdd_num = 0 />
			<cfelse>
				<cfset localVar.rowOdd_num = 1 />
			</cfif>
			<cfoutput>
				<tr class="prow#localVar.rowOdd_num#">
					<td class="summaryTablePaddingCol">
						&nbsp;
					</td>
					<td class="summaryTableSecondCol">
						#model.rendering.convertToLink(localVar.componentName_str, "", true)#
					</td>
					<td class="summaryTableCol">
						#model.rendering.packageLink(localVar.packageName_str)#
					</td>
					<td class="summaryTableLastCol">
						<cftry>
							#model.rendering.renderHint(model.components[localVar.row_num], "", "short")#
							<cfcatch type="any">
								<cfthrow message="Please review the comments in component #localVar.componentName_str#." detail="#cfcatch.message#">
							</cfcatch>
						</cftry>
					</td>
				</tr>
			</cfoutput>
		</cfloop>
	</table>
	</div>

</body>
</html>