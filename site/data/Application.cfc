<cfscript>
component
{
	this.name = "DocumentationGenerator";
	_init();
	
	private void function _init()
	{
		var i = 0;
		var sourcePaths_str = "";
		var reExcludedFolders_str = "^\."; // by default, folder names starting with "." are skipped
		var path_str = "";
		var excludedPaths_str = "";
		var settings_xml = xmlParse("settings.xml").base.settings;
		
		if (structKeyExists(xmlParse("settings.xml").base, "settings"))
		{
			if (structKeyExists(xmlParse("settings.xml").base.settings, "sourcePath"))
			{
				for (i = 1; i <= arrayLen(settings_xml.sourcePath); i++)
				{
					sourcePaths_str = listAppend(sourcePaths_str, settings_xml.sourcePath[i].xmlText);
				}
				this.customTagPaths = sourcePaths_str;
				application["sourcePaths"] = reReplace(sourcePaths_str, "[/\\]+", "/", "all");
			}
			else
			{
				throw(message="Error: please specify one or more source paths in settings.xml, using the tag &lt;sourcePath&gt;.");
			}

			if (structKeyExists(xmlParse("settings.xml").base.settings, "documentDestination"))
			{
				application["documentRoot"] = reReplace(settings_xml.documentDestination.xmlText, "[/\\]+", "/", "all");
			}
			else
			{
				throw(message="Error: please specify the destination for the documentation in settings.xml, using the tag &lt;documentDestination&gt;.");
			}

			if (structKeyExists(xmlParse("settings.xml").base.settings, "reExcludedFolder"))
			{
				for (i = 1; i <= arrayLen(settings_xml.reExcludedFolder); i++)
				{
					reExcludedFolders_str = listAppend(reExcludedFolders_str, settings_xml.reExcludedFolder[i].xmlText, "|");
				}
			}
			application["reExcludedFolders"] = reExcludedFolders_str;
			
			if (structKeyExists(xmlParse("settings.xml").base.settings, "excludedPath"))
			{
				for (i = 1; i <= arrayLen(settings_xml.excludedPath); i++)
				{
					path_str = settings_xml.excludedPath[i].xmlText;
					while (findOneOf("/\", right(path_str, 1)))
					{
						path_str = removeChars(path_str, len(path_str), 1);
					}
					excludedPaths_str = listAppend(excludedPaths_str, path_str);
				}
			}
			application["excludedPaths"] = reReplace(excludedPaths_str, "[/\\]+", "/", "all");
		}
		else
		{
			throw(message="Error: please specify the settings for the application in settings.xml, using the tag &lt;settings&gt;.")
		}
	}
}
</cfscript>