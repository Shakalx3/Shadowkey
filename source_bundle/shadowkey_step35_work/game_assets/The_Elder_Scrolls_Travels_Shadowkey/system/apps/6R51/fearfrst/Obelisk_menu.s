{
	Init[()
	{
		AddStaticItem(1372);
		AddStaticItem(179, false);
		AddMenuItem(182, "MenuMore");
	}]
	MenuMore[()
	{
		ClearMenu();
		AddStaticItem(1373);
		AddStaticItem(179, false);
		AddMenuItem(1374, "Quit");
		AddMenuItem(1375, "Touch");
	}]
	Touch[()
	{
		curHealth = GetPlayer().GetHealth();
		GetPlayer().SetHealth( curHealth + 25 );
		GetPlayer().PlaySound(85);
		Quit();
	}]
}