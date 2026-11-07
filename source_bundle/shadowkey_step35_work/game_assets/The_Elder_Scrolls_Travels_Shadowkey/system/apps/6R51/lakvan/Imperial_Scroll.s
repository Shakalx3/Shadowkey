{
	Init[()
	{
		ClearMenu();
		AddStaticItem(1822);
		AddStaticItem(179, false);
		AddMenuItem(182, "Imperial");
	}]

	Imperial[()
	{
		ClearMenu();
		AddStaticItem(1823);
		AddStaticItem(179, false);
		AddMenuItem(1824, "TharnScroll");
		GetPlayer().SetQuestSolved(27);
		GetPlayer().SetQuestSolved(29);
	}]

	TharnScroll[()
	{
		ClearMenu();
		OpenMenu("lakvan\\\\Tharn_Scroll");
	}]
}