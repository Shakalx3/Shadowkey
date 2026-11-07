{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem(1947);
		AddStaticItem(179, false);
		AddMenuItem( 386, "MenuQuit" );
		Level.saved_SawPilgrim = 1;
	} ]

	MenuQuit[ (s)
	{
		Quit();
	} ]
}