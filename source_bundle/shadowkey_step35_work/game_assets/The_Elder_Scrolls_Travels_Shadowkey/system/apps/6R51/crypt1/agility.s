{
	Init[ ()
	{
		AddStaticItem(551);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	MenuQuit[ ()
	{
		GetPlayer().AddEffect(Permanent, Agility, Increment, 5);
		Quit();
	}]
}