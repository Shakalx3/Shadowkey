{
	Init[()
	{
		ClearMenu();
		AddStaticItem(3037);
		AddStaticItem(3038);
		AddStaticItem(179, false);
		AddMenuItem(774, "MenuQuit");
		GetPlayer().SetHealth(GetPlayer().GetHealth() - 10);
	}]

	MenuQuit[()
	{
		Quit();
	}]
}