{

	Init[ (s)
	{
		Wine = GetPlayer().FindInventory("winebot");
		if (GetPlayer().QuestAssigned(12) = false) { WineTo(1); }
		if ((GetPlayer().QuestAssigned(12) = true) and (GetPlayer().QuestSolved(12) = false)) { WineTo(2); }
		if (GetPlayer().QuestCompleted(12) = true) { WineTo(5); }

	}]

	WineTo[ (bob)
	{
	switch(bob)
		{
			case 1
			{
				AddStaticItem(731);
				AddStaticItem(179, false);
				AddMenuItem(182, "NoQuest1");

				return;
		        }
		        case 2
			{
				Wine = GetPlayer().FindInventory("winebot");
				if( Wine != null )
				{
					AddStaticItem(729);
					AddStaticItem(179, false);
					AddMenuItem(182, "HasWine1");
				}
				else
				{
					AddStaticItem(730);
					AddStaticItem(179, false);
					AddMenuItem(182, "NoWine1");
					return;
				}
		        }
		        case 5
			{
				AddStaticItem(732);
				AddStaticItem(179, false);
				AddMenuItem(3590, "Quit");
				return;
		        }
		}
	}]

	HasWine0[ (s)
	{
		ClearMenu();
		AddStaticItem(729);
		AddStaticItem(179, false);
		AddMenuItem(182, "HasWine1");
		GetPlayer().SetQuestAssigned( 12 );
	}]

	HasWine1[ (s)
{
		ClearMenu();
		AddStaticItem(733);
		AddStaticItem(179, false);
		AddMenuItem(182, "HasWine2");
	} ]

	HasWine2[ (s)
	{
		ClearMenu();
		AddStaticItem(734);
		AddStaticItem(179, false);
		AddMenuItem(182, "HasWine3");
	} ]

	HasWine3[ (s)
	{
		ClearMenu();
		AddStaticItem(735);
		AddStaticItem(179, false);
		AddMenuItem(182, "HasWine4");
	} ]

	HasWine4[ (s)
	{
		ClearMenu();
		AddStaticItem(736);
		AddStaticItem(179, false);
		AddMenuItem(3591, "Quit");
		GetPlayer().SetGold( GetPlayer().GetGold() + 117 );
		GetPlayer().AddExperience( 125 );
		GetPlayer().SetQuestCompleted(12);
		GetPlayer().SetQuestSolved(12);
		Wine = GetPlayer().FindInventory("winebot");
		GetPlayer().RemoveItem(Wine);
	} ]

	NoWine1[ (s)
	{
		ClearMenu();
		AddStaticItem(737);
		AddStaticItem(179, false);
		AddMenuItem(3592, "Quit");
	} ]

	NoQuest1[ (s)
	{
		ClearMenu();
		AddStaticItem(3593);
		AddStaticItem(179, false);
		AddMenuItem(182, "NoQuest2");
	} ]

	NoQuest2[ (s)
	{
		ClearMenu();
		AddStaticItem(3594);
		AddStaticItem(179, false);
		AddMenuItem(182, "NoQuest3");
	} ]

	NoQuest3[ (s)
	{
		ClearMenu();
		AddStaticItem(3595);
		AddStaticItem(179, false);
		AddMenuItem(182, "NoQuest4");
	} ]

	NoQuest4[ (s)
	{
		Wine = GetPlayer().FindInventory("winebot");
		if( Wine != null )
		{
			ClearMenu();
			AddStaticItem(3596);
			AddStaticItem(179, false);
			AddMenuItem(3597, "Quit");
			AddMenuItem(3919, "HasWine0");
		}
		else
		{
			ClearMenu();
			AddStaticItem(3596);
			AddStaticItem(179, false);
			AddMenuItem(3597, "Quit");
			AddMenuItem(744, "AcceptQuest");
		}
	} ]

	AcceptQuest[ (s)
	{
		GetPlayer().SetQuestAssigned( 12 );
		Quit();
	} ]
}
