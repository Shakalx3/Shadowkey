{
	Init[ (s)
	{
		ClearMenu();

		AddStaticItem( 1926 );
		AddStaticItem(179, false);
		AddMenuItem( 1902, "MenuQuit" );
	} ]

	MenuQuit[ (s)
	{
		Quit();
	} ]
}