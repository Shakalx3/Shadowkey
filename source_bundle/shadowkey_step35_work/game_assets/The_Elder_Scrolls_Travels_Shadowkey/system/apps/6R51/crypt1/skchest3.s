{
	Init[()
	{
		AddStaticItem(644);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 664 );
		GetPlayer().PickupItem( Item );
		GetOpener().saved_SkChest3 = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}