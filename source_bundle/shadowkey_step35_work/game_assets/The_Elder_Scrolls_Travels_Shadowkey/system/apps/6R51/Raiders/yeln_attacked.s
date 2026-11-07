{
	Init[()
	{
		AddStaticItem(2241);
		AddStaticItem(179, false);
		AddMenuItem(1829, "MenuQuit");
		Level.GetEntity("yeln").SetAggressive(true);
		Level.GetEntity("yeln").SetUsable(false);
		Level.GetEntity("yeln").SetHealth(Level.GetEntity("yeln").GetHealth() - 20);
	}]

	MenuQuit[()
	{
		Quit();
	}]
}