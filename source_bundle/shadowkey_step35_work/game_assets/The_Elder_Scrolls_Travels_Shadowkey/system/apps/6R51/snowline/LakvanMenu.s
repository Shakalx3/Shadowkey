{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem(2290);
		AddStaticItem(179, false);
		AddMenuItem(386, "Enter");
	} ]

	Enter[ (s)
	{
		Quit();
		Level.LoadLevel("lakvan");
		GetPlayer().SetCameraStart( 16507, 1406, 0, 0, -221, 0 );
	} ]
}