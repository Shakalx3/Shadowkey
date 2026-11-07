{
	Init[()
	{
		ClearMenu();
		AddStaticItem(3098);
		AddStaticItem(179, false);
		AddMenuItem(517, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}
