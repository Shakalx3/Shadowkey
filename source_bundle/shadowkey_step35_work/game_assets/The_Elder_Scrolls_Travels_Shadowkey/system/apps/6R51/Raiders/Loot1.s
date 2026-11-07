{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2195);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 717 );
		GetPlayer().PickupItem( Item );
		GetOpener().SetUsable(false);
		Quit();
	}]
}