{
	Init[ ()
	{
		ClearMenu();
		AddStaticItem(3292);
		AddStaticItem(3293);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
	}]

	More[ ()
	{
		ClearMenu();
		AddStaticItem(2189);
		AddStaticItem(179, false);
		AddMenuItem(3294, "Loot2");
		AddMenuItem(3295, "MenuQuit");
		Level.saved_EnterGuard = 1;
	}]

	Loot2[()
	{
		ClearMenu();
		OpenMenu("Raiders\\\\Loot2");
	}]

	MenuQuit[ ()
	{
		ClearMenu();
		Raider = Level.GetEntity("RD_ENT");
		Raider.SetAggressive(true);
		Raider.AiDetect();
		Quit();
	}]

}