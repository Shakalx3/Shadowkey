{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem( 1446);
		AddStaticItem(179, false);
		AddMenuItem( 419, "Msg2" );
	} ]

	Msg2[ (s)
	{
		ClearMenu();
		AddStaticItem(1447);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	} ]


	MenuQuit[ (s)
	{
		Quit();
	} ]
}