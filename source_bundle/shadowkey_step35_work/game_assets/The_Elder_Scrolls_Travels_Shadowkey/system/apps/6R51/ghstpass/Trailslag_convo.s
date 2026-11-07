{
	Init[ (s)
	{
		zomb1 = Level.GetEntity("zomb1");
		zomb2 = Level.GetEntity("zomb2");
		if ( (zomb1 = null) and (zomb2 = null))
		{
			Level.save_bZombiesKilled = true;
			GetPlayer().SetQuestSolved(14);
		}
		
		if (Level.save_bZombiesKilled = true)
		{
			if(Level.GetEntity("olpac").saved_Killed = 0)
			{
				KilledZombies();
			}
			else
			{
				if (Level.saved_Olpac = 0)
				{
					if (GetPlayer().QuestAssigned(13) = false)
					{
						Level.Log("I'm trying to check and see if you have Quest 13 Assigned");
						ClearMenu();
						AddStaticItem( 1454 );
						AddStaticItem(179, false);
						AddMenuItem( 182, "MoPack" );
					}
					else
					{
						if (GetPlayer().QuestSolved(13) = false)
						{
							Level.Log("You have Quest 13 Assigned");
							AddStaticItem( 1455 );
							AddStaticItem(179, false);
							AddMenuItem( 1456, "MenuQuit" );
						}
						else
						{
							if(Level.saved_OlpacTwo = 0)
							{
								AddStaticItem( 1457 );
								AddStaticItem(179, false);
								AddMenuItem( 182, "More13" );
								Level.saved_OlpacTwo = 1;
							}
							else
							{
								Pack = GetPlayer().FindInventory("olpack");
								if(Pack != null)
								{
									AddStaticItem(3894);
									AddStaticItem(179, false);
									AddMenuItem( 182, "Finish13" );
								}
								else
								{
									AddStaticItem(3896);
									AddStaticItem(179);
									AddMenuItem(3895, "Quit");
								}
							}
						}
					}
				}
			}
		}
		else
		{
			ClearMenu();
			AddStaticItem( 1458 );
			AddStaticItem(179, false);
			AddMenuItem( 1459, "MenuQuit" );
		}
	} ]

	MoPack[ ()
	{
		ClearMenu();
		AddStaticItem( 1460 );
		AddStaticItem(179, false);
		AddMenuItem( 182, "MoPack2" );
	}]

	MoPack2[ ()
	{
		ClearMenu();
		AddStaticItem( 1461 );
		AddStaticItem(179, false);
		AddMenuItem( 182, "MoPack3" );
	}]

	MoPack3[ ()
	{
		ClearMenu();
		AddStaticItem( 1462 );
		AddStaticItem(179, false);
		AddMenuItem( 831, "Accept13" );
		AddMenuItem( 1463, "MenuQuit" );
	}]

	KilledZombies[ ()
	{
		GetPlayer().SetQuestSolved(14);
		ClearMenu();
		AddStaticItem( 1464 );
		AddStaticItem(179, false);
		AddMenuItem( 182, "GetQuest13" );
	}]

	GetQuest13[ ()
	{
		ClearMenu();
		AddStaticItem( 1465 );
		AddStaticItem(179, false);
		AddMenuItem( 182, "Ask13" );
	}]

	Ask13[ ()
	{
		ClearMenu();
		AddStaticItem( 1467 );
		AddStaticItem(179, false);
		AddMenuItem( 182, "AskMore13" );
	}]

	AskMore13[()
	{
		ClearMenu();
		AddStaticItem(3252);
		AddStaticItem(179, false);
		AddMenuItem( 182, "Want13" );
	}]

	Want13[()
	{
		ClearMenu();
		AddStaticItem(3253);
		AddStaticItem(179, false);
		AddMenuItem( 1456, "Accept13" );
		AddMenuItem( 1466, "MenuQuit" );
	}]

	Accept13[ ()
	{
		Level.GetEntity("olpac").saved_Killed = 1;
		GetPlayer().SetQuestAssigned(13);
		ClearMenu();
		Quit();
	}]

	More13[ ()
	{
		ClearMenu();
		AddStaticItem( 1468);
		AddStaticItem(179, false);
		AddMenuItem( 182, "More13B" );
	}]

	More13B[ ()
	{
		ClearMenu();
		AddStaticItem( 1470);
		AddStaticItem(179, false);
		AddMenuItem( 3893, "Quit" );
		GetPlayer().SetGold( GetPlayer().GetGold() + 250 );
	}]

	Finish13[ ()
	{
		ClearMenu();
		AddStaticItem( 1469);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
		GetPlayer().SetGold( GetPlayer().GetGold() + 750 );
		GetPlayer().StatModXP(600);
		GetPlayer().SetQuestCompleted(13);
		Item = Level.CreateEntity(4710);
		GetPlayer().PickupItem( Item );
		Item = Level.CreateEntity(4710);
		GetPlayer().PickupItem( Item );
		Pack = GetPlayer().FindInventory("olpack");
		if(Pack != null)
		{
			GetPlayer().RemoveItem(Pack);
		}
		trailsag = Level.GetEntity("olpac");
		trailsag.DestroyObjectMirror(trailsag);
	}]

	MenuQuit[ (s)
	{
		Quit();
	} ]
}