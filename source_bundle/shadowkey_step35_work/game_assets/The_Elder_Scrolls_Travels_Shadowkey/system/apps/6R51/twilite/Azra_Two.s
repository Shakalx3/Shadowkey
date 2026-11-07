{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2591);
		AddStaticItem(179, false);
		AddMenuItem(182, "More1");
	}]

	More1[()
	{
		ClearMenu();
		AddStaticItem(2592);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	}]

	More2[()
	{
		ClearMenu();
		AddStaticItem(2593);
		AddStaticItem(2594);
		AddStaticItem(179, false);
		AddMenuItem(182, "More3");
	}]

	More3[()
	{
		ClearMenu();
		AddStaticItem(2595);
		AddStaticItem(179, false);
		AddMenuItem(182, "More4");
	}]

	More4[()
	{
		ClearMenu();
		AddStaticItem(2596);
		AddStaticItem(179, false);
		AddMenuItem(517, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}