{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem(ParseActionText(3025));
		AddStaticItem(179, false);
		AddMenuItem(3026, "More");
	}]

	More[ (s)
	{
		ClearMenu();
		AddStaticItem(ParseActionText(3027));
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	MenuQuit[ (s)
	{
		Quit();
		GetPlayer().SetQuestCompleted(8);
		GetPlayer().AddExperience(125);
	}]
}