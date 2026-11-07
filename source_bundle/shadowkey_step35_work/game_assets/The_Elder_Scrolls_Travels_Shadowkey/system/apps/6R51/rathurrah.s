{
	Init[ (s)
	{
		if( GetPlayer().QuestAssigned(0) )
		{
			AddStaticItem(2270);
			AddStaticItem(2271);
			AddStaticItem(2272);
			AddStaticItem(2273);
			AddStaticItem(179, false);
			AddMenuItem(2274, "MoreInfo");
		}
		else
		{
			AddStaticItem(2275);
			AddStaticItem(179, false);
			AddMenuItem(386, "Quit");
		}
	}]

	MoreInfo[ (s)
	{
		ClearMenu();
		AddStaticItem(2276);
		AddStaticItem(2277);
		AddStaticItem(2278);
		AddStaticItem(179, false);
		AddMenuItem(2279, "MenuQuit");
	}]

	MenuQuit[ (s)
	{
		Quit();
	}]
}