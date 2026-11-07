{
	Init[()
	{
		AddStaticItem(3081);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
		Level.ForceLoadLevel("broken1");
		GetPlayer().SetCameraStart( 16687, 19106, -1024, 0, 576, 0 );
	}]
}