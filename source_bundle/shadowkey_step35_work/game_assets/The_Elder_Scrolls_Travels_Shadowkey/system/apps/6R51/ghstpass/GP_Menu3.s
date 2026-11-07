{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem( 1443 );
		AddStaticItem(179, false);
		AddMenuItem( 419, "More" );
	} ]

	More[ (s)
	{
		ClearMenu();
		AddStaticItem(1444);
		AddStaticItem(1445);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	} ]


	MenuQuit[ (s)
	{
		Quit();
	} ]
}