{
	Init[()
	{
		ClearMenu();
		AddStaticItem(647);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
	}]

	Take[()
	{
		Item = Level.CreateEntity( 551 );
		GetPlayer().PickupItem( Item );
		GetOpener().SetUsable(false);
		Quit();
	}]
}