{
	Init[()
	{
		AddStaticItem(697);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]
	MenuQuit[()
	{
		GetPlayer().AddEffect(Permanent, Personality, Increment, 5);
		Quit();
	}]
}