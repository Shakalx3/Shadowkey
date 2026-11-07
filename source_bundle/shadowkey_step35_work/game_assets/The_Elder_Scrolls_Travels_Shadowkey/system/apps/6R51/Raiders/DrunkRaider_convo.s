{
	Init[ ()
	{

		ClearMenu();
		AddStaticItem(3288);
		AddStaticItem(3289);
		AddStaticItem(179, false);
		AddMenuItem(182, "More1");
	}]

	More1[ ()
	{
		ClearMenu();
		AddStaticItem(3290);
		AddStaticItem(3291);
		AddStaticItem(179, false);
		AddMenuItem(1082, "MenuQuit");
	}]

	MenuQuit[ ()
	{
		Quit();
	}]
}