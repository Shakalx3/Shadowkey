{
	Init[(s)
	{
		ClearMenu();
		AddStaticItem(3663);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[(s)
	{
		ClearMenu();
		Item = Level.CreateEntity( 4029 );
		GetPlayer().PickupItem( Item );
		GetOpener().ChestLoot2 = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[(s)
	{
		Quit();
	}]
}