component
{
	this.name = "DocumentationGenerator";
	
	this.customTagPaths = "C:\development\libraries\RhinoflyLibrary\src,C:\development\libraries\TICC2Library\src";
	
	public void function onRequestStart(string target)
	{
		application["customTagPaths"] = this.customTagPaths;
	}
	
}