{

	Init[ (s)
	{
		if(Level.EndGame_Trinket = 1)
		{
			AddStaticItem(3995);
			AddStaticItem(179);
			AddMenuItem(3996, "Quit");
			AddMenuItem(3997, "Quit");
		}
		else
		{
			if(GetPlayer().saved_EndGame = 1)
			{
				AddStaticItem(3987);
				AddStaticItem(179);
				AddMenuItem(3988, "End1");
			}
			else
			{
				if( GetPlayer().QuestAssigned(2) )
				{
					ClearMenu();
					AddStaticItem(2543);
					AddStaticItem(2544);
					AddStaticItem(2545);
					AddStaticItem(179, false);
					AddMenuItem(2546, "MenuQuit");
					Level.saved_Trinket = 1;
				}
				else
				{
					if( GetPlayer().QuestAssigned(1) )
					{
						ClearMenu();
						AddStaticItem( 2547);
						AddStaticItem( 2548);
						AddStaticItem( 2549);
						AddStaticItem( 2550);
						AddStaticItem(179, false);
						AddMenuItem(2551, "MoreResponse");
					}
					else
					{
						ClearMenu();
						AddStaticItem(2552 );
						AddStaticItem(2553 );
						AddStaticItem(2554 );
						AddStaticItem(2555);
						AddStaticItem( 179, false );
						AddMenuItem( 2556, "MenuQuit" );
					}
				}
			}
		}
	} ]

	End1[()
	{
		ClearMenu();
		AddStaticItem(3989);
		AddStaticItem(179);
		AddMenuItem(3990, "End2");
	}]

	End2[()
	{
		ClearMenu();
		AddStaticItem(3991);
		AddStaticItem(179);
		AddMenuItem(3992, "End3");
	}]

	End3[()
	{
		ClearMenu();
		AddStaticItem(3993);
		AddStaticItem(179);
		AddMenuItem(3994, "Quit");
		Level.EndGame_Trinket = 1;
	}]

	MoreResponse [ (s)
	{

		ClearMenu();
		AddStaticItem(2557);
		AddStaticItem(2558);
		AddStaticItem(2559);
		AddStaticItem(2560);
		AddStaticItem(179, false);
		AddMenuItem(796, "Trinket2");

	} ]

	Trinket2[ (s)
	{
		ClearMenu();
		AddStaticItem(2561);
		AddStaticItem(2562);
		AddStaticItem(2563);
		AddStaticItem(2564);
		AddStaticItem(179, false);
		AddMenuItem(2565, "MenuQuit");
	} ]

	MenuQuit[ (s)
	{
		Quit();
	} ]
}