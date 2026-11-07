{
	Init[()
	{
		ClearMenu();
		AddStaticItem(450);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 563 );
		GetPlayer().PickupItem( Item );
		GetOpener().Longbow = 1;
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}