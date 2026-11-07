{
	Init[()
	{
		ClearMenu();
		AddStaticItem(1837);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");

		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 4505 );
		GetPlayer().PickupItem( Item );
		GetOpener().Loot5 = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]

	Loot5Back[()
	{
		// handle the right softkey
		MenuQuit();
	}]
}