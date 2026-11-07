{
	Init[ (s)
	{
		WitchTree = Level.GetEntity("wthtree");
		if (GetPlayer().QuestCompleted(14) = false)
		{
			if (GetPlayer().QuestAssigned(14) = false)
			{
				AddStaticItem( 1499 );
				AddStaticItem(179, false);
				AddMenuItem( 419, "GetQuest14" );
			}
			else
			{
				if (GetPlayer().QuestSolved(14) = false)
				{
					AddStaticItem( 1500 );
					AddStaticItem(179, false);
					AddMenuItem( 1501, "MenuQuit" );
				}
				else
				{
					if (GetPlayer().QuestCompleted(14) = false)
					{
						AddStaticItem(1494);
						AddStaticItem(179, false);
						AddMenuItem( 419, "LootMenu3" );
					}
				}
			}
		}
		else
		{
			if (GetPlayer().QuestCompleted(15) = false)
			{
				if (GetPlayer().QuestAssigned(15) = false)
				{
					AddStaticItem( 1502 );
					AddStaticItem(179, false);
					AddMenuItem( 419, "More15" );
				}
				else
				{
					if (GetPlayer().QuestSolved(15) = false)
					{
						AddStaticItem( 1525);
						AddStaticItem(179, false);
						AddMenuItem( 386, "MenuQuit" );
					}
					else
					{
						if (GetPlayer().QuestCompleted(15) = false)
						{
							AddStaticItem( 1496 );
							AddStaticItem(179, false);
							AddMenuItem( 419, "LootMenu4" );
						}
					}
				}
			}
			else
			{
				if (GetPlayer().QuestCompleted(16) = false)
				{
					if (GetPlayer().QuestAssigned(16) = false)
					{
						AddStaticItem( 1503 );
						AddStaticItem(179, false);
						AddMenuItem( 182, "More16" );
					}
					else
					{
						skey3 = GetPlayer().FindInventory("skey3");
						if (skey3 = null)
						{
							AddStaticItem( 1504 );
							AddStaticItem(179, false);
							AddMenuItem( 1505, "MenuQuit" );
						}
						else
						{
							AddStaticItem( 1497 );
							AddStaticItem(179, false);
							AddMenuItem( 182, "Mo16" );
						}
					}
				}
				else
				{
					AddStaticItem( 1508 );
					AddStaticItem(179, false);
					AddMenuItem( 1509, "Quit" );
				}
			}
		}
	} ]

	PreMoVisit[ ()
	{
		ClearMenu();
		AddStaticItem( 1498 );
		AddStaticItem(179, false);
		AddMenuItem( 182, "MoVisit" );
	}]

	MoVisit[ ()
	{
		ClearMenu();
		AddStaticItem( 1510 );
		AddStaticItem(179, false);
		AddMenuItem( 182, "MoVisit2" );
	}]

	MoVisit2[ ()
	{
		ClearMenu();
		AddStaticItem( 1511 );
		AddStaticItem(179, false);
		AddMenuItem( 182, "MoVisit3" );
	}]

	MoVisit3[ ()
	{
		ClearMenu();
		AddStaticItem( 1512 );
		AddStaticItem(179, false);
		AddMenuItem( 182, "MoVisit4" );
	}]

	MoVisit4[ ()
	{
		ClearMenu();
		AddStaticItem( 1514 );
		AddStaticItem(179, false);
		AddMenuItem( 1516, "FindOlpac" );
		AddMenuItem( 1515, "MenuQuit" );
	}]

	GetQuest14[ ()
	{
		ClearMenu();
		AddStaticItem( 1517 );
		AddStaticItem(179, false);
		AddMenuItem( 1518, "MenuQuit" );
		AddMenuItem( 3254, "PreMoVisit");
	}]

	FindOlpac[ ()
	{
		ClearMenu();
		AddStaticItem( 1519 );
		AddStaticItem(179, false);
		AddMenuItem( 182, "FindOlpacB" );
	}]

	FindOlpacB[ ()
	{
		ClearMenu();
		AddStaticItem( 1520 );
		AddStaticItem(179, false);
		AddMenuItem( 1521, "QuestAssigned" );
		AddMenuItem( 1522, "QuestAssigned" );
		AddMenuItem( 1515, "Quit" );
	}]

	QuestAssigned[()
	{
		ClearMenu();
		GetPlayer().SetQuestAssigned(14);
		Quit();
	}]

	More15[ ()
	{
		ClearMenu();
		AddStaticItem( 1523);
		AddStaticItem(179, false);
		AddMenuItem( 1515, "MenuQuit" );
		AddMenuItem( 1524, "Accept15" );
	}]

	Accept15[ ()
	{
		ClearMenu();
		GetPlayer().SetQuestAssigned(15);
		AddStaticItem( 1525);
		AddStaticItem(179, false);
		AddMenuItem( 386, "MenuQuit" );
	}]

	More16[ ()
	{
		ClearMenu();
		AddStaticItem( 1526);
		AddStaticItem(179, false);
		AddMenuItem( 1515, "MenuQuit" );
		AddMenuItem( 1375, "ShowSKey3" );
	}]

	ShowSKey3[ ()
	{
		ClearMenu();
		GetPlayer().SetQuestAssigned(16);
		AddStaticItem( 1527);
		AddStaticItem(179, false);
		AddMenuItem( 182, "MoreSKey3" );
	}]

	MoreSKey3[ ()
	{
		ClearMenu();
		AddStaticItem( 1528);
		AddStaticItem( 179, false );
		AddMenuItem( 182, "MoreSKey3B" );
	}]

	MoreSKey3B[ ()
	{
		ClearMenu();
		AddStaticItem( 1529);
		AddStaticItem( 179, false );
		AddMenuItem( 386, "MenuQuit" );
	}]


	LootMenu3[ (s)
	{
		ClearMenu();
		AddStaticItem(1530);
		AddStaticItem(179, false);
		AddMenuItem(1531, "WTGiveDust");
		AddMenuItem(1532, "WTGiveCrossbow");
	} ]

	LootMenu4[ (s)
	{
		ClearMenu();
		AddStaticItem(1533);
		AddStaticItem(179, false);
		AddMenuItem(248, "WTGiveLth");
		AddMenuItem(346, "WTGiveStlBts");
	} ]

	Mo16[ ()
	{
		ClearMenu();
		AddStaticItem( 1534 );
		AddStaticItem(179, false);
		AddMenuItem( 182, "Mo16B" );
	}]

	Mo16B[ ()
	{
		ClearMenu();
		AddStaticItem( 1535 );
		AddStaticItem(179, false);
		AddMenuItem( 1536, "GetReward16" );
	}]

	GetReward16[ ()
	{
		ClearMenu();
		AddStaticItem( 1537 );
		AddStaticItem(179, false);
		AddMenuItem( 182, "LootMenu5" );

	}]

	LootMenu5[ (s)
	{
		ClearMenu();
		AddStaticItem(1538);
		AddStaticItem(1539);
		AddStaticItem(179, false);
		AddMenuItem( 419, "LootMenu5B" );
	} ]


	LootMenu5B[ (s)
	{
		ClearMenu();
		GetPlayer().AddExperience(850);
		Item = Level.CreateEntity( 714 );
		GetPlayer().PickupItem(Item);
		GetPlayer().SetQuestCompleted(16);
		AddStaticItem(1540);
		AddStaticItem(179, false);
		AddMenuItem( 517, "MenuQuit" );
	} ]

	WTGiveDust[ (s)
	{
		AddStaticItem(3255);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
		GetPlayer().SetQuestCompleted(14);
		GetPlayer().AddExperience(600);
		Item = Level.CreateEntity( 4002 );
		GetPlayer().PickupItem(Item);
		Quit();
	}]

	WTGiveCrossbow[ (s)
	{
		AddStaticItem(3256);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
		GetPlayer().SetQuestCompleted(14);
		GetPlayer().AddExperience(600);
		Item = Level.CreateEntity( 515 );
		GetPlayer().PickupItem(Item);
		Quit();
	}]

	WTGiveLth[ (s)
	{
		AddStaticItem(3257);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
		GetPlayer().SetQuestCompleted(15);
		GetPlayer().AddExperience(700);
		Item = Level.CreateEntity( 636 );
		GetPlayer().PickupItem(Item);
		Quit();
	}]

	WTGiveStlBts[ (s)
	{
		AddStaticItem(3258);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
		GetPlayer().SetQuestCompleted(15);
		GetPlayer().AddExperience(700);
		Item = Level.CreateEntity( 610 );
		GetPlayer().PickupItem(Item);
		Quit();
	}]

	MenuQuit[ (s)
	{
		Quit();
	} ]
}