{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem(ParseActionText(3016));
		AddStaticItem(179, false);
		AddMenuItem(3017, "MenuQuit");
		AddMenuItem(3018, "Tactics");
		GetPlayer().SetQuestAssigned(8);
	}]

	Tactics[ (s)
	{
		ClearMenu();
		AddStaticItem(ParseActionText(3019));
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
	}]

	More[ (s)
	{
		ClearMenu();
		AddStaticItem(ParseActionText(3020));
		AddStaticItem(179, false);
		AddMenuItem(3021, "MenuQuit");
	}]

	MenuQuit[ (s)
	{
		Quit();
	}]
}