{
	Init[()
	{
		ClearMenu();
		AddStaticItem(503);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 4035 );
		GetPlayer().PickupItem( Item );
		GetOpener().Chest = 1;
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}