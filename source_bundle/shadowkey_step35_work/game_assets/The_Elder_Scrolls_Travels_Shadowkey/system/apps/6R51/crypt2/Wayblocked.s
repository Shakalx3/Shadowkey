{
	Init[()
	{
		if (Level.saved_wayblocked = 0)
		{
			AddStaticItem(686);
			AddStaticItem(179, false);
			AddMenuItem(651, "MenuQuit");
		}
		if (Level.saved_wayblocked = 1)
		{
			AddStaticItem(687);
			AddStaticItem(179, false);
			AddMenuItem(651, "MenuQuit");
		}
	}]

	MenuQuit[()
	{
		Quit();
	}]
}