<div class="summaryTableTitle">
	Properties
</div>
<div class="showHideLinks">
	<div id="hideInheritedProperty" class="hideInheritedProperty">
		<a class="showHideLink" 
			href="#propertySummary" 
			onclick="javascript:setInheritedVisible(false,'Property');">
			<img class="showHideLinkImage" src="#variables.rootPath_str#images/expanded.gif">
			Hide Inherited Properties</a>
	</div>
	<div id="showInheritedProperty" class="showInheritedMProperty">
		<a class="showHideLink" 
			href="#propertySummary" 
			onclick="javascript:setInheritedVisible(true,'Property');">
			<img class="showHideLinkImage" src="#variables.rootPath_str#images/collapsed.gif">
			Show Inherited Properties</a>
	</div>
</div>
<table cellspacing="0" cellpadding="3" class="summaryTable " id="summaryTableMethod">
	<tr>
		<th>
			&nbsp;
		</th>
		<th colspan="2">
			Property
		</th>
		<th class="summaryTableOwnerCol">
			Defined By
		</th>
	</tr>
	<cfoutput>#variables.propertySummaryRows_str#</cfoutput>
</table>