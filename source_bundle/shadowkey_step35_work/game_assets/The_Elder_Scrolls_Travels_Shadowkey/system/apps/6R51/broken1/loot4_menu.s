{
	Init[()
	{
		ClearMenu();
		AddStaticItem(449);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 549 );
		GetPlayer().PickupItem( Item );
		GetOpener().Hammer = 1;
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}