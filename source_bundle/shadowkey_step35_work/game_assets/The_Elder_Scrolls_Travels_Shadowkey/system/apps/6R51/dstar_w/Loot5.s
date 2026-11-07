{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2974);
		AddStaticItem(179, false);
		AddMenuItem(182, "More1");
	}]
	More1[()
	{
		ClearMenu();
		AddStaticItem(2975);
		AddStaticItem(179, false);
		GetPlayer().PlaySound(87);
		AddMenuItem(591, "MenuQuit");
		GetPlayer().AddEffect(Permanent, Strength, Increment, 5);
		GetOpener().SetUsable(false);
	}]

	MenuQuit[ ()
	{
		Quit();
	}]
}