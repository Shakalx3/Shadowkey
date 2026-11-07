{
	Init[()
	{
		AddStaticItem(3079);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
		Level.ForceLoadLevel("broken2");
		GetPlayer().SetCameraStart( 13440, 14976, 0 + 512, 0, 0, 0 );
	}]
}