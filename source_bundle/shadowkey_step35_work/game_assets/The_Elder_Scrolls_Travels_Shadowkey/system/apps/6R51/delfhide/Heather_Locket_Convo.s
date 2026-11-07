{
	Init[ (s)
	{
		if( GetPlayer().QuestCompleted(4) )
		{
			ClearMenu();
			AddStaticItem(836);
			AddStaticItem(179, false);
			AddMenuItem(837, "Quit");
		}
		else
		{
			if( GetPlayer().QuestAssigned(4) )
			{
				if( GetPlayer().HasItem("locket") )
				{
					ClearMenu();
					AddStaticItem(838);
					AddStaticItem(179, false);
					AddMenuItem(182, "CompletedMore");
					GetPlayer().SetQuestSolved(4);
				}
				else
				{
					ClearMenu();
					AddStaticItem(839);
					AddStaticItem(179, false);
					AddMenuItem(840, "Quit");
					AddMenuItem(841, "Quit");
				}
			}
			else
			{
				ClearMenu();
				AddStaticItem(3101);
				AddStaticItem(179, false);
				AddMenuItem(182, "QuestMore");
			}
		}
	} ]

	CompletedMore[ (s)
	{
		ClearMenu();
		AddStaticItem(3102);
		AddStaticItem(179, false);
		AddMenuItem(182, "CompletedMore2");
	} ]

	CompletedMore2[ (s)
	{
		ClearMenu();
		AddStaticItem(3103);
		AddStaticItem(179, false);
		AddMenuItem(182, "CompletedMore3");
	} ]

	CompletedMore3[ (s)
	{
		ClearMenu();
		AddStaticItem(845);
		AddStaticItem(179, false);
		AddMenuItem(591, "Quit");
		GetPlayer().SetQuestCompleted(4);
		GetPlayer().AddExperience(125);
		GetPlayer().saved_Heather = 1;
		Locket = GetPlayer().FindInventory("locket");
		GetPlayer().RemoveItem(Locket);
		heather=GetOpener();
		if (heather != null)
		{
			heather.DestroyObjectMirror( heather );
		}
	} ]

	QuestMore[ (s)
	{
		ClearMenu();
		AddStaticItem(846);
		AddStaticItem(179, false);
		AddMenuItem(848, "GetLocket");
		AddMenuItem(3104, "Quit");
	} ]

	GetLocket[ (s)
	{
		ClearMenu();
		AddStaticItem(849);
		AddStaticItem(179, false);
		AddMenuItem(182,"GetLocket2");
	} ]

	GetLocket2[ (s)
	{
		ClearMenu();
		AddStaticItem(3105);
		AddStaticItem(179, false);
		AddMenuItem(182,"GetLocket3");
	} ]

	GetLocket3[ (s)
	{
		if( GetPlayer().HasItem("locket") )
		{
			ClearMenu();
			AddStaticItem(851);
			AddStaticItem(179, false);
			AddMenuItem(3107, "CompletedMore");
			AddMenuItem(3106, "Quit");
		}
		else
	{
			ClearMenu();
			AddStaticItem(851);
			AddStaticItem(179, false);
			AddMenuItem(853, "AcceptQuest");
			AddMenuItem(3106, "Quit");
		}
	} ]

	AcceptQuest[ (s)
	{
		ClearMenu();
		AddStaticItem(3764);
		AddStaticItem(179, false);
		AddMenuItem(3765, "Quit");
		GetPlayer().SetQuestAssigned(4,true);
		GetOpener().DestroyObjectMirror( GetOpener() );
		GetPlayer().saved_Heather = 1;
	} ]
}
