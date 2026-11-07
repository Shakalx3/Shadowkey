{
	Init[ ()
	{
		ClearMenu();
		AddStaticItem(1145);
		AddStaticItem(179, false);
		AddMenuItem(517, "MenuQuit");
	}]

	MenuQuit[ ()
	{
		Quit();
	}]
}