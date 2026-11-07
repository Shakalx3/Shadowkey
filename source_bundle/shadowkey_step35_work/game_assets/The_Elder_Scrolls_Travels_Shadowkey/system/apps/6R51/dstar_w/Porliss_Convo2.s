{
	Init[()
	{
		if(GetPlayer().QuestAssigned(36)=false)
		{
			ClearMenu();
			AddStaticItem(1174);
			AddStaticItem(3226);
			AddStaticItem(179, false);
			AddMenuItem(182, "MoreHelp1");
		}
		else
		{
			if(GetPlayer().QuestSolved(36)=false)
			{
				ClearMenu();
				AddStaticItem(3227);
				AddStaticItem(179, false);
				AddMenuItem(1177, "MenuQuit");
			}
			else
			{
				if(GetPlayer().QuestCompleted(36)=false)
				{
					ClearMenu();
					AddStaticItem(3228);
					AddStaticItem(179, false);
					AddMenuItem(3229, "Done");
				}
				else
				{
					if(GetPlayer().QuestAssigned(39)=false)
					{
						ClearMenu();
						AddStaticItem(1180);
						AddStaticItem(3230);
						AddStaticItem(179, false);
						AddMenuItem(182, "NewMore1");
					}
					else
					{
						if(GetPlayer().QuestSolved(39)=false)
						{
						ClearMenu();
						AddStaticItem(3231);
						AddStaticItem(179, false);
						AddMenuItem(1066, "MenuQuit");
						}
						else
						{
							if(GetPlayer().QuestCompleted(39)=false)
							{
							ClearMenu();
							AddStaticItem(1183);
							AddStaticItem(3232);
							AddStaticItem(179, false);
							AddMenuItem(182, "NewDone");
							}
							else
							{
							ClearMenu();
							AddStaticItem(1185);
							AddStaticItem(179, false);
							AddMenuItem(1186, "MenuQuit");
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
		AddStaticItem(1187);
		AddStaticItem(3233);
		AddStaticItem(1188);
		AddStaticItem(179, false);
		AddMenuItem(182, "MenuQuit");
		GetPlayer().SetQuestCompleted(39);
		GetPlayer().AddExperience(2500);
		Item = Level.CreateEntity( 714 );
		GetPlayer().PickupItem( Item );
	}]

	NewMore1[()
	{
		ClearMenu();
		AddStaticItem(3234);
		AddStaticItem(179, false);
		AddMenuItem(182, "NewMore2");
	}]

	NewMore2[()
	{
		ClearMenu();
		AddStaticItem(1190);
		AddStaticItem(179, false);
		AddMenuItem(182, "NewMore3");
	}]

	NewMore3[()
	{
		ClearMenu();
		AddStaticItem(3235);
		AddStaticItem(179, false);
		AddMenuItem(1079, "NewAccepted");
		AddMenuItem(3236, "MenuQuit");
	}]

	NewAccepted[()
	{
		ClearMenu();
		GetPlayer().SetQuestAssigned(39);
		Quit();
	}]

	Done[()
	{
		ClearMenu();
		AddStaticItem(1192);
		AddStaticItem(3237);
		AddStaticItem(1194);
		AddStaticItem(179, false);
		AddMenuItem(182, "Next");
		GetPlayer().SetQuestCompleted(36);
		GetPlayer().AddExperience(1750);
		Item = Level.CreateEntity( 914 );
		GetPlayer().PickupItem( Item );
	}]

	Next[()
	{
		ClearMenu();
		AddStaticItem(1195);
		AddStaticItem(1087);
		AddStaticItem(1088);
		AddStaticItem(179, false);
		AddMenuItem(591, "MenuQuit");
	}]

	MoreHelp1[()
	{
		ClearMenu();
		AddStaticItem(1196);
		AddStaticItem(3238);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreHelp2");
	}]

	MoreHelp2[()
	{
		ClearMenu();
		AddStaticItem(3239);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreHelp3");
	}]

	MoreHelp3[()
	{
		ClearMenu();
		AddStaticItem(3240);
		AddStaticItem(179, false);
		AddMenuItem(796, "Accept");
		AddMenuItem(3236, "MenuQuit");
	}]

	Accept[()
	{
		GetPlayer().SetQuestAssigned(36);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}
