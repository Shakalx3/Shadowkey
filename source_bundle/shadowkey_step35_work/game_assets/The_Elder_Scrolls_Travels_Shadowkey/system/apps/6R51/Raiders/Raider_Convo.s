{
	Init[ ()
	{
		AddStaticItem(2209);
		AddStaticItem(179, false);
		AddMenuItem(2210, "MenuQuit");
		AddMenuItem(2211, "AgroGuard");
	}]

	AgroGuard[ ()

	{
		Level.GetEntity("raidtlk").SetAggressive(true);
		Quit();
	}]

	MenuQuit[ ()
	{
		Quit();
	}]
}