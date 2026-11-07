{
	Init[ (s)
	{
		Gold = Level.CreateEntity( 52 );
		Gold.SetQuantity( Random( 100, 500 ) );
		GetPlayer().StatModGold(Gold);
		GetPlayer().PickupItem(Gold);
		ClearMenu();
		AddStaticItem(3635);
		AddStaticItem("You loot  "  #Gold#  "  gold from the chest");
		AddStaticItem(179, false);
		AddMenuItem(591, "MenuQuit");
		saved_Open = 1;
	}]

	MenuQuit[ (s)
	{
		Quit();
	}]
}