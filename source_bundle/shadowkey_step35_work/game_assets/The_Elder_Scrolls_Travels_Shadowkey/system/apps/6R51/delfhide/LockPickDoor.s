{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem(2986);
		AddMenuItem(386,"MenuQuit");
		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);
	} ]

	MenuQuit[ (s)
	{
		Quit();
	}]
}