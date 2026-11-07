{

	Init[ (s)
	{
		if (Level.saved_Birgitta = 1)
		{
			Dice01();
		}
		else
		{
			Dice02();
		}
	}]

	Dice01[ (s)
	{
		Roll2 = Random (1,3);
		if (Roll2 = 1)
		{
			ClearMenu();
			AddStaticItem(3603);
			AddStaticItem(179, false);
			AddMenuItem(3604, "MenuQuit");
			return;
		}
		if (Roll2 = 2)
		{
			ClearMenu();
			AddStaticItem(3605);
			AddStaticItem(179, false);
			AddMenuItem(3604, "MenuQuit");
			return;
		}
		if (Roll2 = 3)
		{
			ClearMenu();
			AddStaticItem(3606);
			AddStaticItem(179, false);
			AddMenuItem(3604, "MenuQuit");
			return;
		}
	}]

	Dice02[ (s)
	{
		Roll = Random (1,5);
		if(Roll = 1 )
		{
			ClearMenu();
			AddStaticItem(894);
			AddStaticItem(179, false);
			AddMenuItem(895, "MenuQuit");
			return;
		}

		if( Roll = 2 )
		{
			ClearMenu();
			AddStaticItem( 896);
			AddStaticItem(179, false);
			AddMenuItem(897, "MenuQuit");
			return;

		}
		if(Roll = 3 )
		{
			ClearMenu();
			AddStaticItem(898);
			AddStaticItem(179, false);
			AddMenuItem(899, "MenuQuit");
			return;
		}
		if(Roll = 4 )
		{
			ClearMenu();
			AddStaticItem(900);
			AddStaticItem(179, false);
			AddMenuItem(901, "MenuQuit");
			return;

		}
		if(Roll = 5 )
		{
			ClearMenu();
			AddStaticItem(902);
			AddStaticItem(179, false);
			AddMenuItem(903, "MenuQuit");
			return;

		}

	}]

	MenuQuit2[ (s)
	{
		Quit();
		GetOpener().DestroyObjectMirror( GetOpener() );
	}]

	MenuQuit[ (s)
	{
		ClearMenu();
		AddStaticItem(1170);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit2");
		GetPlayer().AddExperience( 100 );
	}]
}