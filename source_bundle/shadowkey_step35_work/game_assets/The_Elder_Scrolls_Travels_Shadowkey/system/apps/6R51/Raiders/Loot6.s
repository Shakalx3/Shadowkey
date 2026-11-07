{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2205);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");

		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 646 );
		GetPlayer().PickupItem( Item );
		Item = Level.CreateEntity( 630 );
		GetPlayer().PickupItem( Item );
		GetOpener().Loot6 = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]

	Loot6Back[()
	{
		// handle the right softkey
		MenuQuit();
	}]
}