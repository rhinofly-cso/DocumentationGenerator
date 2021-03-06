/**
	Contains the properties and functions to store and access metadata from CF interfaces.
	
	@author Eelco Eggen
	@date 17 August 2010
*/
component displayname="cfc.cfcData.CFInterface" extends="cfc.cfcData.CFC" accessors="true" output="false" serializable="true"
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