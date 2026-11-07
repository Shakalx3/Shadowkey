{
	Init[()
	{
		ClearMenu();
		AddStaticItem(663);
		AddStaticItem(179, false);
		AddMenuItem(651, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}