<!--- 
	This template requires the metadata object cfcMetadata_obj of the component in the 
	variable scope.
	Also, it requires (a reference to) a library structure libraryRef_struct containing 
	component metadata objects for all components in the library.
 --->
<!doctype html public "-//w3c//dtd HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" />
<html>

<cfset componentName_str = variables.cfcMetadata_obj.getName() />
<cfset componentPage_str = replace(variables.componentName_str, ".", "/") & ".html" />
<cfset packageName_str = listDeleteAt(variables.componentName_str, listLen(variables.componentName_str), ".") />
<cfset packagePath_str = replace(variables.packageName_str, ".", "/") & "/" />
<cfset rootPath_str = repeatString("../", listLen(variables.packageName_str, ".")) />

<cfif isInstanceOf(cfcMetadata_obj, "cfc.cfcMetadata.cfcInterface")>
	<cfset type_str = "Interface" />
<cfelseif isInstanceOf(cfcMetadata_obj, "cfc.cfcMetadata.cfcComponent")>
	<cfset type_str = "Component" />
<cfelse>
	<cfthrow message="Error: unknown component type #cfcMetadata_obj.getClass().getName()#.">
</cfif>

<cfset extends_str = cfcMetadata_obj.getExtends() />
<cfif isNull(variables.extends_str)>
	<cfset extends_str = "" />
</cfif>

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
	
	<script language="javascript" type="text/javascript" xml:space="preserve"><!--
		if (!isEclipse() || window.name != ECLIPSE_FRAME_NAME)
		{
			titleBar_setSubTitle("JobAPI");
			titleBar_setSubNav(false,false,false,false,false,false,false,false,true,false,false,false,false,false,false,false);
		}
	--></script>
	
	<div xmlns:fn="http://www.w3.org/2005/xpath-functions" class="MainContent">
		<table class="classHeaderTable" cellpadding="0" cellspacing="0">
			<tr>
				<td class="classHeaderTableLabel">
					Package
				</td>
				<td>
					<a href="package-detail.html"
						onclick="javascript:loadClassListFrame('class-list.html')">
						#variables.packageName_str#</a>
				</td>
			</tr>
			<cfinclude template="./includes/dsp_inheritance.cfm" />
		</table>
		
		<hr>
	</div>
	
	<a name="methodSummary"></a>
	<div class="summarySection">

	<div class="summaryTableTitle">
		Public Methods
	</div>
	<div class="showHideLinks">
		<div id="hideInheritedMethod" class="hideInheritedMethod">
			<a class="showHideLink" 
				href="#methodSummary" 
				onclick="javascript:setInheritedVisible(false,'Method');">
				<img class="showHideLinkImage" src="../../../../images/expanded.gif">
				Hide Inherited Public Methods
			</a>
		</div>
		<div id="showInheritedMethod" class="showInheritedMethod">
			<a class="showHideLink" 
				href="#methodSummary" 
				onclick="javascript:setInheritedVisible(true,'Method');">
				<img class="showHideLinkImage" src="../../../../images/collapsed.gif">
				Show Inherited Public Methods
			</a>
		</div>
	</div>
	<table cellspacing="0" cellpadding="3" class="summaryTable " id="summaryTableMethod">
		<tr>
			<th>
				&nbsp;
			</th>
			<th colspan="2">
				Method
			</th>
			<th class="summaryTableOwnerCol">
				Defined By
			</th>
		</tr>
		<tr class="hideInheritedMethod">
			<td class="summaryTablePaddingCol">
				&nbsp;
			</td>
			<td class="summaryTableInheritanceCol">
				<img src="../../../../images/inheritedSummary.gif" alt="Inherited" title="Inherited" class="inheritedSummaryImage">
			</td>
			<td class="summaryTableSignatureCol">
				<div class="summarySignature">
					<a href="../../../../fly/cso/api/v1/API.html#getApiKey()"
						class="signatureLink">
						getApiKey
					</a>
					(username:String, password:String):String
				</div>
				<div class="summaryTableDescription">
					Allows a user of the API to retrieve a key.
				</div>
			</td>
			<td class="summaryTableOwnerCol">
				<a href="../../../../fly/cso/api/v1/API.html">
					API
				</a>
			</td>
		</tr>
		<tr class="">
			<td class="summaryTablePaddingCol">
				&nbsp;
			</td>
			<td class="summaryTableInheritanceCol">
				&nbsp;
			</td>
			<td class="summaryTableSignatureCol">
				<div class="summarySignature">
					<a href="#getJob()" class="signatureLink">
						getJob
					</a>
					(apiKey:String, id:String):
					<a href="../../../../fly/cso/api/v1/data/job/RemoteJob.html">
						RemoteJob
					</a>
				</div>
				<div class="summaryTableDescription">
					Returns a completely filled single job
				</div>
			</td>
			<td class="summaryTableOwnerCol">
				JobAPI
			</td>
		</tr>
		<tr class="">
			<td class="summaryTablePaddingCol">
				&nbsp;
			</td>
			<td class="summaryTableInheritanceCol">
				&nbsp;
			</td>
			<td class="summaryTableSignatureCol">
				<div class="summarySignature">
					<a href="#getJobCount()" class="signatureLink">
						getJobCount
					</a>
					(apiKey:String, filter:
					<a href="../../../../fly/cso/api/v1/filter/RemoteJobFilter.html">
						RemoteJobFilter
					</a>
					):Number
				</div>
				<div class="summaryTableDescription">
					Returns the number of jobs for the given filter
				</div>
			</td>
			<td class="summaryTableOwnerCol">
				JobAPI
			</td>
		</tr>
		<tr class="">
			<td class="summaryTablePaddingCol">
				&nbsp;
			</td>
			<td class="summaryTableInheritanceCol">
				&nbsp;
			</td>
			<td class="summaryTableSignatureCol">
				<div class="summarySignature">
					<a href="#getJobEnumerations()" class="signatureLink">
						getJobEnumerations
					</a>
					(apiKey:String):
					<a href="../../../../fly/cso/api/v1/data/job/RemoteJobEnumerations.html">
						RemoteJobEnumerations
					</a>
				</div>
				<div class="summaryTableDescription">
					Can be used to retrieve all used enumerations
				</div>
			</td>
			<td class="summaryTableOwnerCol">
				JobAPI
			</td>
		</tr>
		<tr class="">
			<td class="summaryTablePaddingCol">
				&nbsp;
			</td>
			<td class="summaryTableInheritanceCol">
				&nbsp;
			</td>
			<td class="summaryTableSignatureCol">
				<div class="summarySignature">
					<a href="#getJobs()" class="signatureLink">
						getJobs
					</a>
					(apiKey:String, filter:
					<a href="../../../../fly/cso/api/v1/filter/RemoteJobFilter.html">
						RemoteJobFilter
					</a>
					, fieldSelection:
					<a href="../../../../fly/cso/api/v1/selection/RemoteJobFieldSelection.html">
						RemoteJobFieldSelection
					</a>
					):Vector.&lt;
					<a href="../../../../fly/cso/api/v1/data/job/RemoteJob.html">
						RemoteJob
					</a>
					&gt;
				</div>
				<div class="summaryTableDescription">
					Retrieves a set of jobs based on the given filter.
				</div>
			</td>
			<td class="summaryTableOwnerCol">
				JobAPI
			</td>
		</tr>
		<tr class="">
			<td class="summaryTablePaddingCol">
				&nbsp;
			</td>
			<td class="summaryTableInheritanceCol">
				&nbsp;
			</td>
			<td class="summaryTableSignatureCol">
				<div class="summarySignature">
					<a href="#getOrganisations()" class="signatureLink">
						getOrganisations
					</a>
					(apiKey:String, filter:
					<a href="../../../../fly/cso/api/v1/filter/RemoteOrganisationFilter.html">
						RemoteOrganisationFilter
					</a>
					):Vector.&lt;
					<a href="../../../../fly/cso/api/v1/data/organisation/RemoteOrganisation.html">
						RemoteOrganisation
					</a>
					&gt;
				</div>
				<div class="summaryTableDescription">
					Can be used to retrieve all organisations
				</div>
			</td>
			<td class="summaryTableOwnerCol">
				JobAPI
			</td>
		</tr>
		<tr class="hideInheritedMethod">
			<td class="summaryTablePaddingCol">
				&nbsp;
			</td>
			<td class="summaryTableInheritanceCol">
				<img src="../../../../images/inheritedSummary.gif" alt="Inherited" title="Inherited" class="inheritedSummaryImage">
			</td>
			<td class="summaryTableSignatureCol">
				<div class="summarySignature">
					<a href="../../../../fly/cso/api/v1/API.html#isValidApiKey()" class="signatureLink">
						isValidApiKey
					</a>
					(apiKey:String):Boolean
				</div>
				<div class="summaryTableDescription">
					Can be used to determine if an API key is still valid.
				</div>
			</td>
			<td class="summaryTableOwnerCol">
				<a href="../../../../fly/cso/api/v1/API.html">
					API
				</a>
			</td>
		</tr>
		<tr class="">
			<td class="summaryTablePaddingCol">
				&nbsp;
			</td>
			<td class="summaryTableInheritanceCol">
				&nbsp;
			</td>
			<td class="summaryTableSignatureCol">
				<div class="summarySignature">
					<a href="#removeJob()" class="signatureLink">
						removeJob
					</a>
					(apiKey:String, id:String):
					<a href="../../../../fly/cso/api/v1/data/job/RemoteJob.html">
						RemoteJob
					</a>
				</div>
				<div class="summaryTableDescription">
					Removes a job with the given id.
				</div>
			</td>
			<td class="summaryTableOwnerCol">
				JobAPI
			</td>
		</tr>
		<tr class="">
			<td class="summaryTablePaddingCol">
				&nbsp;
			</td>
			<td class="summaryTableInheritanceCol">
				&nbsp;
			</td>
			<td class="summaryTableSignatureCol">
				<div class="summarySignature">
					<a href="#saveJob()" class="signatureLink">
						saveJob
					</a>
					(apiKey:String, job:
					<a href="../../../../fly/cso/api/v1/data/job/RemoteJob.html">
						RemoteJob
					</a>
					):
					<a href="../../../../fly/cso/api/v1/data/job/RemoteJob.html">
						RemoteJob
					</a>
				</div>
				<div class="summaryTableDescription">
					Saves the given job.
				</div>
			</td>
			<td class="summaryTableOwnerCol">
				JobAPI
			</td>
		</tr>
	</table>
	</div>
	
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
</cfoutput>
</html><!--<br/>dinsdag juni 29 2010, 05:27 N.M. +02:00  -->