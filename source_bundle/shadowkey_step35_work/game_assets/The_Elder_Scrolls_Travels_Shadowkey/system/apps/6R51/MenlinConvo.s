{

	Init[ (s)
	{
		if(GetPlayer().saved_EndGame = 1)
		{
			AddStaticItem(3982);
			AddStaticItem(179);
			AddMenuItem(182, "End1");
		}
		else
		{
			if( GetPlayer().QuestCompleted(1) )
			{
				ClearMenu();
				AddStaticItem(1970);
				AddStaticItem(179, false);
				AddMenuItem(200, "MenuQuit");
			}
			else
			{
				//if( GetPlayer().QuestAssigned(1) and GetPlayer().HasItem("herbs") )

				if( GetPlayer().QuestSolved(1) )
				{
					AddStaticItem( 1971);
					AddStaticItem(179, false);
					AddMenuItem(182, "MoreResponse");
				}
				else
				{
					if( GetPlayer().QuestAssigned(1) )
					{
						ClearMenu();
						AddStaticItem(1972);
						AddStaticItem(179, false);
						AddMenuItem(1584, "MenuQuit");
					}
					else
					{
						AddStaticItem( 1973 );
						AddStaticItem( 179, false );
						AddMenuItem( 1974, "YesResponse" );
						AddMenuItem( 187, "MenuQuit" );
					}
				}
			}
		}
	} ]

	End1[()
	{
		ClearMenu();
		AddStaticItem(3983);
		AddStaticItem(179);
		AddMenuItem(3984, "Quit");
	}]

	MoreResponse [ (s)
	{
		ClearMenu();
		AddStaticItem(1975);
		AddStaticItem(1976);
		AddStaticItem(1977);
		AddStaticItem(179, false);
		AddMenuItem(195, "MenuQuit");
		GetPlayer().AddExperience(500); 	// +500
		GetPlayer().StatModGold(300); 	// +300
		GetPlayer().SetQuestCompleted(1,true);
	} ]

	YesResponse[ (s)
	{
		GetPlayer().SetQuestAssigned(1,true);
		ClearMenu();
		AddStaticItem(1978);
		AddStaticItem(179, false);
		AddMenuItem(1979, "WhereResponse");
		AddMenuItem(198, "MenuQuit");
	} ]

	WhereResponse[ (s)
	{
		ClearMenu();
		AddStaticItem(1980);
		AddStaticItem(179, false);
		AddMenuItem(198, "MenuQuit");
	} ]

	MenuQuit[ (s)
	{
		Quit();
	} ]
}