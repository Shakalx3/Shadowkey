{
	Init[ ()
	{
		AddStaticItem(1358);
		AddStaticItem(179, false);
		AddMenuItem(386, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[ ()
	{
		GetOpener().SetUsable(false);
		//GetOpener().OpenBag();
	}]

	MenuQuit[ ()
	{
		Quit();
	}]
}
