/**
	Contains the properties and functions to store and access metadata from different parts of 
	CF metadata structures. This acts as a basis for other metadata objects.
	
	@author Eelco Eggen
	@date 17 August 2010
*/
component displayname="cfc.cfcData.CFMetadata" accessors="true" output="false" serializable="true"
{
	property name="name" type="string" hint="Display name of the thing associated with the metadata.";
	property name="hint" type="string" hint="Hint that accompanies the component code.";

	/**
		Returns the first sentence from the hint property.
	*/
	public string function getShortHint()
	{
		var end_num = 0;
		var hint_str = this.getHint();
		
		if (isNull(hint_str))
		{
			return "";
		}
		else
		{
			end_num = reFind("\.(<br[\s/]*>|\s+[A-Z])", hint_str);
			if (end_num > 0)
			{
				hint_str = left(hint_str, end_num);
			}
			return hint_str;
		}
	}
}