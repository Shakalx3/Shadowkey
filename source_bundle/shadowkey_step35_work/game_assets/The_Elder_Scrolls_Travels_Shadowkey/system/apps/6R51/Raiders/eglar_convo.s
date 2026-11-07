{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2184);
		AddStaticItem(179,false);
		AddMenuItem(182, "More");
	}]

	More[()
	{
		ClearMenu();
		AddStaticItem(2185);
		AddStaticItem(2186);
		AddStaticItem(179, false);
		AddMenuItem(783, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}