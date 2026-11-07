{
	Init[()
	{
		ClearMenu();
		AddStaticItem(1836);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 4503 );
		GetPlayer().PickupItem( Item );
		GetOpener().Loot4 = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}