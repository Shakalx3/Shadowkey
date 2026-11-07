{
	Init[()
	{
		ClearMenu();
		AddStaticItem(655);
		AddStaticItem(179, false);
		AddMenuItem(656, "Take");
	}]

	Take[()
	{
		Item = Level.CreateEntity( 4501 );
		GetPlayer().PickupItem( Item );
		Quit();
	}]
}