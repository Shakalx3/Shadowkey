{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2686);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		AddStaticItem(2687);
		Item = Level.CreateEntity( 703 );
		GetPlayer().PickupItem( Item );
		AddStaticItem(179, false);
		AddMenuItem(517, "MenuQuit");
		GetOpener().Loot_Bag4 = 1;
		GetOpener().DestroyObject(GetOpener());
	}]

	MenuQuit[()
	{
		Quit();
	}]
}