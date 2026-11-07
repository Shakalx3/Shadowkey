{
	Init[ (s)
	{
		AddStaticItem(2286);
		AddStaticItem(179, false);
		AddMenuItem(386, "Enter");
	} ]

	Enter[ (s)
	{
		Quit();
		Level.LoadLevel("fearfrst");
		GetPlayer().SetCameraStart( 15975, 1094, 0, 0, 174, 0 );
	} ]
}