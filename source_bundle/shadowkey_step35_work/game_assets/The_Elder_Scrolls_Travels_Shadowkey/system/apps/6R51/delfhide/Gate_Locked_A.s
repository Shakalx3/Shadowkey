{
	Init[()
	{
		ClearMenu();
		AddStaticItem(3097);
		AddStaticItem(179, false);
		AddMenuItem(517, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}
