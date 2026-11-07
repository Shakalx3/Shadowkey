{
	Init[()
	{
		AddStaticItem(700);
		AddStaticItem(179, false);
		AddMenuItem(182, "More1");
	}]
	More1[()
	{
		ClearMenu();
		AddStaticItem(701);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	}]
	More2[()
	{
		ClearMenu();
		AddStaticItem(702);
		AddStaticItem(179, false);
		AddMenuItem(182, "More3");
	}]
	More3[()
	{
		ClearMenu();
		AddStaticItem(703);
		AddStaticItem(179, false);
		AddMenuItem(182, "More4");
	}]
	More4[()
	{
		ClearMenu();
		AddStaticItem(704);
		AddStaticItem(179, false);
		AddMenuItem(705, "MenuQuit");
	}]
	MenuQuit[()
	{
		Quit();
	}]
}