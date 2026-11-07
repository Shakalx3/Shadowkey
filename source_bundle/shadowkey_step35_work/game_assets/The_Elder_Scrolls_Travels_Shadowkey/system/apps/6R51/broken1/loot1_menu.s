{
	Init[()
	{
		ClearMenu();
		AddStaticItem(443);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		GetPlayer().SetQuestSolved(47);
		GetOpener().Desk = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}