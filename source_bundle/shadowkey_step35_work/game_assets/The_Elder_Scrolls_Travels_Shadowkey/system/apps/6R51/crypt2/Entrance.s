{
	Init[()
	{
		ClearMenu();
		AddStaticItem(652);
		AddStaticItem(179, false);
		AddMenuItem(651, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}