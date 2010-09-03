<!--- 
	Creates rows for the component-details table including the component/interface name. The 
	following variables are defined in the variables scope in componentDetail.cfm: 
	componentName_str, componentPage_str, packageName_str, packagePath_str, rootPath_str, and 
	type_str
 --->
<cfset extends_str = cfcMetadata_obj.getExtends() />
<cfif isNull(variables.extends_str)>
	<cfset extends_str = "" />
</cfif>
<cfset extendedBy_str = cfcMetadata_obj.getExtendedBy() />
<cfif isNull(variables.extendedBy_str)>
	<cfset extendedBy_str = "" />
</cfif>
<cfset implements_str = cfcMetadata_obj.getImplements() />
<cfif isNull(variables.implements_str)>
	<cfset implements_str = "" />
</cfif>
<cfset implementedBy_str = cfcMetadata_obj.getImplementedBy() />
<cfif isNull(variables.implementedBy_str)>
	<cfset implementedBy_str = "" />
</cfif>

<cfset extendsLinks_str = "" />

<!--- append the component description with inheritance info for interfaces --->
<cfif variables.type_str eq "Interface" and listLen(variables.extends_str) gt 0>
	<cfset started_bool = false />
	<cfset extendsLinks_str = " extends " />
	<cfloop list="variables.extends_str" index="parent_str">
		<cfif variables.started_bool>
			<cfset extendsLinks_str &= ", " />
		<cfelse>
			<cfset started_bool = true>
		</cfif>
		<cfset extendsLinks_str &= variables.builder_obj.convertToLink(parent_str, variables.libraryRef_struct, variables.rootPath_str, true) />
	</cfloop>
</cfif>

<tr>
	<td class="classHeaderTableLabel">
		#variables.type_str#
	</td>
	<td class="classSignature">
		#listLast(variables.componentName_str, ".") & variables.extendsLinks_str#
	</td>
</tr>

<!--- display inheritance info for components --->
<cfif variables.type_str eq "Component" and len(variables.extends_str) gt 0>
	<cfset inheritance_str = componentName_str />
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
			#inheritance_str#
		</td>
	</tr>
</cfif>

			<tr>
				<td class="classHeaderTableLabel">
					Subclasses
				</td>
				<td> 
					<a href="../../../../../../fly/cso/api/v1/data/cv/RemoteCourse.html">
						RemoteCourse
					</a>,  
					<a href="../../../../../../fly/cso/api/v1/data/cv/RemoteEducation.html">
						RemoteEducation
					</a>
				</td>
			</tr>
