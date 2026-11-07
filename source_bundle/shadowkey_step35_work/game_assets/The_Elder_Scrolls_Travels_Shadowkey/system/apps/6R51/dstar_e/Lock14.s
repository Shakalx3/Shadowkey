{
	Init[ (s)
	{
		// Locked chest with 600 - 1200 random gold
		ClearMenu();
		AddStaticItem(3141);
		AddStaticItem(179, false);
		AddMenuItem(517, "MenuQuit");
	}]

	MenuQuit[ ()
	{
		Quit();
	}]

}
