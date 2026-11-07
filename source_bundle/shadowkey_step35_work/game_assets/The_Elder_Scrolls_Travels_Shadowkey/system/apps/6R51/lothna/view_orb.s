{
	Init[ (s)
	{
		ClearMenu();

		AddStaticItem( 1963 );
		AddStaticItem(179, false);
		AddMenuItem( 386, "MenuQuit" );
	} ]

	MenuQuit[ (s)
	{
		Quit();
	} ]
}