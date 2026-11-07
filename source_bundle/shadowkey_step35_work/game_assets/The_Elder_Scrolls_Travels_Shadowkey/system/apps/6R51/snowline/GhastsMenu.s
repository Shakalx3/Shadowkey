{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem(2289);
		AddStaticItem(179, false);
		AddMenuItem(386, "Enter");
	} ]

	Enter[ (s)
	{
		Quit();
		Level.LoadLevel("ghstpass");
		GetPlayer().SetCameraStart( 27802, 4793, -2680, 0, -16150, 0 );
	} ]
}