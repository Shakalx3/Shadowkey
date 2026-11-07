{
	Init[()
	{
		AddStaticItem(1362);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
	}]
	More[()
	{
		ClearMenu();
		AddStaticItem(1363);
		AddStaticItem(179, false);
		AddMenuItem(1335, "Revive");
		AddMenuItem(445, "Quit");
	}]
	Revive[()
	{
		ClearMenu();
		AddStaticItem(1364);
		AddStaticItem(179, false);
		AddMenuItem(386, "Okay");
	}]
	Okay[()
	{
		GetPlayer().SetFatigue(GetPlayer().GetFatigue() + 35);
		GetPlayer().SetHealth(GetPlayer().GetHealth() + 4);
		GetPlayer().SetMagicka(GetPlayer().GetMagicka() + 4);
		Quit();
	}]
}