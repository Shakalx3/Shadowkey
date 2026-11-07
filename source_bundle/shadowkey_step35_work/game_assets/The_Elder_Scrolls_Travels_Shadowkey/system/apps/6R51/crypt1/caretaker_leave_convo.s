{
	Init[()
	{
		ClearMenu();
		AddStaticItem(596);
		AddStaticItem(179, false);
		AddMenuItem(182, "CareTakerLeave");
	}]

	CareTakerLeave[()
	{
		ClearMenu();
		AddStaticItem(597);
		AddStaticItem(179, false);
		AddMenuItem(182, "CareTakerLeave2");
	}]

	CareTakerLeave2[()
	{
		ClearMenu();
		AddStaticItem(598);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
		GetPlayer().SetQuestCompleted(49);
		GetPlayer().AddExperience(2700);
		GetPlayer().DestroyObjectMirror("ctaker");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}