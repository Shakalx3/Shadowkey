{
	Init[()
	{
		if(GetPlayer().QuestAssigned(38)=false)
		{
			ClearMenu();
			AddStaticItem(1063);
			AddStaticItem(3454);
			AddStaticItem(179, false);
			AddMenuItem(182, "MoreHelp1");
		}
		else
		{
			if(GetPlayer().QuestSolved(38)=false)
			{
				ClearMenu();
				AddStaticItem(3455);
				AddStaticItem(179, false);
				AddMenuItem(1066, "MenuQuit");
			}
			else
			{
				if(GetPlayer().QuestCompleted(38)=false)
				{
					ClearMenu();
					AddStaticItem(1067);
					AddStaticItem(179, false);
					AddMenuItem(182, "Done");
				}
				else
				{
					if(GetPlayer().QuestAssigned(40)=false)
					{
						ClearMenu();
						AddStaticItem(1068);
						AddStaticItem(1069);
						AddStaticItem(179, false);
						AddMenuItem(182, "NewMore1");
					}
					else
					{
						if(GetPlayer().QuestSolved(40)=false)
						{
						ClearMenu();
						AddStaticItem(3456);
						AddStaticItem(179, false);
						AddMenuItem(1066, "MenuQuit");
						}
						else
						{
							if(GetPlayer().QuestCompleted(40)=false)
							{
							ClearMenu();
							AddStaticItem(1071);
							AddStaticItem(179, false);
							AddMenuItem(182, "NewDone");
							}
							else
							{
							ClearMenu();
							AddStaticItem(1072);
							AddStaticItem(179, false);
							AddMenuItem(3457, "MenuQuit");
							}
						}
					}
				}
			}
		}
	}]

	NewDone[()
	{
		ClearMenu();
		AddStaticItem(1073);
		AddStaticItem(3458);
		AddStaticItem(1075);
		AddStaticItem(179, false);
		AddMenuItem(182, "MenuQuit");
		GetPlayer().SetQuestCompleted(40);
		GetPlayer().AddExperience(2500);
		Item = Level.CreateEntity( 714 );
		GetPlayer().PickupItem( Item );
	}]

	NewMore1[()
	{
		ClearMenu();
		AddStaticItem(3459);
		AddStaticItem(179, false);
		AddMenuItem(182, "NewMore2");
	}]

	NewMore2[()
	{
		ClearMenu();
		AddStaticItem(1077);
		AddStaticItem(179, false);
		AddMenuItem(182, "NewMore3");
	}]

	NewMore3[()
	{
		ClearMenu();
		AddStaticItem(3460);
		AddStaticItem(179, false);
		AddMenuItem(1079, "Persa");
		AddMenuItem(3414, "MenuQuit");
	}]

	Persa[()
	{
		ClearMenu();
		AddStaticItem(1080);
	AddStaticItem(3461);
		AddStaticItem(179, false);
		AddMenuItem(1082, "NewAccepted");
	}]

	NewAccepted[()
	{
		ClearMenu();
		GetPlayer().SetQuestAssigned(40);
		Item = Level.CreateEntity( 4723 );
		GetPlayer().PickupItem( Item );
		Quit();
	}]

	Done[()
	{
		ClearMenu();
		AddStaticItem(3462);
		AddStaticItem(3463);
		AddStaticItem(1085);
		AddStaticItem(179, false);
		AddMenuItem(182, "Next");
		GetPlayer().SetQuestCompleted(38);
		GetPlayer().AddExperience(2000);
		Item = Level.CreateEntity( 913 );
		GetPlayer().PickupItem( Item );
		roster = GetPlayer().FindInventory("mageros");
		GetPlayer().RemoveItem(roster);
	}]

	Next[()
	{
		ClearMenu();
		AddStaticItem(1086);
		AddStaticItem(1087);
		AddStaticItem(1088);
		AddStaticItem(179, false);
		AddMenuItem(591, "MenuQuit");
	}]

	MoreHelp1[()
	{
		ClearMenu();
		AddStaticItem(1089);
		AddStaticItem(3464);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreHelp2");
	}]

	MoreHelp2[()
	{
		ClearMenu();
		AddStaticItem(3465);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreHelp3");
	}]

	MoreHelp3[()
	{
		ClearMenu();
		AddStaticItem(3466);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreHelp4");
	}]

	MoreHelp4[()
	{
		ClearMenu();
		AddStaticItem(3467);
		AddStaticItem(179, false);
		AddMenuItem(796, "Accept");
		AddMenuItem(3414, "MenuQuit");
	}]

	Accept[()
	{
		GetPlayer().SetQuestAssigned(38);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}
