<!--- 
	This template requires the name packageName_str of the package.
	Also, it requires an array of structs components_arr in the variables scope containing the 
	names of all components in the package, together with their short descriptions and a 
	similar array of structs interfaces_arr for the interfaces. Struct keys for both array 
	structs are "name" and "description". Elements are sorted alphabetically by name.
 --->
<!doctype html public "-//w3c//dtd HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" />
<html>

<cfset rootPath_str = repeatString("../", listLen(packageName_str, ".")) />
<cfset packagePath_str = replace(packageName_str, ".", "/") & "/" />

<cfoutput>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="#variables.rootPath_str#style.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="#variables.rootPath_str#print.css" type="text/css" media="print" />
		<link rel="stylesheet" href="#variables.rootPath_str#override.css" type="text/css" />
		<title>#packageName_str# Summary</title>
	</head>

	<body>
	<script language="javascript" type="text/javascript" src="#variables.rootPath_str#asdoc.js">
	</script>
	<script language="javascript" type="text/javascript" src="#variables.rootPath_str#help.js">
	</script>
	<script language="javascript" type="text/javascript" src="#variables.rootPath_str#cookies.js">
	</script>
	<script language="javascript" type="text/javascript"><!--
		asdocTitle = '#packageName_str# package - API Documentation';
		var baseRef = '#variables.rootPath_str#';
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
				<a href="#variables.rootPath_str#package-summary.html" 
					onclick="loadClassListFrame('#variables.rootPath_str#all-classes.html')">
					All Packages</a>
				|
				<a href="#variables.rootPath_str#class-summary.html" 
					onclick="loadClassListFrame('#variables.rootPath_str#all-classes.html')">
					All Classes</a>
				|
				<a id="framesLink1" 
					href="#variables.rootPath_str#index.html?#variables.packagePath_str#package-detail.html&amp;#variables.packagePath_str#class-list.html">
					Frames</a>
				<a id="noFramesLink1" 
					style="display:none" 
					href="" 
					onclick="parent.location=document.location">
					No Frames</a>
			</td>
			<td class="titleTableLogo" align="right" rowspan="3">
				<img src="#variables.rootPath_str#images/logo.png" class="logoImage" title="Rhinofly Logo" alt="Rhinofly Logo">
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
	
	<div class="MainContent">
	
	<cfif arrayLen(variables.interfaces_arr) gt 0>
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

			<cfset rowOdd_num = 0 />
			
			<cfloop from="1" to="arrayLen(variables.interfaces_arr)" index="i">
				<cfset componentName_str = variables.interfaces_arr[i].name />
				<cfset componentPage_str = listLast(variables.componentName_str, ".") & ".html" />
				<cfif variables.rowOdd_num>
					<cfset rowOdd_num = 0 />
				<cfelse>
					<cfset rowOdd_num = 1 />
				</cfif>
				<tr class="prow#variables.rowOdd_num#">
					<td class="summaryTablePaddingCol">
						&nbsp;
					</td>
					<td class="summaryTableSecondCol">
						<i>
							<a href="#variables.componentPage_str#" title="#variables.componentName_str#">
								#listLast(variables.componentName_str, ".")#
							</a>
						</i>
					</td>
					<td class="summaryTableLastCol">
						#variables.interfaces_arr[i].description#
					</td>
				</tr>
			</cfloop>
		</table>

		<cfif listLen(variables.components_str) gt 0>
			<p></p>
		</cfif>
	</cfif>

	<cfif listLen(variables.components_str) gt 0>
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

			<cfset rowOdd_num = 0 />
			
			<cfloop from="1" to="arrayLen(variables.components_arr)" index="i">
				<cfset componentName_str = variables.components_arr[i].name />
				<cfset componentPage_str = listLast(variables.componentName_str, ".") & ".html" />
				<cfif variables.rowOdd_num>
					<cfset rowOdd_num = 0 />
				<cfelse>
					<cfset rowOdd_num = 1 />
				</cfif>
				<tr class="prow#variables.rowOdd_num#">
					<td class="summaryTablePaddingCol">
						&nbsp;
					</td>
					<td class="summaryTableSecondCol">
						<i>
							<a href="#variables.componentPage_str#" title="#variables.componentName_str#">
								#listLast(variables.componentName_str, ".")#
							</a>
						</i>
					</td>
					<td class="summaryTableLastCol">
						#variables.components_arr[i].description#
					</td>
				</tr>
			</cfloop>
		</table>
	</cfif>

	</div>
	</body>
</cfoutput>
</html>