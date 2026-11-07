{
	Init[()
	{
		ClearMenu();
		AddStaticItem(667);
		AddStaticItem(179, false);
		AddMenuItem(668, "More");
	}]

	More[()
	{
		ClearMenu();
		AddStaticItem(669);
		AddStaticItem(670);
		AddStaticItem(179, false);
		AddMenuItem(672, "Death");
		AddMenuItem(671, "MenuQuit");
	}]

	Death[()
	{
		ClearMenu();
		AddStaticItem(673);
		AddStaticItem(674);
		AddStaticItem(179, false);
		AddMenuItem(675, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
		Level.GetEntity("Pergan").SetUsable(false);
		Level.GetEntity("Pergan").SetAggressive(true);
		Level.GetEntity("Pergan").SetInvulnerable(false);
	}]
}