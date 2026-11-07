{
	Init[()
	{
		ClearMenu();
		AddStaticItem(653);
		AddStaticItem(179, false);
		AddMenuItem(651, "MenuQuit");
	}]

	MenuQuit[()
	{
		GetPlayer().AddEffect(Permanent, Intelligence, Increment, 5);
		Quit();
	}]
}