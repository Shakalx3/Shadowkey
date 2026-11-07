{
	Init[()
	{
		ClearMenu();
		AddStaticItem(3242);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 619 );
		GetPlayer().PickupItem( Item );
		GetOpener().boneLoot = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}