{
	Init[()
	{
		ClearMenu();
		AddStaticItem(650);
		AddStaticItem(179, false);
		AddMenuItem(651, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}