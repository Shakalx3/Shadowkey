{
	Init[()
	{
		ClearMenu();
		AddStaticItem(1838);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 668 );
		GetPlayer().PickupItem( Item );
		GetOpener().Loot6 = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}