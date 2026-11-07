{
	Init[()
	{
		ClearMenu();
		AddStaticItem(1835);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 663 );
		GetPlayer().PickupItem( Item );
		GetOpener().SetUsable(false);
		Quit();
	}]
}