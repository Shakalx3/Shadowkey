{
	Init[()
	{
		ClearMenu();
		AddStaticItem(3296);
		AddStaticItem(179, false);
		AddMenuItem(517, "Take");

		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 4010 );
		GetPlayer().PickupItem( Item );
		Item = Level.CreateEntity( 4012 );
		GetPlayer().PickupItem( Item );
		GetOpener().SetUsable(false);
		Quit();
	}]

	Loot5Back[()
	{
		// handle the right softkey
		Quit();
	}]
}
