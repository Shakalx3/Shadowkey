{
	Init[ (s)
	{
		AddStaticItem(3930);
		AddStaticItem(3931);
		AddStaticItem(179, false);
		AddMenuItem(386, "More1");
	}]

	More1[ (s)
	{
		ClearMenu();
		AddStaticItem(3932);
		AddStaticItem(3933);
		AddStaticItem(179, false);
		AddMenuItem(386, "More2");
	}]

	More2[ (s)
	{
		ClearMenu();
		AddStaticItem(3934);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	MenuQuit[ (s)
	{
		Quit();
		Level.saved_shadowdoor6 = 1;
	}]
}
