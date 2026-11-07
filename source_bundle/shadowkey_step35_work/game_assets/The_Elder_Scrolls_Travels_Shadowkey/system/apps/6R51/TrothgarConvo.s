{

	Init[ (s)
	{
		if(GetPlayer().saved_EndGame = 1)
		{
			AddStaticItem(3981);
			AddStaticItem(179);
			AddMenuItem(834, "End1");
		}
		else
		{
			if( GetPlayer().QuestCompleted(0) )
			{
				ClearMenu();
				AddStaticItem(2566);
				AddStaticItem(179, false);
				AddMenuItem(2568, "BuyItems");
				AddMenuItem(2569, "SellItems");
				AddMenuItem(3697, "MenuQuit");
			}
			else
			{
				if( GetPlayer().QuestSolved(0) )
				{
					AddStaticItem( 2570);
					AddStaticItem( 2571);
					AddStaticItem(179, false);
					AddMenuItem(182, "MoreResponse");
				}
				else
				{
					if( GetPlayer().QuestAssigned(0) )
					{
						ClearMenu();
						AddStaticItem(2572);
						AddStaticItem(179, false);
						AddMenuItem(2573, "MenuQuit");
					}
					else
					{
						AddStaticItem(2574 );
						AddStaticItem(179, false);
						AddMenuItem( 2575, "YesResponse" );
						AddMenuItem( 2576, "MenuQuit" );
					}

				}
			}
		}
	} ]

	End1[()
	{
		ClearMenu();
		AddStaticItem(2566);
		AddStaticItem(179, false);
		AddMenuItem(2568, "BuyItems");
		AddMenuItem(2569, "SellItems");
		AddMenuItem(3697, "MenuQuit");
	}]


	MoreResponse [ (s)
	{
		//StatModXP(1500); 	// +500
		GetPlayer().AddExperience(400);
		GetPlayer().StatModGold(400); 	// +400
		GetPlayer().SetQuestCompleted(0,true);
		ClearMenu();
		AddStaticItem(2577);
		AddStaticItem(2578);
		AddStaticItem(2579);
		AddStaticItem(2580);
		AddStaticItem(179, false);
		AddMenuItem(2568, "BuyItems");
		AddMenuItem(2569, "SellItems");
		AddMenuItem(445, "MenuQuit");
	} ]

	YesResponse[ (s)
	{
		GetPlayer().SetQuestAssigned(0,true);
		ClearMenu();
		AddStaticItem(2582);
		AddStaticItem(179, false);
		AddMenuItem(198, "MenuQuit");
	} ]

	MenuQuit[ (s)
	{
		Quit();
	} ]

	BuyItems[ ()
	{
		Quit();
		GetPlayer().BuyFromMerchant();
	}]

	SellItems[ ()
	{
		Quit();
		GetPlayer().SellToMerchant();
	}]

	trothgarconvoBack[ ()
	{
		Quit();
	}]
}