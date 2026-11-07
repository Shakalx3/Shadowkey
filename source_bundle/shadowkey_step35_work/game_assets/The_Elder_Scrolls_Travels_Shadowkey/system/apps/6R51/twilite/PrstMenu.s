{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2717);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
	}]

	More[()
	{
		ClearMenu();
		AddStaticItem(2718);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}