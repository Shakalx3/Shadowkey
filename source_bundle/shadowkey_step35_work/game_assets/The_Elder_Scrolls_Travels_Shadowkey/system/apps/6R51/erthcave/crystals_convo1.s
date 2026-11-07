{
	Init[ (s)
	{
		if( Level.saved_Charges1 > 0 )
		{
			AddStaticItem(3667);
			AddStaticItem(179, false);
			AddMenuItem(3590, "UseCharge");
			AddMenuItem(3697, "MenuQuit");

		}
		else
		{
			AddStaticItem(3668);
			AddStaticItem(179, false);
			AddMenuItem(3590, "MenuQuit");
		}
	}]

	UseCharge[ (s)
	{
		ClearMenu();
		AddStaticItem(3669);
		AddStaticItem(179, false);
		AddMenuItem(3590, "MenuQuit");
		GetPlayer().SetHealth( GetPlayer().GetHealth() + 20 );
		GetPlayer().SetMagicka( GetPlayer().GetMagicka() + 20 );
		Level.saved_Charges1 = Level.saved_Charges1 - 1;

	}]

	MenuQuit[ (s)
	{
		Quit();
	}]
}


