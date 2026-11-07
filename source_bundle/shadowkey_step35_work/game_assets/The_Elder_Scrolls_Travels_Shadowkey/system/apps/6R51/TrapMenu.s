{
	Init[()
	{
		AddStaticItem(2025);
		AddStaticItem(179, false);
		//AddMenuItem(517, "MenuBack");
		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	}]

	TrapMenuBack[ ()
	{
		Quit();
	}]
}