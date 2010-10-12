<cfscript>
component
{
	this.name = "DocumentationGenerator";
	variables._settings_struct = structNew();
	
	_init();
	this.customTagPaths = variables._settings_struct.sourcePaths;
	
	private void function _init()
	{
		var i = 0;
		var sourcePathList_str = "";
		var reExcludeFolders_str = "^\."; // by default, folder names starting with "." are skipped
		var path_str = "";
		var excludePathList_str = "";
		var excludeComponentList_str = "";
		var settings_xml = xmlParse("settings.xml").base.settings;
		
		if (structKeyExists(xmlParse("settings.xml").base, "settings"))
		{
			if (structKeyExists(xmlParse("settings.xml").base.settings, "sourcePath"))
			{
				for (i = 1; i <= arrayLen(settings_xml.sourcePath); i++)
				{
					sourcePathList_str = listAppend(sourcePathList_str, settings_xml.sourcePath[i].xmlText);
				}
				this.customTagPaths = sourcePathList_str;
				variables._settings_struct["sourcePaths"] = reReplace(sourcePathList_str, "[/\\]+", "/", "all");
			}
			else
			{
				throw(message="Error: please specify one or more source paths in settings.xml, using the tag &lt;sourcePath&gt;.");
			}

			if (structKeyExists(xmlParse("settings.xml").base.settings, "documentDestination"))
			{
				variables._settings_struct["documentRoot"] = reReplace(settings_xml.documentDestination.xmlText, "[/\\]+", "/", "all");
			}
			else
			{
				throw(message="Error: please specify the destination for the documentation in settings.xml, using the tag &lt;documentDestination&gt;.");
			}

			if (structKeyExists(xmlParse("settings.xml").base.settings, "reExcludeFolder"))
			{
				for (i = 1; i <= arrayLen(settings_xml.reExcludedFolder); i++)
				{
					reExcludeFolders_str = listAppend(reExcludeFolders_str, settings_xml.reExcludeFolder[i].xmlText, "|");
				}
			}
			variables._settings_struct["reExcludeFolders"] = reExcludeFolders_str;
			
			if (structKeyExists(xmlParse("settings.xml").base.settings, "excludePath"))
			{
				for (i = 1; i <= arrayLen(settings_xml.excludePath); i++)
				{
					path_str = settings_xml.excludePath[i].xmlText;
					while (findOneOf("/\", right(path_str, 1)))
					{
						path_str = removeChars(path_str, len(path_str), 1);
					}
					excludePathList_str = listAppend(excludePathList_str, path_str);
				}
			}
			variables._settings_struct["excludePaths"] = reReplace(excludePathList_str, "[/\\]+", "/", "all");
			
			if (structKeyExists(xmlParse("settings.xml").base.settings, "excludeComponent"))
			{
				for (i = 1; i <= arrayLen(settings_xml.excludeComponent); i++)
				{
					excludeComponentList_str = listAppend(excludeComponentList_str, settings_xml.excludeComponent[i].xmlText);
				}
			}
			variables._settings_struct["excludeComponents"] = excludeComponentList_str;
		}
		else
		{
			throw(message="Error: please specify the settings for the application in settings.xml, using the tag &lt;settings&gt;.")
		}
	}
	
	public void function onRequestStart(string target)
	{
		var i = 0;
		var settingsList_str = structKeyList(variables._settings_struct);
		
		for (i = 1; i <= listLen(settingsList_str); i++)
		{
			application[listGetAt(settingsList_str, i)] = variables._settings_struct[listGetAt(settingsList_str, i)];
		}
		
		if (application.sourcePaths neq this.customTagPaths)
		{
			applicationStop();
			location("./");
		}
	}
}
</cfscript>