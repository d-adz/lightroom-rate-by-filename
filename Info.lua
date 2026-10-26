return {
	LrSdkVersion = 6.0,
	LrSdkMinimumVersion = 6.0,

	LrToolkitIdentifier = 'com.photodig.ratebyfilename',
	LrPluginName = 'Rate by Filename',

	-- Shows up under Library > Plug-in Extras
	LrLibraryMenuItems = {
		{
			title = 'Rate Photos from Filename List...',
			file = 'RateByFilename.lua',
		},
	},

	VERSION = { major = 1, minor = 0, revision = 0 },
}
