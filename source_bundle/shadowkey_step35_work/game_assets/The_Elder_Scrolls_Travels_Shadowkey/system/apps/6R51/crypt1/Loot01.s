{
	Init[()
	{
		AddStaticItem(605);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "Quit");
	}]

	Take[()
	{
		Item = Level.CreateEntity( 4502 );
		GetPlayer().PickupItem( Item );
		GetOpener().Sarc = 1;
		Quit();
	}]
}