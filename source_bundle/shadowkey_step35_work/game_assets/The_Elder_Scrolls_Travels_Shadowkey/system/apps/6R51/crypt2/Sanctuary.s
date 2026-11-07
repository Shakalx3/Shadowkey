{
	Init[()
	{
		ClearMenu();
		AddStaticItem(676);
		AddStaticItem(179, false);
		AddMenuItem(651, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}