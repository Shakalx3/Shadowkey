{
	Init[ (s)
	{
		LCDoRitual();
	} ]

	LCDoRitual[ (s)
	{

		ClearMenu();
		AddStaticItem( 1938 );
		AddStaticItem(179, false);
		AddMenuItem( 386, "More1" );

	}]
	More1[ (s)
	{
		ClearMenu();
		AddStaticItem( 1938 );
		AddStaticItem(179, false);
		AddMenuItem( 386, "More2" );
	}]

	More2[ (s)
	{
		ClearMenu();
		AddStaticItem( 1940 );
		AddStaticItem(179, false);
		AddMenuItem( 386, "More3" );
	}]

	More3[ (s)
	{
		ClearMenu();
		AddStaticItem( 1941 );
		AddStaticItem(179, false);
		AddMenuItem( 1942, "More4" );
	}]

	More4[ (s)
	{
		ClearMenu();
		AddStaticItem( 1943 );
		AddStaticItem(179, false);
		AddMenuItem( 1944, "LCFinishedRitual" );
	}]

	LCFinishedRitual[ (s)
	{
		ClearMenu();
		Level.saved_DeadGone = 1;
		GetPlayer().SetQuestSolved(44);
		AddStaticItem( 1945 );
		AddStaticItem(179, false);
		AddMenuItem( 1946, "CreateWight" );
		Level.saved_DeadBeGone = 1;
	}]

	CreateWight[ (s)
	{
		if (Level.saved_madewight = 0)
		{
			Level.fight41.SetActive(true);
			Level.fight41.SpawnEncounter("battle41");
			Level.saved_madewight=1;
		}
		ClearMenu();
		Quit();
	}]

	MenuQuit[ (s)
	{
		Quit();
	} ]
}