{
	Init[ (s)
	{
		//if (GetPlayer().GetLevel() < 13)
		//{
		//	ClearMenu();
		//	AddStaticItem(1475);
		//	AddStaticItem(179, false);
		//	AddMenuItem(1476);
		//	AddMenuItem(1477);
		//}

		if (GetPlayer().QuestCompleted(17) = false)
		{
			if (GetPlayer().QuestAssigned(17) = false)
			{
				ClearMenu();
				AddStaticItem( 1478 );
				AddStaticItem(179, false);
				AddMenuItem( 1480, "GetCameo" );
				AddMenuItem( 1479, "MenuQuit" );
				return;
			}
		}

		if (GetPlayer().QuestCompleted(17) = true)
		{
			if (GetPlayer().QuestSolved(17) = false)
			{
				ClearMenu();
				AddStaticItem( 1481 );
				AddStaticItem(179, false);
				AddMenuItem( 182, "Beat17" );
				return;
			}
		}

		if (GetPlayer().QuestAssigned(17) = true)
		{
			if (GetPlayer().QuestSolved(17) = false)
			{
				ClearMenu();
				AddStaticItem( 1482 );
				AddStaticItem(179, false);
				AddMenuItem( 1483, "MenuQuit" );
				return;
			}
		}

		if (GetPlayer().QuestSolved(17) = true)
		{
			ClearMenu();
			AddStaticItem( 1484 );
			AddStaticItem(179, false);
			AddMenuItem( 834, "MenuQuit" );
		}

	} ]

	GetCameo[ (s)
	{
		ClearMenu();
		AddStaticItem( 1485 );
		AddStaticItem(179, false);
		AddMenuItem( 182, "More17" );
	}]

	More17[ (s)
	{
		ClearMenu();
		AddStaticItem( 1486 );
		AddStaticItem(179, false);
		AddMenuItem( 182, "More17B" );
	}]

	More17B[ (s)
	{
		ClearMenu();
		AddStaticItem( 1487 );
		AddStaticItem(179, false);
		AddMenuItem( 182, "More17C" );
	}]

	More17C[ (s)
	{
		ClearMenu();
		AddStaticItem( 1488 );
		AddStaticItem(179, false);
		AddMenuItem( 1490, "Accept17" );
		AddMenuItem( 1489, "MenuQuit" );
	}]

	Accept17[ (s)
	{
		GetPlayer().SetQuestAssigned(17);
		if (GetPlayer().GetLevel() < 13)
		{
			ClearMenu();
			AddStaticItem( 1491 );
			AddStaticItem(179, false);
			AddMenuItem( 1483, "MenuQuit" );
		}
		else
		{
			Quit();
		}
	} ]

	Beat17[ (s)
	{
		GetPlayer().SetQuestSolved(15);
		GetPlayer().SetQuestSolved(17);
		GetPlayer().StatModXP(600);
		Violet = Level.GetEntity("violet");
		Violet.DestroyObjectMirror(Violet);
		ClearMenu();
		AddStaticItem( 1492 );
		AddStaticItem(179, false);
		AddMenuItem( 834, "MenuQuit" );
	} ]


	MenuQuit[ (s)
	{
		Quit();
	} ]
}