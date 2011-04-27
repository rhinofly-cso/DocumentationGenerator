<!--- 
	This template requires the string packageKey in the model scope.
	Also, it requires an alphabetically sorted array interfaces of metadata objects in 
	the model scope for all interfaces in the library (sorted by last name) and a similar 
	array components for the (non-interface) components.
 --->
<cfif not isDefined("renderLink")>
	<cfinclude template="includes/fnc_renderFunctions.cfm" />
</cfif>

<!doctype html public "-//w3c//dtd HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" />
<html>


<cfif model.packageKey eq "_topLevel">
	<cfset localVar.packagePath_str = "" />
	<cfset localVar.rootPath_str = "" />
	<cfset local.packageDisplayName_str = "Top Level" />
<cfelse>
	<cfset localVar.packagePath_str = replace(model.packageKey, ".", "/", "all") & "/" />
	<cfset localVar.rootPath_str = repeatString("../", listLen(model.packageKey, ".")) />
	<cfset local.packageDisplayName_str = model.packageKey />
</cfif>

<cfoutput>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="#localVar.rootPath_str#style.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="#localVar.rootPath_str#print.css" type="text/css" media="print" />
		<link rel="stylesheet" href="#localVar.rootPath_str#override.css" type="text/css" />
		<title>#local.packageDisplayName_str# Summary</title>
	</head>

	<body>
	<script language="javascript" type="text/javascript" src="#localVar.rootPath_str#asdoc.js">
	</script>
	<script language="javascript" type="text/javascript" src="#localVar.rootPath_str#help.js">
	</script>
	<script language="javascript" type="text/javascript" src="#localVar.rootPath_str#cookies.js">
	</script>
	<script language="javascript" type="text/javascript"><!--
		asdocTitle = '#local.packageDisplayName_str# package - API Documentation';
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
				#local.packageDisplayName_str#
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
			titleBar_setSubTitle("#local.packageDisplayName_str#");
			titleBar_setSubNav(false,false,false,false,false,false,false,false,false,false,false,false,false,true,false,false);
		}
	--></script>
</cfoutput>
	
<div class="MainContent">

<cfif arrayLen(model.interfaces) gt 0>
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
		
		<cfloop from="1" to="#arrayLen(model.interfaces)#" index="localVar.row_num">
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
						#renderLink(model.interfaces[localVar.row_num].getName(), "", true, false, true)#
					</td>
					<td class="summaryTableLastCol">
						<cftry>
							#renderHint(model.interfaces[localVar.row_num], localVar.rootPath_str, "short")#
							<cfcatch type="any">
								<cfthrow message="Please review the comments in component #localVar.componentName_str#." detail="#cfcatch.message#">
							</cfcatch>
						</cftry>
					</td>
				</tr>
			</cfoutput>
		</cfloop>
	</table>

	<cfif arrayLen(model.components) gt 0>
		<br />
	</cfif>
</cfif>

<cfif arrayLen(model.components) gt 0>
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
		
		<cfloop from="1" to="#arrayLen(model.components)#" index="localVar.row_num">
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
						#renderLink(model.components[localVar.row_num].getName(), "", true, false, true)#
					</td>
					<td class="summaryTableLastCol">
						<cftry>
							#renderHint(model.components[localVar.row_num], localVar.rootPath_str, "short")#
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