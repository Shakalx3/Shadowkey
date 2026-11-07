{
	Init[()
	{
		ClearMenu();
		AddStaticItem(641);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 664 );
		GetPlayer().PickupItem( Item );
		GetOpener().SkChest = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}