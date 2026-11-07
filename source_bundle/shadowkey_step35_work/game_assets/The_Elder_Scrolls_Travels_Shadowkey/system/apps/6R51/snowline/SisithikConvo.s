{
	Init[ (s)
	{
		if( GetPlayer().QuestCompleted(21) = true )
		{
			ClearMenu();
			AddStaticItem(2354);
			AddStaticItem(179, false);
			AddMenuItem(2355, "Quit" );
			return;
		}

		if( (GetPlayer().QuestAssigned(21) = true) and (GetPlayer().QuestSolved(21) = false) )
		{
			ClearMenu();
			AddStaticItem(2356);
			AddStaticItem(179, false);
			AddMenuItem(2357, "Quit");
			return;
		}

		if( (GetPlayer().QuestAssigned(21) = true) and (GetPlayer().QuestCompleted(21) = false) )
		{
			ClearMenu();
			AddStaticItem(2358);
			AddStaticItem(179, false);
			AddMenuItem(182, "Completed");
			return;
		}

		if( (GetPlayer().QuestAssigned(21) = false) )
		{
			ClearMenu();
			AddStaticItem(2359);
			AddStaticItem(179, false);
			AddMenuItem(182, "Quest1");
			return;
		}
	} ]

	Completed[ (s)
	{
		ClearMenu();
		AddStaticItem(2360);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
		Will = GetPlayer().FindInventory("siswill");
		Will.DestroyObject(Will);
		GetPlayer().AddExperience( 1250 );
		GetPlayer().SetQuestCompleted(21);
	} ]

	Quest1[ (s)
	{
		ClearMenu();
		AddStaticItem(2361);
		AddStaticItem(179, false);
		AddMenuItem(2363, "Quest2" );
		AddMenuItem(2362, "Quit");
	} ]

	Quest2[ (s)
	{
		GetPlayer().SetQuestAssigned(21);
		Quit();
	} ]
}