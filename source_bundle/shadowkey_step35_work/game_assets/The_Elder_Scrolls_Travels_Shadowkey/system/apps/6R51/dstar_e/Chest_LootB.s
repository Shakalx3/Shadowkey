{
	Init[ ()
	{
		AddStaticItem(3367);
		AddStaticItem(3365);
		AddStaticItem(179, false);
		AddMenuItem(3366, "lootChestB");
		GetPlayer().AddExperience( 500 );
		Level.saved_chest02 = 1;
	}]

	MenuQuit[ ()
	{
		Quit();
	}]
	lootChestB[ (s)
	{
		Gold = Random( 501, 1000 );
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