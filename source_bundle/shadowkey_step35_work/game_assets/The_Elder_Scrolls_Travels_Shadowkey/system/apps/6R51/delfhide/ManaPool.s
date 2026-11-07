{
	Init[ (s)
	{
			if( GetPlayer().GetCharacter() = 0 ) { ClassType(20); }
			if( GetPlayer().GetCharacter() = 1 ) { ClassType(20); }
			if( GetPlayer().GetCharacter() = 2 ) { ClassType(10); }
			if( GetPlayer().GetCharacter() = 3 ) { ClassType(20); }
			if( GetPlayer().GetCharacter() = 4 ) { ClassType(10); }
			if( GetPlayer().GetCharacter() = 5 ) { ClassType(20); }
			if( GetPlayer().GetCharacter() = 6 ) { ClassType(10); }
			if( GetPlayer().GetCharacter() = 7 ) { ClassType(10); }
			if( GetPlayer().GetCharacter() = 8 ) { ClassType(20); }
	}]

	ClassType[ (Who)
	{
		switch(Who)
		{
			case 10
			{
				WMenu();
				return;
			}
			case 20
			{
				AddStaticItem(3925);
				AddStaticItem(179, false);
				AddMenuItem(517, "MenuQuit");
			}
		}
	}]

	WMenu[ (s)
	{
		if( Level.saved_Charges > 0 )
		{
			AddStaticItem(3110);
			AddStaticItem(179, false);
			AddMenuItem(591, "Mana");
			AddMenuItem(378, "MenuQuit");
		}
		else
		{

			AddStaticItem(3111);
			AddStaticItem(179, false);
			AddMenuItem(517, "MenuQuit");
		}
	}]
	Mana[ (s)
	{
		Cost = GetPlayer().GetMagicka();
		if( GetPlayer().GetMaxMagicka() = Cost )
		{
			Quit();
		}
		else
		{

			ClearMenu();
		        AddStaticItem(3112);
			AddStaticItem(179, false);
			AddMenuItem(591, "MenuQuit");
			GetPlayer().SetMagicka( GetPlayer().GetMagicka() + 20 );
			Level.saved_Charges = Level.saved_Charges - 1;
		}

	}]
	MenuQuit[ (s)
	{
		Quit();
	}]
}

