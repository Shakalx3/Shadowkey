{
	Init[()
	{
		ClearMenu();
		AddStaticItem(453);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		GetPlayer().SetGold( GetPlayer().GetGold() + 300 );
		GetPlayer().SetQuestSolved(46);
		GetOpener().Chest = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}