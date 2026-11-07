{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem(1901);
		AddStaticItem(179, false);
		AddMenuItem(1902, "MenuQuit");
		Level.GetEntity("duvais").SetAggressive(true);
		Level.GetEntity("duvais").SetInvulnerable(false);
	}]

	MenuQuit[ (s)
	{
		Quit();
	}]
}