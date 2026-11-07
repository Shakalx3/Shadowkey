{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2685);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		AddStaticItem(2611);
		Item = Level.CreateEntity( 702 );
		GetPlayer().PickupItem( Item );
		AddStaticItem(179, false);
		AddMenuItem(517, "MenuQuit");
		GetOpener().Loot_Bag3 = 1;
		GetOpener().DestroyObject(GetOpener());
	}]

	MenuQuit[()
	{
		Quit();
	}]
}