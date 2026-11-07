{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem(ParseActionText(3022));
		AddStaticItem(179, false);
		AddMenuItem(182, "Tactics");
	}]

	Tactics[ (s)
	{
		ClearMenu();
		AddStaticItem(ParseActionText(3023));
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
	}]

	//More_Ins[ ()
	//{
	//	ClearMenu();
	//	AddStaticItem(3033);
	//	AddStaticItem(179, false);
	//	AddMenuItem(182, "More");
	//}]

	More[ (s)
	{
		ClearMenu();
		AddStaticItem(ParseActionText(3024));
		AddStaticItem(179, false);
		AddMenuItem(783, "MenuQuit");
	}]

	//More_Ins2[()
	//{
	//	ClearMenu();
	//	AddStaticItem(3034);
	//	AddStaticItem(179, false);
	//	AddMenuItem(783, "MenuQuit");
	//}]

	MenuQuit[ (s)
	{
		Quit();
	}]
}