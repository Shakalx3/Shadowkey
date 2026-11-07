{
	Init[()
	{
		AddStaticItem(3938);
		AddStaticItem(3939);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	MenuQuit[ ()
	{
		GetOpener().GetLoot();
	}]
}