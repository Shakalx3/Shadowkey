{
	Init[()
	{
		AddStaticItem(3250);
		Item = Level.CreateEntity( 911 );
		GetPlayer().PickupItem( Item );
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	MenuQuit[ ()
	{
		Quit();
	}]
}