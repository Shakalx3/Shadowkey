{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem( 1448);
		AddStaticItem(179, false);
		AddMenuItem( 386, "MenuQuit" );
	} ]


	MenuQuit[ (s)
	{
		Quit();
		Level.LoadLevel("snowline");
		GetPlayer().SetCameraStart( 2688, 6016, -2944, 0, 11473, 0 );
	} ]
}