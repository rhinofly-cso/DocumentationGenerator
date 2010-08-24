/**
	Contains the properties and functions to store and access metadata from CF interfaces.
	
	@author Eelco Eggen
	@date 17 August 2010
*/
component displayname="cfc.cfcMetadata.CFInterface" extends="cfc.CFCMetadata" accessors="true" output="false"
{
	property name="implementedBy" type="string" hint="Names of CFCs that implement the interface.";
}