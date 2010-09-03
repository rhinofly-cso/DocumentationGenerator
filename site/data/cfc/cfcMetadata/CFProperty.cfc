/**
	Contains the properties and functions to store and access property metadata from CF components.
	
	@author Eelco Eggen
	@date 17 August 2010
*/
component displayname="cfc.cfcMetadata.CFProperty" extends="fly.Object" accessors="true" output="false"
{
	property name="name" type="string" hint="Name of the property.";
	property name="type" type="string" hint="Variable type of the property.";
	property name="serializable" type="boolean" hint="Indicates whether the property is serializable.";
	property name="hint" type="string" hint="Hint that accompanies the component code.";

	property name="author" type="string" hint="Author of the component.";
	property name="date" type="string" hint="Date on which the component was written.";
	property name="private" type="boolean" hint="Indicates whether the property should be documented.";
	property name="related" type="string" hint="List of link expressions to related documentation pages.";

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