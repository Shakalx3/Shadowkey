{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem(2157);
		AddStaticItem(179, false);
		AddMenuItem(713, "MenuQuit");
	}]

	MenuQuit[ (s)
	{
		Quit();
	}]
}