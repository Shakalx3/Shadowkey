{
	Init[ (s)
	{
		if(Level.EndGame_Skelos = 1)
		{
			AddStaticItem(3978);
			AddStaticItem(179);
			AddMenuItem(3979, "Quit");
			AddMenuItem(3980, "Quit");
		}
		else
		{
			if(GetPlayer().saved_EndGame = 1)
			{
				AddStaticItem(3976);
				AddStaticItem(179);
				AddMenuItem(182, "End1");
			}
			else
			{
				if( GetPlayer().QuestCompleted(5) = true )
				{
					AddStaticItem(3957);
					AddStaticItem(179, false);
					AddMenuItem(434, "ByeBye");
					AddMenuItem(2303, "Quit");
				}
				else
				{
					if( GetPlayer().QuestAssigned(5) = false )
					{
						ClearMenu();
						AddStaticItem(371);
						AddStaticItem(179, false);
						AddMenuItem(182, "More1");
					}
					else
					{
						if( GetPlayer().QuestSolved(5) = false )
						{
							ClearMenu();
							AddStaticItem(372);
							AddStaticItem(179, false);
							AddMenuItem(373, "Quit");
						}
						else
						{
							ClearMenu();
							AddStaticItem(374);
							AddStaticItem(179, false);
							AddMenuItem(182, "Solved1");
						}
					}
				}
			}
		}
	} ]

	End1[ ()
	{
		ClearMenu();
		AddStaticItem(3977);
		AddStaticItem(179);
		AddMenuItem(834, "Quit");
		Level.EndGame_Skelos = 1;
	}]

	ByeBye[()
	{
		ClearMenu();
		AddStaticItem(369);
		AddStaticItem(179, false);
		AddMenuItem(370, "Quit");
		GetPlayer().SetQuestAssigned(10);
		Skelos = Level.GetEntity("skelos");
		Skelos.DestroyObjectMirror(Skelos);
	}]

	More1[ (s)
	{
		ClearMenu();
		AddStaticItem(375);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	} ]

	More2[ (s)
	{
		ClearMenu();
		AddStaticItem(376);
		AddStaticItem(179, false);
		AddMenuItem(182, "More3");
	} ]

	More3[ (s)
	{
		ClearMenu();
		AddStaticItem(377);
		AddStaticItem(179, false);
		AddMenuItem(379, "Accept5");
		AddMenuItem(3236, "Quit");
	} ]

	Accept5[ (s)
	{
		GetPlayer().SetQuestAssigned(5);
		Quit();
	} ]

	Solved1[ (s)
	{
		ClearMenu();
		AddStaticItem(380);
		AddStaticItem(179, false);
		AddMenuItem(182, "Solved2");
	} ]

	Solved2[ (s)
	{
		ClearMenu();
		AddStaticItem(381);
		AddStaticItem(179, false);
		AddMenuItem(182, "Solved3");
	} ]

	Solved3[ (s)
	{
		ClearMenu();
		AddStaticItem(382);
		AddStaticItem(179, false);
		AddMenuItem(182, "Solved4");
	} ]

	Solved4[ (s)
	{
		ClearMenu();
		AddStaticItem(383);
		AddStaticItem(179, false);
		AddMenuItem(182, "Solved5");
	} ]

	Solved5[ (s)
	{
		ClearMenu();
		AddStaticItem(384);
		AddStaticItem(179, false);
		AddMenuItem(182, "Solved6");
	} ]

	Solved6[ (s)
	{
		ClearMenu();
		AddStaticItem(385);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
		GetPlayer().SetQuestCompleted(5);
		GetPlayer().StatModGold(300);
		GetPlayer().AddExperience(700);
	} ]
}