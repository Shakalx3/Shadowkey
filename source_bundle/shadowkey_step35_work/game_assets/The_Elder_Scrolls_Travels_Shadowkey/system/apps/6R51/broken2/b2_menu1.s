{
	Init[()
	{
		ClearMenu();
		AddStaticItem(500);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	} ]

	MenuQuit[()
	{
		Quit();
	}]
}