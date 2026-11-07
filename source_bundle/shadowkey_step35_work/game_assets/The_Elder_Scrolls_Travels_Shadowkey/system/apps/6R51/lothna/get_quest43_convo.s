{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem( 1904 );
		AddStaticItem( 179, false );
		AddMenuItem( 1905, "Quest43" );
	} ]

	Quest43[ ()
	{
		ClearMenu();
		AddStaticItem( 1906);
		AddStaticItem( 1907 );
		AddStaticItem( 179, false );
		AddMenuItem( 182, "Quest43B" );
	}]

	Quest43B[ ()
	{
		ClearMenu();
		AddStaticItem( 1908);
		AddStaticItem( 179, false );
		AddMenuItem( 182, "Quest43C" );
	}]

	Quest43C[ ()
	{
		ClearMenu();
		AddStaticItem( 1909);
		AddStaticItem( 179, false );
		AddMenuItem( 1910, "Accept43" );
		AddMenuItem( 1515, "MenuQuit" );
	}]

	Accept43[ ()
	{
		GetPlayer().SetQuestAssigned(43);
		Level.saved_TookQuest43 = 1;
		Level.saved_Quest43Done = 9;

		ClearMenu();
		AddStaticItem( 1911);
		AddStaticItem( 179, false );
		AddMenuItem( 182, "Accept43B" );
	}]

	Accept43B[ ()
	{
		ClearMenu();
		AddStaticItem( 1912);
		AddStaticItem( 179, false );
		AddMenuItem( 182, "Accept43C" );
	}]

	Accept43C[ ()
	{
		ClearMenu();
		AddStaticItem( 1913);
		AddStaticItem( 179, false );
		AddMenuItem( 386, "MenuQuit" );
	}]

	MenuQuit[ (s)
	{
		Quit();
	} ]
}