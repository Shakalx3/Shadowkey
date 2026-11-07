{
	Init[()
	{
		ClearMenu();
		AddStaticItem(3664);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 4701 );
		GetPlayer().PickupItem( Item );
		Item = Level.CreateEntity( 4707 );
		GetPlayer().PickupItem( Item );
		Item = Level.CreateEntity( 4706 );
		GetPlayer().PickupItem( Item );
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}