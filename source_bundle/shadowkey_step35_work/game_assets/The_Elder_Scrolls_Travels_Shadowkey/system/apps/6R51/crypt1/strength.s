{
	Init[ ()
	{
		AddStaticItem(646);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	MenuQuit[ ()
	{
		GetPlayer().AddEffect(Permanent, Strength, Increment, 5);
		Quit();
	}]
}