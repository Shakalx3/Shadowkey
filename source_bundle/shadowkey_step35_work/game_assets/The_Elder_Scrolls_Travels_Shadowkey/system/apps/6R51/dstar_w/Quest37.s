{
	Init[ ()
	{
		ClearMenu();
		AddStaticItem(3665);
		AddStaticItem(179, false);
		AddMenuItem(3590, "MenuQuit");
	}]
	MenuQuit[ ()
	{
		Quit();
	}]

}