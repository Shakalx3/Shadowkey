{

	Init[ (s)
	{
		if(GetPlayer().saved_EndGame = 1)
		{
			AddStaticItem(3985);
			AddStaticItem(179);
			AddMenuItem(182, "End1");
		}
		else
		{
			if(GetPlayer().QuestCompleted(2) )
			{
				ClearMenu();
				AddStaticItem(178);
				AddStaticItem(179, false);
				AddMenuItem(180, "MenuQuit");
			}
			else
			{
				if(GetPlayer().QuestSolved(2) )
				{
					AddStaticItem( 181);
					AddStaticItem(179, false);
					AddMenuItem(182, "MoreResponse");
				}
				else
				{
					if( GetPlayer().QuestAssigned(2) )
					{
						ClearMenu();
						AddStaticItem(183);
						AddStaticItem(179, false);
						AddMenuItem(184, "MenuQuit");
					}
					else
					{

						if(GetPlayer().QuestSolved(1))
						{
							ClearMenu();
							AddStaticItem(185 );
							AddStaticItem( 179, false );
							AddMenuItem( 186, "YesResponse" );
							AddMenuItem( 187, "MenuQuit" );
						}
						else
						{
							if(GetPlayer().QuestAssigned(1))
							{

								ClearMenu();
								AddStaticItem(188);
								AddStaticItem(179, false);
								AddMenuItem(189, "MenuQuit");

							}
							else
							{
								ClearMenu();
								AddStaticItem(190);
								AddStaticItem(179, false);
								AddMenuItem(191, "MenuQuit");
							}
						}
					}
				}
			}
		}
	} ]

	End1[()
	{
		ClearMenu();
		AddStaticItem(3986);
		AddStaticItem(179);
		AddMenuItem(834, "Quit");
	}]

	MoreResponse [ (s)
	{
		ClearMenu();
		AddStaticItem(192);
		AddStaticItem(193);
		AddStaticItem(194);
		AddStaticItem(179, false);
		AddMenuItem(195, "MenuQuit");
		GetPlayer().StatModXP(1500);
		GetPlayer().StatModGold(500);
		GetPlayer().SetQuestCompleted(2);
	} ]

	YesResponse[ (s)
	{
		GetPlayer().SetQuestAssigned(2,true);
		ClearMenu();
		AddStaticItem(196);
		AddStaticItem(179, false);
		AddMenuItem(197, "WhereResponse");
		AddMenuItem(198, "MenuQuit");
	} ]

	WhereResponse[ (s)
	{
		ClearMenu();
		AddStaticItem(199);
		AddStaticItem(179, false);
		AddMenuItem(198, "MenuQuit");
	} ]

	MenuQuit[ (s)
	{
		Quit();
	} ]
}