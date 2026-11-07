{
	Init[()
	{
		ClearMenu();
		AddStaticItem(662);
		AddStaticItem(179, false);
		AddMenuItem(651, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}