{
	Init[()
	{
		AddStaticItem(2240);
		AddStaticItem(179, false);
		AddMenuItem(1829, "MenuQuit");
		Level.GetEntity("wulfbrs").SetAggressive(true);
		Level.GetEntity("wulfbrs").SetUsable(false);
		Level.GetEntity("wulfbrs").SetHealth(Level.GetEntity("wulfbrs").GetHealth() - 20);
	}]

	MenuQuit[()
	{
		Quit();
	}]
}