{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2584);
		AddStaticItem(179, false);
		AddMenuItem(182, "More1");
	}]

	More1[()
	{
		ClearMenu();
		AddStaticItem(2585);
		AddStaticItem(2586);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	}]

	More2[()
	{
		ClearMenu();
		AddStaticItem(2587);
		AddStaticItem(179, false);
		AddMenuItem(182, "More3");
	}]

	More3[()
	{
		ClearMenu();
		AddStaticItem(2588);
		AddStaticItem(179, false);
		AddMenuItem(182, "More4");
	}]

	More4[()
	{
		ClearMenu();
		AddStaticItem(2589);
		AddStaticItem(2590);
		AddStaticItem(179, false);
		AddMenuItem(517, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}