{
	Init[()
	{
		ClearMenu();
		AddStaticItem(660);
		AddStaticItem(179, false);
		AddMenuItem(656, "Wrath");
		AddMenuItem(657, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]

	Wrath[()
	{
		Item = Level.CreateEntity( 4038 );
		GetPlayer().PickupItem( Item );
		GetOpener().wrath = 1;
		Quit();
	}]
}