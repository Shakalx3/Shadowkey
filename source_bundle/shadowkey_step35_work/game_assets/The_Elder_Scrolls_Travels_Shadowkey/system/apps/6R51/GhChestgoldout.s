{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem(1434);
		AddStaticItem(1435);
		AddStaticItem(179, false);
		AddMenuItem( 1436, "MenuQuit" );

		return;
	} ]


	MenuQuit[ (s)
	{
		Quit();
	} ]
}