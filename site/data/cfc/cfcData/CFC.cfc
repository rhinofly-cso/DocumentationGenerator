/**
	Contains the properties and functions to store and access metadata from CFCs.
	
	@author Eelco Eggen
	@date 17 August 2010
*/
component displayname="cfc.cfcData.CFC" extends="cfc.cfcData.CFMetadata" accessors="true" output="false" serializable="true"
{
	property name="extends" type="array" hint="Name of the CFC that is extended by the component, or multiple in case of an interface.";
	property name="extendedBy" type="array" hint="Names of CFCs that extend the component.";
	property name="functions" type="array" hint="Metadata concerning methods of the component.";

	property name="author" type="string" hint="Author of the component.";
	property name="date" type="string" hint="Date on which the component was written.";
	property name="private" type="boolean" hint="Indicates whether the component should be documented.";
	property name="related" type="string" hint="List of link expressions to related documentation pages.";

	public void function addExtendedBy(required string componentName)
	{
		var extendedBy_arr = this.getExtendedBy();
		var componentName_str = arguments.componentName;
		
		if (isNull(extendedBy_arr))
		{
			extendedBy_arr = [componentName_str];
		} else
		{
			arrayAppend(extendedBy_arr, componentName_str);
		}
		this.setExtendedBy(extendedBy_arr);
	}

	public void function addRelated(required string link)
	{
		var related_str = this.getRelated();
		
		if (isNull(related_str))
		{
			related_str = "";
		}
		related_str = listAppend(related_str, arguments.link);
		this.setRelated(related_str);
	}
}