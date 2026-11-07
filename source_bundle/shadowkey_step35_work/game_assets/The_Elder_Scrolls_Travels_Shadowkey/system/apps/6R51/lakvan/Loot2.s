{
	Init[()
	{
		ClearMenu();
		AddStaticItem(1834);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 705 );
		GetPlayer().PickupItem( Item );

		Item = Level.CreateEntity( 705 );
		GetPlayer().PickupItem( Item );

		Item = Level.CreateEntity( 4736 );
		GetPlayer().PickupItem( Item );

		Item = Level.CreateEntity( 4736 );
		GetPlayer().PickupItem( Item );

		GetOpener().Loot2 = 1;
		GetOpener().SetUsable(false);

		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}