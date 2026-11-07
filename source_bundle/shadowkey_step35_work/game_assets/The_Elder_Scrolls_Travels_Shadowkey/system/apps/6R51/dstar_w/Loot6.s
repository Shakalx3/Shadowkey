{
	Init[()
	{
		ClearMenu();
		AddStaticItem(1161);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 725 );
		GetPlayer().PickupItem( Item );
		GetOpener().Loot6 = 1;
		GetPlayer().SetQuestSolved(38);
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}