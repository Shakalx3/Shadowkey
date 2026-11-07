{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem(3950,false);
		AddStaticItem(GetNextLevelName(),false);
		AddMenuItem(1389, "DontGo");
		AddMenuItem(1375, "Go");

		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	} ]

	Go[ (s)
	{
		Quit();
		Level.ActuallyLoadLevel( Level.GetNextLevel(), Level.GetNextLevelX(), Level.GetNextLevelY() );
	} ]

	DontGo[ (s)
	{
		Level.RestoreSaveLevel();
		Quit();
	} ]

	LevelConfirmBack[ (s)
	{
		DontGo();
	} ]
}