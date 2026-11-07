{
	Init[ ()
	{
		AddStaticItem(603);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	MenuQuit[ ()
	{
		GetPlayer().AddEffect(Permanent, Endurance, Increment, 5);
		Quit();
	}]
}]