{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2678);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		AddStaticItem(2679);
		Item = Level.CreateEntity( 510 );
		GetPlayer().PickupItem( Item );
		AddStaticItem(179, false);
		AddMenuItem(517, "MenuQuit");
		GetOpener().Loot3 = 1;
		GetOpener().DestroyObject();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}