<!--- 
	This template requires the metadata object cfMetadata_obj of the component in the 
	model scope.
	Also, it requires an array of structs properties_arr containing the names of all 
	properties of the component and its ancestors, together with their metadata object, and 
	the name of the component they are defined by. Struct keys are "name", "metadata", and 
	"definedBy".
	A similar array of structs methods_arr is required for all methods. This includes an extra 
	key "override" which designates that the method definition aoverrides an earlier 
	definition.
	Finally, it requires an object rendering_obj of the type cfc.TemplateRendering.
 --->
<cfinclude template="./includes/fnc_collectProperties.cfm" />
<cfinclude template="./includes/fnc_collectMethods.cfm" />

<!doctype html public "-//w3c//dtd HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" />
<html>

<cfif isInstanceOf(model.cfMetadata_obj, "cfc.cfcData.CFInterface")>
	<cfset local.type_str = "Interface" />
<cfelseif isInstanceOf(model.cfMetadata_obj, "cfc.cfcData.CFComponent")>
	<cfset local.type_str = "Component" />
<cfelse>
	<cfthrow message="Error: unknown component type #getMetadata(model.cfMetadata_obj).name#.">
</cfif>

<cfset local.componentName_str = model.cfMetadata_obj.getName() />
<cfset local.componentPage_str = replace(local.componentName_str, ".", "/", "all") & ".html" />
<cfset local.packageName_str = listDeleteAt(local.componentName_str, listLen(local.componentName_str, "."), ".") />
<cfset local.packagePath_str = replace(local.packageName_str, ".", "/", "all") & "/" />
<cfset local.rootPath_str = repeatString("../", listLen(local.packageName_str, ".")) />

<cfset local.properties_struct = collectProperties(local.componentName_str, model.properties_arr, model.rendering_obj) />
<cfset local.methods_struct = collectMethods(local.componentName_str, model.methods_arr, model.rendering_obj) />

<head>
<cfoutput>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<link rel="stylesheet" href="#local.rootPath_str#style.css" type="text/css" media="screen" />
	<link rel="stylesheet" href="#local.rootPath_str#print.css" type="text/css" media="print" />
	<link rel="stylesheet" href="#local.rootPath_str#override.css" type="text/css" />
	<title>#local.componentName_str#</title>
</cfoutput>
</head>

<body>
<cfoutput>
	<script language="javascript" type="text/javascript" src="#local.rootPath_str#asdoc.js">
	</script>
	<script language="javascript" type="text/javascript" src="#local.rootPath_str#help.js">
	</script>
	<script language="javascript" type="text/javascript" src="#local.rootPath_str#cookies.js">
	</script>
	<script language="javascript" type="text/javascript"><!--
		asdocTitle = '#listLast(local.componentName_str, ".")# - CSO-API Documentation';
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
					href="#local.rootPath_str#index.html?#local.componentPage_str#&amp;#local.packagePath_str#class-list.html">
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
				#listLast(local.componentName_str, ".")#
			</td>
		</tr>
		<tr class="titleTableRow3">
			<td colspan="3"></td>
		</tr>
	</table>
</cfoutput>

<script language="javascript" type="text/javascript" xml:space="preserve"><!--
	if (!isEclipse() || window.name != ECLIPSE_FRAME_NAME)
	{
		titleBar_setSubTitle("JobAPI");
		titleBar_setSubNav(false,false,false,false,false,false,false,false,true,false,false,false,false,false,false,false);
	}
--></script>
	
<div xmlns:fn="http://www.w3.org/2005/xpath-functions" class="MainContent">
	<cfinclude template="./includes/dsp_classHeader.cfm" />
	<br /><hr>
</div>

<cfif arrayLen(local.properties_struct.propertySummaryRows) gt 0 >
	<a name="propertySummary"></a>
	<div class="summarySection">
		<cfinclude template="./includes/dsp_propertySummary.cfm">
	</div>
</cfif>
<cfif arrayLen(local.methods_struct.methodSummaryRows) gt 0>
	<a name="methodSummary"></a>
	<div class="summarySection">
		<cfinclude template="./includes/dsp_methodSummary.cfm">
	</div>
</cfif>
<cfif arrayLen(local.methods_struct.protectedMethodSummaryRows) gt 0>
	<a name="protectedMethodSummary"></a>
	<div class="summarySection">
		<cfinclude template="./includes/dsp_protectedMethodSummary.cfm">
	</div>
</cfif>

<script language="javascript" type="text/javascript"><!--
	showHideInherited();
--></script>

<div class="MainContent">
	<!--- the boolean for non-inherited properties is defined in act_collectProperties.cfm --->
	<cfif arrayLen(local.properties_struct.propertyDetailItems) gt 0>
		<a name="propertyDetail"></a>
		<cfinclude template="./includes/dsp_propertyDetail.cfm">
	</cfif>
	<!--- the boolean for non-inherited methods is defined in act_collectMethods.cfm --->
	<cfif arrayLen(local.methods_struct.methodDetailItems) gt 0>
		<a name="methodDetail"></a>
		<cfinclude template="./includes/dsp_methodDetail.cfm">
	</cfif>
</div>
</body>
</html>