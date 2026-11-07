{
	Init[()
	{
		ClearMenu();
		AddStaticItem(409 );
		AddStaticItem(410 );
		AddStaticItem(411 );
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	} ]

	MenuQuit[()
	{
		Quit();
	}]
}