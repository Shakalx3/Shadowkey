{
	Init[()
	{
		AddStaticItem(2512);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "Quit");

		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	}]
	Take[()
	{
		Item = Level.CreateEntity(662);
		GetPlayer().PickupItem(Item);
		GetOpener().saved_Opened = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]

	loot1_menuBack[()
	{
		// handle the right softkey
		Quit();
	}]
}