{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2200);
		AddStaticItem(2201);
		AddStaticItem(179, false);
		AddMenuItem(1082, "Take");
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 717 );
		GetPlayer().PickupItem( Item );
		Quit();
	}]
}
