{
	Init[()
	{
		AddStaticItem(2165);
		AddStaticItem(179, false);
		AddMenuItem(1829, "MenuQuit");
		Level.GetEntity("devron").SetAggressive(true);
		Level.GetEntity("devron").SetUsable(false);
		Level.GetEntity("devron").SetHealth(Level.GetEntity("devron").GetHealth() - 20);
	}]

	MenuQuit[()
	{
		Quit();
	}]
}