{
	Init[ ()
	{
		AddStaticItem(3368);
		AddStaticItem(3365);
		AddStaticItem(179, false);
		AddMenuItem(3366, "lootChestC");
		GetPlayer().AddExperience( 500 );
		Level.saved_chest03 = 1;
	}]

	MenuQuit[ ()
	{
		Quit();
	}]
	lootChestC[ (s)
	{
		Gold = Random( 1001, 2000 );
		ClearMenu();
		AddStaticItem(Gold#" "#GetLocalizedString(1580));
		GetPlayer().StatModGold(Gold);
		AddStaticItem(179, false);
		AddMenuItem(591, "MenuQuit");
	}]

	MenuQuit[ ()
	{
		Quit();
	}]
}