{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2693);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		AddStaticItem(2694);
		Item = Level.CreateEntity( 4018 );
		GetPlayer().PickupItem( Item );
		AddStaticItem(179, false);
		AddMenuItem(517, "MenuQuit");
		GetOpener().Loot9 = 1;
		GetOpener().DestroyObject(GetOpener());
	}]

	MenuQuit[()
	{
		Quit();
	}]
}