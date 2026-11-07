{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2688);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");

		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	}]

	Take[()
	{
		ClearMenu();
		AddStaticItem(2689);
		Item = Level.CreateEntity( 649 );
		GetPlayer().PickupItem( Item );
		AddStaticItem(2690);
		Item = Level.CreateEntity( 682 );
		GetPlayer().PickupItem( Item );
		AddStaticItem(179, false);
		AddMenuItem(517, "MenuQuit");
		GetOpener().Chest07 = 1;
		GetOpener().SetUsable(false);
	}]

	MenuQuit[()
	{
		Quit();
	}]

	Loot7Back[()
	{
		// handle the right softkey
		MenuQuit();
	}]
}