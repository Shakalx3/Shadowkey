{
	Init[()
	{
		ClearMenu();
		AddStaticItem(1830);
		AddStaticItem(179, false);
		AddMenuItem(1831, "LakvanKey");
		AddMenuItem(445, "MenuQuit");

		// Add the 'Back' text for the right softkey
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	}]

	LakvanKey[()
	{
		ClearMenu();
		AddStaticItem(1832);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
		Item = Level.CreateEntity( 720 );
		GetPlayer().PickupItem( Item );
		GetPlayer().SetGold( GetPlayer().GetGold() + 70 );
		GetOpener().DestroyObject( GetOpener() );
	}]

	MenuQuit[()
	{
		Quit();
	}]

	Loot1Back[()
	{
		// handle the right softkey
		MenuQuit();
	}]
}