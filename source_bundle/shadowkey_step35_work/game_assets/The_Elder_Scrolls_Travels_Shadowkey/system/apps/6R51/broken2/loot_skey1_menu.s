{
	Init[()
	{
		ClearMenu();
		AddStaticItem(505);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 663 );
		GetPlayer().PickupItem( Item );
		GetOpener().Chest = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}