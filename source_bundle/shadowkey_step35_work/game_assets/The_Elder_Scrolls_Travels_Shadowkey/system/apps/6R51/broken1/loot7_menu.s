{
	Init[()
	{
		ClearMenu();
		AddStaticItem(452);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		GetPlayer().SetQuestSolved(45);
		GetOpener().Chest = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}