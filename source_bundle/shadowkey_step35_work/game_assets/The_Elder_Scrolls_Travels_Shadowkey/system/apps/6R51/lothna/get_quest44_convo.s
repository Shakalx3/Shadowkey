{
	Init[ (s)
	{
		if (GetPlayer().QuestSolved(44) = true)
		{
			ClearMenu();
			AddStaticItem( 1916 );
			AddStaticItem( 179, false );
			AddMenuItem(182,"Beat44");
			return;
		}
		if (Level.saved_AssQuest44 = 1)
		{
			ClearMenu();
			AddStaticItem( 1914 );
			AddStaticItem( 179, false );
			AddMenuItem( 1915, "MenuQuit" );
			return;
		}
		else
		{
			ClearMenu();
			AddStaticItem( 1917 );
			AddStaticItem( 1918);
			AddStaticItem( 179, false );
			AddMenuItem(182,"Mo44");
			return;
		}
	} ]

	Beat44[ (s)
	{
		GetPlayer().SetQuestCompleted(44);
		GetPlayer().StatModXP(2250);
		ClearMenu();
		AddStaticItem( 1919 );
		AddStaticItem( 179, false );
		AddMenuItem(386,"RemoveGhost");
	} ]

	RemoveGhost[ (s)
	{
		ghost=Level.GetEntity("pilgrm");
		ghost.DestroyObjectMirror(ghost);
		Quit();
	} ]

	Mo44[ (s)
	{
		ClearMenu();
		AddStaticItem( 1920 );
		AddStaticItem( 179, false );
		AddMenuItem(1910,"MenuQuit");
		GetPlayer().SetQuestAssigned(44);
		Level.saved_AssQuest44 = 1;
	} ]

	MenuQuit[ (s)
	{
		Quit();
	} ]
}