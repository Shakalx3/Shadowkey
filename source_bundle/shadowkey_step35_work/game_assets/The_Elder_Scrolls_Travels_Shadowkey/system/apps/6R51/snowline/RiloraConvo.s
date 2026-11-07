{
	Init[ (s)
	{
		ClearMenu();
		Herb1 = GetPlayer().FindInventory("herb1");
		Herb2 = GetPlayer().FindInventory("herb2");
		Herb3 = GetPlayer().FindInventory("herb3");
		Herb4 = GetPlayer().FindInventory("herb4");
		Herb5 = GetPlayer().FindInventory("herb5");
		if((GetPlayer().QuestAssigned(42) = true) and (GetPlayer().QuestSolved(42) = false))
		{
			ClearMenu();
			AddStaticItem(2338);
			AddStaticItem(179, false);
			AddMenuItem(182, "Accepted1");
			return;
		}
		if( GetPlayer().QuestCompleted(22) = true )
		{
			ClearMenu();
			AddStaticItem(2339);
			AddStaticItem(179, false);
			AddMenuItem(386, "Quit");
			return;
		}


		if( isObject(Herb1) and isObject(Herb2) and isObject(Herb3) and isObject(Herb4) and isObject(Herb5) )
		{
			ClearMenu();
			AddStaticItem(2340);
			AddStaticItem(179, false);
			AddMenuItem(182, "Experience");
			GetPlayer().SetQuestCompleted(22);

			GetPlayer().RemoveItem(Herb1);
			GetPlayer().RemoveItem(Herb2);
			GetPlayer().RemoveItem(Herb3);
			GetPlayer().RemoveItem(Herb4);
			GetPlayer().RemoveItem(Herb5);
			GetPlayer().DestroyObject(Herb1);
			GetPlayer().DestroyObject(Herb2);
			GetPlayer().DestroyObject(Herb3);
			GetPlayer().DestroyObject(Herb4);
			GetPlayer().DestroyObject(Herb5);
		}

		if( (GetPlayer().QuestAssigned(22) = true) and (GetPlayer().QuestCompleted(22) = false))
		{
			ClearMenu();
			AddStaticItem(2341);
			AddStaticItem(179, false);
			AddMenuItem(2342, "Quit");
			return;
		}

		if( GetPlayer().QuestAssigned(22) = false )
		{
			ClearMenu();
			AddStaticItem(2343);
			AddStaticItem(179, false);
			AddMenuItem(182,"Spiel1");
		}
	} ]

	Accepted1[ (s)
	{
		ClearMenu();
		AddStaticItem(2344);
		AddStaticItem(179, false);
		AddMenuItem(182, "Accepted2" );
	} ]

	Accepted2[ (s)
	{
		ClearMenu();
		AddStaticItem(2345);
		AddStaticItem(179, false);
		AddMenuItem(2346, "Experience" );
		AddMenuItem(2347, "Experience" );
	} ]

	Experience[ (s)
	{
		ClearMenu();
		AddStaticItem(2348);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
		GetPlayer().SetQuestSolved(42);
		GetPlayer().AddExperience( 1250 );
	} ]

	Spiel1[ (s)
	{
		ClearMenu();
		AddStaticItem(2349);
		AddStaticItem(179, false);

		AddMenuItem(2350, "HerbList");
		AddMenuItem(378, "Quit");
	} ]

	HerbList[ (s)
	{
		GetPlayer().SetQuestAssigned(22);

		ClearMenu();
		AddStaticItem(2351);
		AddStaticItem(179, false);
		AddMenuItem(182, "HerbList2");
	} ]

	HerbList2[ (s)
	{
		ClearMenu();
		AddStaticItem(2352);
		AddStaticItem(179, false);
		AddMenuItem(2353, "Quit" );
	} ]
}