<!--- 
	This template requires the name packageName_str of the package in the model scope.
	Also, it requires an alphabetically sorted array of metadata objects interfaces_arr in 
	the model scope for all interfaces in the library (sorted by last name) and a similar 
	array of components_arr for the (non-interface) components.
	Finally, it requires an object rendering_obj of the type cfc.TemplateRendering.
 --->
<!doctype html public "-//w3c//dtd HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" />
<html>


<cfif len(model.packageName_str) eq 0>
	<cfset localVar.packagePath_str = "" />
	<cfset localVar.rootPath_str = "" />
	<cfset local.displayName_str = "Top Level" />
<cfelse>
	<cfset localVar.packagePath_str = replace(model.packageName_str, ".", "/", "all") & "/" />
	<cfset localVar.rootPath_str = repeatString("../", listLen(model.packageName_str, ".")) />
	<cfset local.displayName_str = model.packageName_str />
</cfif>

<cfoutput>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="#localVar.rootPath_str#style.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="#localVar.rootPath_str#print.css" type="text/css" media="print" />
		<link rel="stylesheet" href="#localVar.rootPath_str#override.css" type="text/css" />
		<title>#local.displayName_str# Summary</title>
	</head>

	<body>
	<script language="javascript" type="text/javascript" src="#localVar.rootPath_str#asdoc.js">
	</script>
	<script language="javascript" type="text/javascript" src="#localVar.rootPath_str#help.js">
	</script>
	<script language="javascript" type="text/javascript" src="#localVar.rootPath_str#cookies.js">
	</script>
	<script language="javascript" type="text/javascript"><!--
		asdocTitle = '#local.displayName_str# package - API Documentation';
		var baseRef = '#localVar.rootPath_str#';
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
				<a href="#localVar.rootPath_str#package-summary.html" 
					onclick="loadClassListFrame('#localVar.rootPath_str#all-classes.html')">
					All Packages</a>
				|
				<a href="#localVar.rootPath_str#class-summary.html" 
					onclick="loadClassListFrame('#localVar.rootPath_str#all-classes.html')">
					All Classes</a>
				|
				<a id="framesLink1" 
					href="#localVar.rootPath_str#index.html?#localVar.packagePath_str#package-detail.html&amp;#localVar.packagePath_str#class-list.html">
					Frames</a>
				<a id="noFramesLink1" 
					style="display:none" 
					href="" 
					onclick="parent.location=document.location">
					No Frames</a>
			</td>
			<td class="titleTableLogo" align="right" rowspan="3">
				<img src="#localVar.rootPath_str#images/logo.png" class="logoImage" title="Rhinofly Logo" alt="Rhinofly Logo">
			</td>
		</tr>
		<tr class="titleTableRow2">
			<td class="titleTableSubTitle" id="subTitle" align="left">
				#local.displayName_str#
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
			titleBar_setSubTitle("#local.displayName_str#");
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

		<cfset localVar.rowOdd_num = 0 />
		
		<cfloop from="1" to="#arrayLen(model.interfaces_arr)#" index="localVar.row_num">
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
						#model.rendering_obj.convertToLink(model.interfaces_arr[localVar.row_num].getName(), "", true, false, true)#
					</td>
					<td class="summaryTableLastCol">
						<cftry>
							#model.rendering_obj.renderHint(model.interfaces_arr[localVar.row_num], localVar.rootPath_str, "short")#
							<cfcatch type="any">
								<cfthrow message="Please review the comments in component #localVar.componentName_str#." detail="#cfcatch.message#">
							</cfcatch>
						</cftry>
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

		<cfset localVar.rowOdd_num = 0 />
		
		<cfloop from="1" to="#arrayLen(model.components_arr)#" index="localVar.row_num">
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
						#model.rendering_obj.convertToLink(model.components_arr[localVar.row_num].getName(), "", true, false, true)#
					</td>
					<td class="summaryTableLastCol">
						<cftry>
							#model.rendering_obj.renderHint(model.components_arr[localVar.row_num], localVar.rootPath_str, "short")#
							<cfcatch type="any">
								<cfthrow message="Please review the comments in component #localVar.componentName_str#." detail="#cfcatch.message#">
							</cfcatch>
						</cftry>
					</td>
				</tr>
			</cfoutput>
		</cfloop>
	</table>
</cfif>

</div>
</body>
</html>