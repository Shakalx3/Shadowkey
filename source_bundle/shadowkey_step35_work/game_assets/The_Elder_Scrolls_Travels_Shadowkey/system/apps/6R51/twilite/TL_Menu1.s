{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2722);
		AddStaticItem(2723);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
	}]

	More[()
	{
		ClearMenu();
		AddStaticItem(2724);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}