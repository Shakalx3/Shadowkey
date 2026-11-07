{
	Init[()
	{
		Level.Log("I am in the init of Loot3.");
		ClearMenu();
		AddStaticItem(659);
		AddStaticItem(179, false);
		AddMenuItem(656, "Staff");
		AddMenuItem(657, "MenuQuit");

	}]

	MenuQuit[()
	{
		Quit();
	}]

	Staff[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 574 );
		GetPlayer().PickupItem( Item );
		GetOpener().staff = 1;
		Quit();
	}]
}