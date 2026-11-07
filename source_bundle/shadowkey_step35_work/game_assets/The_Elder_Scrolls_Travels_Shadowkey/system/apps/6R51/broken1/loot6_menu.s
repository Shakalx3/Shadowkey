{
	Init[()
	{
		ClearMenu();
		AddStaticItem(451);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		GetPlayer().SetQuestSolved(48);
		GetOpener().Chest = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}