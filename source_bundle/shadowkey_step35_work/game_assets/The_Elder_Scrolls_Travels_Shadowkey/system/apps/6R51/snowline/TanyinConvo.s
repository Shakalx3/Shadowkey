{
	Init[ (s)
	{
		if(GetPlayer().QuestSolved(26) = true)
		{
			CrossPurposes();
		}
		else
		{
			if (GetPlayer().QuestAssigned(25) = false)
			{
				ClearMenu();
				AddStaticItem(2370);
				AddStaticItem(179, false);
				AddMenuItem(182, "Speech1");
			}
			else
			{
				if(GetPlayer().QuestSolved(25) = false)
				{
					ClearMenu();
					AddStaticItem(2368);
					AddStaticItem(179, false);
					AddMenuItem(2314, "Quit");
				}
				else
				{
					if(GetPlayer().QuestCompleted(25) = false)
					{
						ClearMenu();
						AddStaticItem(2369);
						AddStaticItem(179, false);
						AddMenuItem(182, "Quest25");
					}
					else
					{
						if(GetPlayer().QuestAssigned(27) = false)
						{
							ClearMenu();
							AddStaticItem(2373);
							AddStaticItem(179, false);
							AddMenuItem(182, "Lakvan1");
						}
						else
						{
							if(GetPlayer().QuestSolved(27) = false)
							{
								ClearMenu();
								AddStaticItem(2371);
								AddStaticItem(179, false);
								AddMenuItem(2314, "Quit");
							}
							else
							{
								if(GetPlayer().QuestCompleted(27) = false)
								{
									ClearMenu();
									AddStaticItem(2372);
									AddStaticItem(179, false);
									AddMenuItem(182, "More1");
								}
							}
						}
					}
				}
			}
		}
	}]

	Quest25[ (s)
	{
		ClearMenu();
		AddStaticItem(2374);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
		GetPlayer().AddExperience( 1000 );
		GetPlayer().SetQuestCompleted(25);
	} ]

	Speech1[ (s)
	{
		ClearMenu();
		AddStaticItem(2375);
		AddStaticItem(179, false);
		AddMenuItem(182, "Speech2");
	} ]

	Speech2[ (s)
	{
		ClearMenu();
		AddStaticItem(2376);
		AddStaticItem(179, false);
		AddMenuItem(182, "Speech2a");
	} ]

	Speech2a[ (s)
	{
		ClearMenu();
		AddStaticItem(3572);
		AddStaticItem(179, false);
		AddMenuItem(182, "Speech3");
	}]

	Speech3[ (s)
	{
		ClearMenu();
		AddStaticItem(2377);
		AddStaticItem(179, false);
		AddMenuItem(2321, "Accept");
		AddMenuItem(1004, "Refuse");
	} ]

	Refuse[ (s)
	{
		if( GetPlayer().QuestAssigned(26) = true )
		{
			GetPlayer().SetQuestSolved(26);
		}
		Quit();
	} ]

	Accept[ (s)
	{
		GetPlayer().SetQuestAssigned(26, false);
		GetPlayer().SetQuestAssigned(25);
		GetPlayer().SetQuestCompleted(6);
		Quit();
	} ]

	More1[ (s)
	{
		ClearMenu();
		AddStaticItem(2378);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	} ]

	More2[ (s)
	{
		ClearMenu();
		AddStaticItem(2379);
		AddStaticItem(179, false);
		AddMenuItem(182, "ComeSeeMe");
		GetPlayer().SetQuestCompleted(27);
		GetPlayer().AddExperience(2500);
	} ]

	Lakvan1[ (s)
	{
		ClearMenu();
		AddStaticItem(2380);
		AddStaticItem(179, false);
		AddMenuItem(182, "Lakvan2");
	} ]

	Lakvan2[ (s)
	{
		ClearMenu();
		AddStaticItem(2381);
		AddStaticItem(179, false);
		AddMenuItem(182, "Lakvan3");
	} ]

	Lakvan3[ (s)
	{
		ClearMenu();
		AddStaticItem(2382);
		AddStaticItem(179, false);
		AddMenuItem(2321, "Lakvan4" );
		AddMenuItem(378, "Quit");
	} ]

	Lakvan4[ (s)
	{
		GetPlayer().SetQuestAssigned(27);
		Quit();
	} ]

	CrossPurposes[ (s)
	{
		ClearMenu();
		AddStaticItem(2383);
		AddStaticItem(179, false);
		AddMenuItem(182, "Cross1" );
	} ]

	Cross1[ (s)
	{
		ClearMenu();
		AddStaticItem(2384);
		AddStaticItem(179, false);
		AddMenuItem(182, "Cross2");
	} ]

	Cross2[ (s)
	{
		ClearMenu();
		AddStaticItem(2385);
		AddStaticItem(179, false);
		AddMenuItem(2386, "MenuQuit");
	} ]

	ComeSeeMe[ (s)
	{
		ClearMenu();
		AddStaticItem(2387);
		AddStaticItem(179, false);
		AddMenuItem(182, "Second1");
	} ]

	Second1[ (s)
	{
		ClearMenu();
		AddStaticItem(3712);
		AddStaticItem(179, false);
		AddMenuItem(2386, "MenuQuit");
	} ]

	MenuQuit[()
	{
		Tanyin = Level.GetEntity("tanyin");
		Tanyin.DestroyObjectMirror(Tanyin);
		Quit();
	}]
}