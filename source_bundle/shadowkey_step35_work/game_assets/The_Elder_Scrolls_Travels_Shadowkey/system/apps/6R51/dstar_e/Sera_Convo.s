{
	Init[()
	{
		if(GetPlayer().QuestAssigned(41)=false)
		{
			ClearMenu();
			AddStaticItem(1021);
			AddStaticItem(1022);
			AddStaticItem(179, false);
			AddMenuItem(1023, "MoreHelp1");
		}
		else
		{
			if(GetPlayer().QuestSolved(41)=false)
			{
				ClearMenu();
				AddStaticItem(3435);
				AddStaticItem(3436);
				AddStaticItem(179, false);
				AddMenuItem(1025, "MenuQuit");
			}
			else
			{
				if(GetPlayer().QuestCompleted(41)=false)
				{
					ClearMenu();
					AddStaticItem(3437);
					AddStaticItem(1027);
					AddStaticItem(179, false);
					AddMenuItem(182, "HowMany");
				}
				else
				{
					ClearMenu();
					AddStaticItem(1028);
					AddStaticItem(1029);
					AddStaticItem(179, false);
					AddMenuItem(755, "MenuQuit");
				}
			}
		}
	}]

	HowMany[()
	{
		ClearMenu();
		AddStaticItem(1030);
		AddStaticItem(179, false);
		if(GetPlayer().FindInventory("herbs2") != null)
		{
			AddMenuItem(1031, "Herbs2");
		}
		else
		{
			if(GetPlayer().FindInventory("herbs5") != null)
			{
				AddMenuItem(1032, "Herbs5");
			}
			else
			{
				AddMenuItem(1033, "Herbs10");
			}
		}
	}]

	Herbs2[()
	{
		ClearMenu();
		AddStaticItem(3438);
		AddStaticItem(3439);
		AddStaticItem(1035);
		AddStaticItem(179, false);
		AddMenuItem(1036, "Done1");
	}]

	Herbs5[()
	{
		ClearMenu();
		AddStaticItem(3440);
		AddStaticItem(3441);
		AddStaticItem(1035);
		AddStaticItem(179, false);
		AddMenuItem(1036, "Done2");
	}]

	Herbs10[()
	{
		ClearMenu();
		AddStaticItem(3442);
		AddStaticItem(1039);
		AddStaticItem(179, false);
		AddMenuItem(1040, "Done3");
	}]

	Done1[()
	{
		ClearMenu();
		AddStaticItem(3443);
		AddStaticItem(179, false);
		AddMenuItem(591, "MenuQuit");
		berbs2 = GetPlayer().FindInventory("herbs2");
		GetPlayer().RemoveItem(berbs2);
		GetPlayer().SetQuestCompleted(41);
		GetPlayer().AddExperience(1700);
	}]

	Done2[()
	{
		ClearMenu();
		AddStaticItem(3444);
		AddStaticItem(179, false);
		AddMenuItem(591, "MenuQuit");
		berbs5 = GetPlayer().FindInventory("herbs5");
		GetPlayer().RemoveItem(berbs5);
		GetPlayer().SetQuestCompleted(41);
		GetPlayer().AddExperience(2200);
	}]

	Done3[()
	{
		ClearMenu();
		AddStaticItem(3445);
		AddStaticItem(179, false);
		AddMenuItem(591, "MenuQuit");
		berbs10 = GetPlayer().FindInventory("herbs10");
		GetPlayer().RemoveItem(berbs10);
		GetPlayer().SetQuestCompleted(41);
		GetPlayer().AddExperience(3000);

	}]

	MoreHelp1[()
	{
		ClearMenu();
		AddStaticItem(3446);
		AddStaticItem(1045);
		AddStaticItem(179, false);
		AddMenuItem(1046, "MoreHelp2");
	}]

	MoreHelp2[()
	{
		ClearMenu();
		AddStaticItem(3447);
		AddStaticItem(1048);
		AddStaticItem(179, false);
		AddMenuItem(3448, "MenuQuit");
		AddMenuItem(1050, "Accept");
	}]

	Accept[()
	{
		GetPlayer().SetQuestAssigned(41);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}
