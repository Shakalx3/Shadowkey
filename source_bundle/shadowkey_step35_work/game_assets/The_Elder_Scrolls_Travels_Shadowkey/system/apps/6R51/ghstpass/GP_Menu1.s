{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem(1438 );
		AddStaticItem(179, false);
		AddMenuItem( 419, "Msg2" );
	} ]

	Msg2[ (s)
	{
		ClearMenu();
		AddStaticItem(1439);
		AddStaticItem(179, false);
		AddMenuItem(182, "Msg3");
	} ]

	Msg3[ (s)
	{
		ClearMenu();
		AddStaticItem(1440);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	} ]



	MenuQuit[ (s)
	{
		Quit();
	} ]
}