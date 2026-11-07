{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2206);
		AddStaticItem(179, false);
		AddMenuItem(444, "Getit");
		AddMenuItem(445, "MenuQuit");

		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	}]

	Getit[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 530 );
		GetPlayer().PickupItem( Item );
		GetOpener().Loot7 = 1;
		GetOpener().SetUsable(false);
		Quit();
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
