{
	Init[ (s)
	{
		Gold = Level.CreateEntity( 52 );
		Gold.SetQuantity( Random( 12, 40 ) );
		GetPlayer().StatModGold(Gold);
		GetPlayer().PickupItem(Gold);
		ClearMenu();
		AddStaticItem(3635);
		AddStaticItem(3924);
		AddStaticItem(179, false);
		AddMenuItem(591, "MenuQuit");
		saved_Open = 1;
	}]

	MenuQuit[ (s)
	{
		Quit();
	}]
}