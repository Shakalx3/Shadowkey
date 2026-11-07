{
	Init[ (s)
	{
		AddStaticItem(785);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
		Level.saved_StartUpCreated = 1;
	}]

	More[ (s)
	{
		ClearMenu();
		AddStaticItem(786);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	MenuQuit[ (s)
	{
		Quit();
	}]
}