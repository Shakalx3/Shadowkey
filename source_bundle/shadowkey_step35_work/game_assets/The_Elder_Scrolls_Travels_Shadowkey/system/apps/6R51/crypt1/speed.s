{
	Init[ ()
	{
		AddStaticItem(645);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	MenuQuit[ ()
	{
		GetPlayer().AddEffect(Permanent, Speed, Increment, 5);
		Quit();
	}]
}]