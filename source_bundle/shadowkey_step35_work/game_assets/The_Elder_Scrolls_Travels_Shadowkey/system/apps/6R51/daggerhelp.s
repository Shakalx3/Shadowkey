{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem(ParseActionText(3002));
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
		AddMenuItem(ParseActionText(3003), "KeyMenu1");
	}]

	KeyMenu1[ ()
	{
		ClearMenu();
		AddStaticItem(ParseActionText(3004));
		AddStaticItem(ParseActionText(3005));
		AddStaticItem(ParseActionText(3006));
		AddStaticItem(ParseActionText(3007));
		AddStaticItem(ParseActionText(3008));
		AddStaticItem(ParseActionText(3009));
		AddStaticItem(179, false);
		AddMenuItem(386, "KeyMenu2");
	}]

	KeyMenu2[ ()
	{
		ClearMenu();
		AddStaticItem(ParseActionText(3010));
		AddStaticItem(ParseActionText(3011));
		AddStaticItem(ParseActionText(3012));
		AddStaticItem(ParseActionText(3013));
		AddStaticItem(ParseActionText(3014));
		AddStaticItem(ParseActionText(3015));
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	MenuQuit[ (s)
	{
		Quit();
	}]
}