{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem( 1953 );
		AddStaticItem(179, false);
		AddMenuItem( 182, "Mo" );
	}]

	Mo[ (s)
	{
		ClearMenu();
		max = GetPlayer().GetMaxHealth();
		max = max - 5;
		GetPlayer().SetMaxHealth(max);
		s = GetPlayer().GetStrength();
		ag = GetPlayer().GetAgility();
		s = s +10;
		ag = ag + 10;
		GetPlayer().SetStrength(s);
		GetPlayer().SetAgility(ag);
		AddStaticItem( 1954 );
		AddStaticItem(179, false);
		AddMenuItem( 386, "MenuQuit" );
	}]

	MenuQuit[ (s)
	{
		Quit();
	}]
}