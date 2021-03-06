/**
	Contains the properties and functions to store and access metadata from CF components.
	
	@author Eelco Eggen
	@date 17 August 2010
*/
component displayname="cfc.cfcData.CFComponent" extends="cfc.cfcData.CFC" accessors="true" output="false" serializable="true"
{
	/**
		Name of the interface that is implemented by the component.
		@see cfc.cfcData.CFInterface
	*/
	property name="implements" type="array";
	property name="serializable" type="boolean" hint="Indicates whether the component is serializable.";
	property name="properties" type="array" hint="
		Metadata concerning properties of the component. 
		@see cfc.cfcData.CFProperty
	";
}