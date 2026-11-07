{
	Init[()
	{
		ClearMenu();
		AddStaticItem(407 );
		AddStaticItem(408 );
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	} ]

	MenuQuit[()
	{
		Quit();
	}]
}