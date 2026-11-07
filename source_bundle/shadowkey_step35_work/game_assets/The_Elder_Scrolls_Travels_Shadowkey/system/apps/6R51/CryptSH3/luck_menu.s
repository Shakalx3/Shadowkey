{
	Init[()
	{
		AddStaticItem(692);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]
	MenuQuit[()
	{
		GetPlayer().AddEffect(Permanent, Luck, Increment, 5);
		Quit();
	}]
}