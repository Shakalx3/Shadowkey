{
	Init[()
	{
		ClearMenu();
		AddStaticItem(3662);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 575 );
		GetPlayer().PickupItem( Item );
		GetOpener().ChestLoot1 = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}