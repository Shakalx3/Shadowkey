{
	Init[()
	{
		ClearMenu();
		AddStaticItem(654);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}