{
	Init[ ()
	{
		ClearMenu();
		AddStaticItem(1158);
		AddStaticItem(1159);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	//More[ ()
	//{
	//	ClearMenu();
	//	AddStaticItem(1160);
	//	AddStaticItem(179, false);
	//	AddMenuItem(386, "MenuQuit");
	//}]

	MenuQuit[ ()
	{
		Quit();
	}]

}