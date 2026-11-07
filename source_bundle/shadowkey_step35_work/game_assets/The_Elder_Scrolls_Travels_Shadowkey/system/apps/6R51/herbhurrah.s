{
	Init[ (s)
	{
		DelayOnEnter();

		if( GetPlayer().QuestAssigned(1) )
		{
			AddStaticItem(1583);
			AddStaticItem(179, false);
			AddMenuItem(1584, "MenuQuit");
		}
		else
		{
			AddStaticItem(1585);
			AddStaticItem(179, false);
			AddMenuItem(1584, "MenuQuit");
		}
	}]

	MenuQuit[ (s)
	{
		Quit();
	}]
}