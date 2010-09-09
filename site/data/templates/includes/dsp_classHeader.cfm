<!--- 
	Creates rows for the component-details table including the package, and 
	component/interface name. The following variables are defined in the variables scope in 
	componentDetail.cfm: componentName_str, componentPage_str, packageName_str, 
	packagePath_str, rootPath_str, and type_str
 --->
<cfset extends_str = cfMetadata_obj.getExtends() />
<cfif isNull(variables.extends_str)>
	<cfset extends_str = "" />
</cfif>
<cfset extendedBy_str = cfMetadata_obj.getExtendedBy() />
<cfif isNull(variables.extendedBy_str)>
	<cfset extendedBy_str = "" />
</cfif>

<cfif variables.type_str eq "Component">
	<cfset implements_str = cfMetadata_obj.getImplements() />
	<cfif isNull(variables.implements_str)>
		<cfset implements_str = "" />
	</cfif>
</cfif>
<cfif variables.type_str eq "Interface">
	<cfset implementedBy_str = cfMetadata_obj.getImplementedBy() />
	<cfif isNull(variables.implementedBy_str)>
		<cfset implementedBy_str = "" />
	</cfif>
</cfif>

<cfset extendsLinks_str = "" />

<!--- append the component description with inheritance info for interfaces --->
<cfif variables.type_str eq "Interface" and listLen(variables.extends_str) gt 0>
	<cfset started_bool = false />
	<cfset extendsLinks_str = " extends " />
	<cfloop list="#variables.extends_str#" index="parent_str">
		<cfif variables.started_bool>
			<cfset extendsLinks_str &= ", " />
		<cfelse>
			<cfset started_bool = true>
		</cfif>
		<cfset extendsLinks_str &= variables.builder_obj.convertToLink(parent_str, variables.libraryRef_struct, variables.rootPath_str, true) />
	</cfloop>
</cfif>

<table class="classHeaderTable" cellpadding="0" cellspacing="0">
	<cfoutput>
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
		<tr>
			<td class="classHeaderTableLabel">
				#variables.type_str#
			</td>
			<td class="classSignature">
				#listLast(variables.componentName_str, ".") & variables.extendsLinks_str#
			</td>
		</tr>
	</cfoutput>
	
	<!--- display inheritance info for components --->
	<cfif variables.type_str eq "Component" and len(variables.extends_str) gt 0>
		<cfset inheritance_str = listLast(componentName_str, ".") />
		<cfset parent_str = variables.extends_str />
		<cfloop condition="true">
			<cfset inheritance_str &= " <img src=""" />
			<cfset inheritance_str &= variables.rootPath_str />
			<cfset inheritance_str &= "images/inherit-arrow.gif"" title=""Inheritance"" alt=""Inheritance"" class=""inheritArrow""> " />
			<cfset inheritance_str &= variables.builder_obj.convertToLink(variables.parent_str, variables.libraryRef_struct, variables.rootPath_str, true) />
	
			<!--- break the loop if either the ancestor is not present in the library --->
			<cfif structKeyExists(variables.libraryRef_struct, parent_str)>
				<cfset parent_str = variables.libraryRef_struct[parent_str].getExtends() />
				<!--- if for some reason, the ancestor doesn't extend anything, we break the loop --->
				<cfif isNull(variables.parent_str)>
					<cfbreak />
				</cfif>
			<cfelse>
				<cfbreak />
			</cfif>
		</cfloop>
	
		<tr>
			<td class="classHeaderTableLabel">
				Inheritance
			</td>
			<td class="inheritanceList">
				<cfoutput>
					#inheritance_str#
				</cfoutput>	
			</td>
		</tr>
	</cfif>
		
	<cfif variables.type_str eq "Component" and len(variables.implements_str) gt 0>
		<cfset started_bool = false />
		<cfset implements_str = "" />
		<cfloop list="#variables.implements_str#" index="interface_str">
			<cfif variables.started_bool>
				<cfset implements_str &= ", " />
			<cfelse>
				<cfset started_bool = true>
			</cfif>
			<cfset implements_str &= variables.builder_obj.convertToLink(interface_str, variables.libraryRef_struct, variables.rootPath_str, true) />
		</cfloop>
		
		<tr>
			<td class="classHeaderTableLabel">
				Implements
			</td>
			<td>
				<cfoutput>
					#implements_str#
				</cfoutput>
			</td>
		</tr>
	</cfif>
	
	<cfif variables.type_str eq "Interface" and len(variables.implementedBy_str) gt 0>
		<cfset started_bool = false />
		<cfset implementorsLinks_str = "" />
		<cfloop list="#variables.implementedBy_str#" index="component_str">
			<cfif variables.started_bool>
				<cfset implementorsLinks_str &= ", " />
			<cfelse>
				<cfset started_bool = true>
			</cfif>
			<cfset implementorsLinks_str &= variables.builder_obj.convertToLink(component_str, variables.libraryRef_struct, variables.rootPath_str, true) />
		</cfloop>
		
		<tr>
			<td class="classHeaderTableLabel">
				Implementors
			</td>
			<td>
				<cfoutput>
					#implementorsLinks_str#
				</cfoutput>
			</td>
		</tr>
	</cfif>
	
	<cfif listLen(variables.extendedBy_str) gt 0>
		<cfset started_bool = false />
		<cfset subclassesLinks_str = "" />
		<cfloop list="#variables.extendedBy_str#" index="child_str">
			<cfif variables.started_bool>
				<cfset subclassesLinks_str &= ", " />
			<cfelse>
				<cfset started_bool = true>
			</cfif>
			<cfset subclassesLinks_str &= variables.builder_obj.convertToLink(child_str, variables.libraryRef_struct, variables.rootPath_str, true) />
		</cfloop>
		
		<tr>
			<td class="classHeaderTableLabel">
				Subclasses
			</td>
			<td>
				<cfoutput>
					#variables.subclassesLinks_str#
				</cfoutput>
			</td>
		</tr>
	</cfif>
</table>

<cfif not isNull(variables.author_str)>
	<table cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td style="white-space:nowrap" valign="top">
				<b>Author:&nbsp;</b>
			</td>
			<td>
				<cfoutput>
					#variables.author_str#
				</cfoutput>
			</td>
		</tr>
	</table>
</cfif>
<cfif not isNull(variables.date_str)>
	<table cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td style="white-space:nowrap" valign="top">
				<b>Date:&nbsp;</b>
			</td>
			<td>
				<cfoutput>
					#variables.date_str#
				</cfoutput>
			</td>
		</tr>
	</table>
</cfif>
<cfif not isNull(variables.hint_str)>
	<cfif len(variables.hint_str) gt 0>
		<p>
			<cfoutput>
				#variables.hint_str#
			</cfoutput>
		</p>
	</cfif>
</cfif>
<cfif not isNull(variables.related_str)>
	<cfset started_bool = false />
	<cfset relatedLinks_str = "" />
	<cfloop list="#variables.related_str#" index="component_str">
		<cfif variables.started_bool>
			<cfset relatedLinks_str &= ", " />
		<cfelse>
			<cfset started_bool = true>
		</cfif>
		<cfset relatedLinks_str &= variables.builder_obj.convertToLink(trim(component_str), variables.libraryRef_struct, variables.rootPath_str, true) />
	</cfloop>
	<p>
		<span class="classHeaderTableLabel">See also</span>
	</p>
	<cfoutput>
		<div class="seeAlso">#relatedLinks_str#</div>
	</cfoutput>
</cfif>