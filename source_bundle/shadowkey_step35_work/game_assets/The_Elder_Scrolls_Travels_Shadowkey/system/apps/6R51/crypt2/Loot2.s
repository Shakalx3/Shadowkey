{
	Init[()
	{
		ClearMenu();
		AddStaticItem(658);
		AddStaticItem(179, false);
		AddMenuItem(656, "Susten");
		AddMenuItem(657, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]

	Susten[()
	{
		Item = Level.CreateEntity( 4039 );
		GetPlayer().PickupItem( Item );
		GetOpener().susten = 1;
		Quit();
	}]
}