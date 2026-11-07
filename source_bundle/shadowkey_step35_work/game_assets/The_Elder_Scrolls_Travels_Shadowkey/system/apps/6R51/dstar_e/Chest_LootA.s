{
	Init[ ()
	{
		AddStaticItem(3364);
		AddStaticItem(3365);
		AddStaticItem(179, false);
		AddMenuItem(3366, "lootChestA");
		GetPlayer().AddExperience( 500 );
		Level.saved_chest01 = 1;
	}]

	MenuQuit[ ()
	{
		Quit();
	}]
	lootChestA[ (s)
	{
		Gold = Random( 100, 500 );
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