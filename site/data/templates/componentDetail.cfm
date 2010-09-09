<!--- 
	This template requires the metadata object cfMetadata_obj of the component in the 
	variable scope.
	Also, it requires (a reference to) a library structure libraryRef_struct containing 
	component metadata objects for all components in the library.
	Finally, it requires an object builder_obj of the type cfc.DocumentBuilder for invoking 
	its methods.
 --->
<!doctype html public "-//w3c//dtd HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" />
<html>

<cfif isInstanceOf(cfMetadata_obj, "cfc.cfcData.CFInterface")>
	<cfset type_str = "Interface" />
<cfelseif isInstanceOf(cfMetadata_obj, "cfc.cfcData.CFComponent")>
	<cfset type_str = "Component" />
<cfelse>
	<cfthrow message="Error: unknown component type #getMetadata(cfMetadata_obj).name#.">
</cfif>

<cfset componentName_str = variables.cfMetadata_obj.getName() />
<cfset componentPage_str = replace(variables.componentName_str, ".", "/", "all") & ".html" />
<cfset packageName_str = listDeleteAt(variables.componentName_str, listLen(variables.componentName_str, "."), ".") />
<cfset packagePath_str = replace(variables.packageName_str, ".", "/", "all") & "/" />
<cfset rootPath_str = repeatString("../", listLen(variables.packageName_str, ".")) />

<cfset author_str = cfMetadata_obj.getAuthor() />
<cfset date_str = cfMetadata_obj.getDate() />
<cfset hint_str = cfMetadata_obj.getHint() />
<cfset related_str = cfMetadata_obj.getRelated() />

<cfset properties_arr = builder_obj.propertyArray(componentName_str, libraryRef_struct) />
<cfset methods_arr = builder_obj.methodArray(componentName_str, libraryRef_struct) />
<cfset publicMethods_bool = false />
<cfset privateMethods_bool = false />
<cfloop from="1" to="#arrayLen(variables.methods_arr)#" index="i">
	<cfif not variables.methods_arr[i].metadata.getPrivate()>
		<cfif variables.methods_arr[i].metadata.getAccess() eq "public">
			<cfset publicMethods_bool = true />
		<cfelseif variables.methods_arr[i].metadata.getAccess() eq "private">
			<cfset privateMethods_bool = true />
		</cfif>
	</cfif>
</cfloop>

<cfoutput>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="#variables.rootPath_str#style.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="#variables.rootPath_str#print.css" type="text/css" media="print" />
		<link rel="stylesheet" href="#variables.rootPath_str#override.css" type="text/css" />
		<title>#variables.componentName_str#</title>
	</head>

	<body>
	<script language="javascript" type="text/javascript" src="#variables.rootPath_str#asdoc.js">
	</script>
	<script language="javascript" type="text/javascript" src="#variables.rootPath_str#help.js">
	</script>
	<script language="javascript" type="text/javascript" src="#variables.rootPath_str#cookies.js">
	</script>
	<script language="javascript" type="text/javascript"><!--
		asdocTitle = '#listLast(variables.componentName_str, ".")# - CSO-API Documentation';
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
					href="#variables.rootPath_str#index.html?#variables.componentPage_str#&amp;#variables.packagePath_str#class-list.html">
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
				#listLast(variables.componentName_str, ".")#
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

<cfif arrayLen(properties_arr) gt 0 >
	<a name="propertySummary"></a>
	<div class="summarySection">
		<cfinclude template="./includes/dsp_propertySummary.cfm">
	</div>
</cfif>
<cfif publicMethods_bool>
	<a name="methodSummary"></a>
	<div class="summarySection">
		<cfinclude template="./includes/dsp_methodSummary.cfm">
	</div>
</cfif>
<cfif privateMethods_bool>
	<a name="protectedMethodSummary"></a>
	<div class="summarySection">
		<cfinclude template="./includes/dsp_protectedMethodSummary.cfm">
	</div>
</cfif>

<script language="javascript" type="text/javascript"><!--
	showHideInherited();
--></script>

<div class="MainContent">
<a name="methodDetail"></a>
<div class="detailSectionHeader">
	Method Detail
</div>

<a name="getJob()"></a>
<a name="getJob(String,String)"></a>
<table class="detailHeader" cellpadding="0" cellspacing="0">
	<tr>
		<td class="detailHeaderName">
			getJob
		</td>
		<td class="detailHeaderParens">
			()
		</td>
		<td class="detailHeaderType">
			method
		</td>
	</tr>
</table>
<div class="detailBody">
	<code>
		public function getJob(apiKey:String, id:String):
		<a href="../../../../fly/cso/api/v1/data/job/RemoteJob.html">
			RemoteJob
		</a>
	</code>
	<p>
		Returns a completely filled single job
	</p>
	<p>
		<span class="label">
			Parameters
		</span>
		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="20px">
				</td>
				<td>
					<code>
						<span class="label">apiKey</span>:String
					</code>
					&mdash; The API key to identify the user
				</td>
			</tr>
			<tr>
				<td class="paramSpacer">
					&nbsp;
				</td>
			</tr>
			<tr>
				<td width="20px">
				</td>
				<td>
					<code>
						<span class="label">id</span>:String
					</code>
					&mdash; The id of the job
				</td>
			</tr>
		</table>
	</p>
	<p>
		<span class="label">
			Returns
		</span>
		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="20">
				</td>
				<td>
					<code>
						<a href="../../../../fly/cso/api/v1/data/job/RemoteJob.html">
							RemoteJob
						</a>
					</code>
					&mdash; a single job with the given id
				</td>
			</tr>
		</table>
	</p>
	<p>
		<span class="label">
			Throws
		</span>
		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="20">
				</td>
				<td>
					<code>
						fly.cso.api.v1.exception:RemotePermissionDeniedException
					</code>
				</td>
			</tr>
			<tr>
				<td class="paramSpacer">
					&nbsp;
				</td>
			</tr>
			<tr>
				<td width="20">
				</td>
				<td>
					<code>
						fly.cso.api.v1.exception:RemoteInvalidApiKeyException
					</code>
				</td>
			</tr>
			<tr>
				<td class="paramSpacer">
					&nbsp;
				</td>
			</tr>
			<tr>
				<td width="20">
				</td>
				<td>
					<code>
						fly.cso.api.v1.exception:RemoteJobNotFoundException
					</code>
				</td>
			</tr>
		</table>
	</p>
</div>

</div>
</body>
</html><!--<br/>dinsdag juni 29 2010, 05:27 N.M. +02:00  -->