{
	Init[ (s)
	{
		ClearMenu();

		AddStaticItem( 1900 );
		AddStaticItem(179, false);
		AddMenuItem( 386, "MenuQuit" );
	} ]

	MenuQuit[ (s)
	{
		Quit();
	} ]
}