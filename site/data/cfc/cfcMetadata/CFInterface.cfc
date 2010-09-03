/**
	Contains the properties and functions to store and access metadata from CF interfaces.
	
	@author Eelco Eggen
	@date 17 August 2010
*/
component displayname="cfc.cfcMetadata.CFInterface" extends="cfc.CFCMetadata" accessors="true" output="false"
{
	property name="implementedBy" type="string" hint="List of CFCs that implement the interface.";

	public void function addImplementedBy(required string componentName)
	{
		var implementedBy_str = this.getImplementedBy();
		
		if (isNull(implementedBy_str))
		{
			implementedBy_str = "";
		}
		implementedBy_str = listAppend(implementedBy_str, arguments.componentName);
		this.setImplementedBy(implementedBy_str);
	}
}