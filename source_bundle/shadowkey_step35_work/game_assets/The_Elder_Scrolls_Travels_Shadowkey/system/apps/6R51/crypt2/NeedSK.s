{
	Init[()
	{
		ClearMenu();
		AddStaticItem(661);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}