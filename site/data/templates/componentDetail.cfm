<!--- 
	This template requires the metadata object cfMetadata of the component in the model scope.
	Also, it requires an array properties of structs containing the names of all properties of 
	the component and its ancestors, together with their metadata object, and the name of the 
	component they are defined by. Struct keys are "name", "metadata", and "definedBy".
	A similar array methods of structs is required for all methods. This includes an extra key 
	"override" which designates that the method definition overrides an earlier definition.
	Finally, it requires an object rendering of the type cfc.TemplateRendering.
 --->
<cfif not isDefined("collectProperties")>
	<cfinclude template="./includes/fnc_collectProperties.cfm" />
</cfif>
<cfif not isDefined("collectMethods")>
	<cfinclude template="./includes/fnc_collectMethods.cfm" />
</cfif>
<cfif not isDefined("renderLink")>
	<cfinclude template="./includes/fnc_renderLink.cfm" />
</cfif>

<!doctype html public "-//w3c//dtd HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" />
<html>

<cfif isInstanceOf(model.cfMetadata, "cfc.cfcData.CFInterface")>
	<cfset localVar.type_str = "Interface" />
<cfelseif isInstanceOf(model.cfMetadata, "cfc.cfcData.CFComponent")>
	<cfset localVar.type_str = "Component" />
<cfelse>
	<cfthrow message="Error: unknown component type #getMetadata(model.cfMetadata).name#.">
</cfif>

<cfset localVar.componentName_str = model.cfMetadata.getName() />
<cfset localVar.componentPage_str = replace(localVar.componentName_str, ".", "/", "all") & ".html" />

<cfif model.packageKey eq "_topLevel">
	<cfset localVar.packagePath_str = "/" />
	<cfset localVar.rootPath_str = "" />
	<cfset localVar.packageDisplayName_str = "Top Level" />
<cfelse>
	<cfset localVar.packagePath_str = replace(model.packageKey, ".", "/", "all") & "/" />
	<cfset localVar.rootPath_str = repeatString("../", listLen(model.packageKey, ".")) />
	<cfset localVar.packageDisplayName_str = model.packageKey />
</cfif>

<cfset localVar.properties_struct = collectProperties(localVar.componentName_str, model.properties, model.rendering) />
<cfset localVar.methods_struct = collectMethods(localVar.componentName_str, model.methods, model.rendering) />

<head>
<cfoutput>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<link rel="stylesheet" href="#localVar.rootPath_str#style.css" type="text/css" media="screen" />
	<link rel="stylesheet" href="#localVar.rootPath_str#print.css" type="text/css" media="print" />
	<link rel="stylesheet" href="#localVar.rootPath_str#override.css" type="text/css" />
	<title>#localVar.componentName_str#</title>
</cfoutput>
</head>

<body>
<cfoutput>
	<script language="javascript" type="text/javascript" src="#localVar.rootPath_str#asdoc.js">
	</script>
	<script language="javascript" type="text/javascript" src="#localVar.rootPath_str#help.js">
	</script>
	<script language="javascript" type="text/javascript" src="#localVar.rootPath_str#cookies.js">
	</script>
	<script language="javascript" type="text/javascript"><!--
		asdocTitle = '#listLast(localVar.componentName_str, ".")# - CSO-API Documentation';
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
					href="#localVar.rootPath_str#index.html?#localVar.componentPage_str#&amp;#localVar.packagePath_str#class-list.html">
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
				#listLast(localVar.componentName_str, ".")#
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

<cfif arrayLen(localVar.properties_struct.propertySummaryRows) gt 0 >
	<a name="propertySummary"></a>
	<div class="summarySection">
		<cfinclude template="./includes/dsp_propertySummary.cfm">
	</div>
</cfif>
<cfif arrayLen(localVar.properties_struct.persistentPropertySummaryRows) gt 0 >
	<a name="persistentPropertySummaryRows"></a>
	<div class="summarySection">
		<cfinclude template="./includes/dsp_persistentPropertySummary.cfm">
	</div>
</cfif>
<cfif arrayLen(localVar.methods_struct.methodSummaryRows) gt 0>
	<a name="methodSummary"></a>
	<div class="summarySection">
		<cfinclude template="./includes/dsp_methodSummary.cfm">
	</div>
</cfif>
<cfif arrayLen(localVar.methods_struct.remoteMethodSummaryRows) gt 0>
	<a name="remoteMethodSummary"></a>
	<div class="summarySection">
		<cfinclude template="./includes/dsp_remoteMethodSummary.cfm">
	</div>
</cfif>
<cfif arrayLen(localVar.methods_struct.protectedMethodSummaryRows) gt 0>
	<a name="protectedMethodSummary"></a>
	<div class="summarySection">
		<cfinclude template="./includes/dsp_protectedMethodSummary.cfm">
	</div>
</cfif>

<div class="MainContent">
	<!--- the boolean for non-inherited properties is defined in act_collectProperties.cfm --->
	<cfif arrayLen(localVar.properties_struct.propertyDetailItems) gt 0>
		<a name="propertyDetail"></a>
		<cfinclude template="./includes/dsp_propertyDetail.cfm">
	</cfif>
	<!--- the boolean for non-inherited methods is defined in act_collectMethods.cfm --->
	<cfif arrayLen(localVar.methods_struct.methodDetailItems) gt 0>
		<a name="methodDetail"></a>
		<cfinclude template="./includes/dsp_methodDetail.cfm">
	</cfif>
</div>
</body>
</html>