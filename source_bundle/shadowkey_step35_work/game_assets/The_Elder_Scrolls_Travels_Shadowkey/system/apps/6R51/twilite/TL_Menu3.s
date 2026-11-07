{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2727);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
	}]

	More[()
	{
		ClearMenu();
		AddStaticItem(2728);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}