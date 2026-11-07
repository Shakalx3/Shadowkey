{
	Init[()
	{
		ClearMenu();
		AddStaticItem(688);
		AddStaticItem(179, false);
		AddMenuItem(651, "MenuQuit");
	}]

	MenuQuit[()
	{
		GetPlayer().AddEffect(Permanent, Will, Increment, 5);
		Quit();
	}]
}