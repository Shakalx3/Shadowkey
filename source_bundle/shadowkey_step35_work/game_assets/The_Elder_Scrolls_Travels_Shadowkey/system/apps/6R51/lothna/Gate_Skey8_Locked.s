{
	Init[()
	{
		ClearMenu();
		AddStaticItem(3693);
		AddStaticItem(179, false);
		AddMenuItem(517, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}
