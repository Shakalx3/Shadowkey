{
	Init[()
	{
		ClearMenu();
		AddStaticItem(3404);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		Scroll = Level.CreateEntity( 4017 ); //doomhammer
		Scroll.SetScroll(true);
		Scroll.SetLevel(10);
		GetPlayer().PickupItem(Scroll);
		GetOpener().Loot9 = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}