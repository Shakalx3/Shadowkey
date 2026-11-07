{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2207);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");

		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 4740 );
		GetPlayer().PickupItem( Item );
		GetOpener().Loot8 = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]

	Loot8Back[()
	{
		// handle the right softkey
		MenuQuit();
	}]
}