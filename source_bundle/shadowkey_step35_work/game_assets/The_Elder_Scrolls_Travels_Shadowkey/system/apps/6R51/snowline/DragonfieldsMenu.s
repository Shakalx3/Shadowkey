{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem(2285);
		AddStaticItem(179, false);
		AddMenuItem(386, "Enter");
	} ]

	Enter[ (s)
	{
		Quit();
		Level.LoadLevel("drgnfld");
		GetPlayer().SetCameraStart( 16512, 31104, -2792, 0, -32256, 0 );
	} ]
}