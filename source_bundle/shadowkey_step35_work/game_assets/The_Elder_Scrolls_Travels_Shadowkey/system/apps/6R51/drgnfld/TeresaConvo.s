{
	Init[ (s)
	{
		Level.Log("Teresa Init");
		if( GetPlayer().QuestAssigned(31) = false )
		{
			ClearMenu();
			AddStaticItem(948);
			AddStaticItem(179, false);
			AddMenuItem(182, "Teresa1");
		}
		else
		{
			if( GetPlayer().QuestSolved(31) = false )
			{
				ClearMenu();
				AddStaticItem(949);
				AddStaticItem(179, false);
				AddMenuItem(950, "Quit");
			}
			else
			{
				if( GetPlayer().QuestCompleted(31) = false )
				{
					ClearMenu();
					AddStaticItem(951);
					AddStaticItem(179, false);
					AddMenuItem(182, "Solved");
				}
				else
				{
					AddStaticItem(952);
					AddStaticItem(179, false);
					AddMenuItem(953, "Quit");
				}
			}
		}
	} ]

	Teresa1[ (s)
	{
		ClearMenu();
		AddStaticItem(954);
		AddStaticItem(179, false);
		AddMenuItem(182, "Teresa2");
	} ]

	Teresa2[ (s)
	{
		ClearMenu();
		AddStaticItem(955);
		AddStaticItem(179, false);
		AddMenuItem(956, "Accept");
		AddMenuItem(378, "Quit");
	} ]

	Accept[ (s)
	{
		GetPlayer().SetQuestAssigned(31);
		Quit();
	} ]

	Solved[ (s)
	{
		ClearMenu();
		Door = Level.GetEntity("LGate");
		Door.OpenDoor("Open Door");
		Door = Level.GetEntity("RGate");
		Door.OpenDoor("Open Door");
		GetPlayer().SetQuestCompleted(31);
		GetPlayer().AddExperience(1500);
		AddStaticItem(957);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
	} ]
}