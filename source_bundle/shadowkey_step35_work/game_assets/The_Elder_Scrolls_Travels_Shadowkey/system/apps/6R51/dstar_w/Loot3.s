{
	Init[()
	{
		ClearMenu();
		AddStaticItem(3663);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 685 );
		GetPlayer().PickupItem( Item );
		GetOpener().ChestLoot3 = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}