{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem(2502);
		AddStaticItem(179, false);
		AddMenuItem(ParseActionText(2995), "FirstInfo");
	}]

	FirstInfo[ (s)
	{
		ClearMenu();
		AddStaticItem(ParseActionText(2996));
		AddStaticItem(179, false);
		AddMenuItem(ParseActionText(2995), "MoreInfo");
	}]

	MoreInfo[ (s)
	{
		ClearMenu();
		AddStaticItem(ParseActionText(2997));
		AddStaticItem(179, false);
		AddMenuItem(386, "NextInfo");
	}]

	NextInfo[ ()
	{
		ClearMenu();
		AddStaticItem(ParseActionText(2999));
		AddStaticItem(179, false);
		AddMenuItem(386, "FinalInfo");
	}]

	FinalInfo[()
	{
		ClearMenu();
		AddStaticItem(ParseActionText(3000));
		AddStaticItem(179, false);
		AddMenuItem(386, "FinalInfo2");
	}]

	FinalInfo2[()
	{
		ClearMenu();
		AddStaticItem(ParseActionText(3748));
		AddStaticItem(179, false);
		AddMenuItem(3001, "MenuQuit");
	}]

	MenuQuit[ (s)
	{
		Quit();
	}]
}