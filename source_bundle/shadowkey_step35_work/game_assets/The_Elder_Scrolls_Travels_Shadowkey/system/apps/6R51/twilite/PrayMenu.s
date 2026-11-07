{
	Init[()
	{
		AddStaticItem(2711);
		AddStaticItem(2712);
		AddStaticItem(179, false);
		AddMenuItem(182, "More1");
	}]

	More1[()
	{
		ClearMenu();
		AddStaticItem(2713);
		AddStaticItem(2714);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	}]

	More2[()
	{
		ClearMenu();
		AddStaticItem(2715);
		AddStaticItem(2716);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}