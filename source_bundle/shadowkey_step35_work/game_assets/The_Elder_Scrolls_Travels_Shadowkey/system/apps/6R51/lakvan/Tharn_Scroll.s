{
	Init[()
	{
		ClearMenu();
		AddStaticItem(1872);
		AddStaticItem(1873);
		AddStaticItem(179, false);
		AddMenuItem(182, "TharnScroll1");
	}]

	TharnScroll1[()
	{
		ClearMenu();
		AddStaticItem(1874);
		AddStaticItem(1875);
		AddStaticItem(1876);
		AddStaticItem(179, false);
		AddMenuItem(182, "TharnScroll2");
	}]

	TharnScroll2[()
	{
		ClearMenu();
		AddStaticItem(1877);
		AddStaticItem(1878);
		AddStaticItem(179, false);
		AddMenuItem(182, "TharnScroll3");
	}]

	TharnScroll3[()
	{
		ClearMenu();
		AddStaticItem(1879);
		AddStaticItem(1880);
		AddStaticItem(179, false);
		AddMenuItem(182, "TharnScroll4");
	}]

	TharnScroll4[()
	{
		ClearMenu();
		AddStaticItem(1881);
		AddStaticItem(1882);
		AddStaticItem(1883);
		AddStaticItem(179, false);
		AddMenuItem(1884, "MenuQuit");
		GetPlayer().SetQuestSolved(28);
	}]

	MenuQuit[()
	{
		Quit();
	}]
}