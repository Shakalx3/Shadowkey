{
	Init [ (s)

	{		AddStaticItem(778);
			AddStaticItem(779);
			AddStaticItem(780);
			AddStaticItem(781);
			AddStaticItem(782);
			AddStaticItem(179, false);
			AddMenuItem(783, "MenuQuit");
			// Set Weapon and Spell
			Dagger=Level.CreateEntity(55);
			GetPlayer().EquipItem(0,Dagger);
			Blaze=Level.CreateEntity(50);
			GetPlayer().EquipItem( 1, Blaze );

	}]

	MenuQuit[ (s)
	{
		Quit();
	} ]

}