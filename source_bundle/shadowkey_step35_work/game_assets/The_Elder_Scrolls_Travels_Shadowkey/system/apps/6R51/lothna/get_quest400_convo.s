{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem( 1914 );
		AddStaticItem( 179, false );
		AddMenuItem( 1915, "MenuQuit" );
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