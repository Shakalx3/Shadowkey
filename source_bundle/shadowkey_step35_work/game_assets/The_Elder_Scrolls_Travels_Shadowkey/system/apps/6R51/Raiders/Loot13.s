{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2199);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 912 );
		GetPlayer().PickupItem( Item );
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}