{
	Init[ ()
	{
		if( GetPlayer().saved_Guild = 3)
		{
			ClearMenu();
			AddStaticItem(3195);
			AddStaticItem(179, false);
			AddMenuItem(3196, "MenuQuit");
			AddMenuItem(3197, "The_Deal");

		}
		else
		{
			ClearMenu();
			AddStaticItem(3198);
			AddStaticItem(179, false);
			AddMenuItem(591, "MenuQuit");
		}
	}]

	The_Deal[ ()
		{
			ClearMenu();
			AddStaticItem(3396);
			AddStaticItem(3397);
			AddStaticItem(179, false);
			AddMenuItem(3201, "MenuQuit");
			AddMenuItem(3202, "CheckClass");
		}]

	CheckGuild[ ()
	     	{

			if( GetPlayer().saved_Guild = 3)
			{
				ClearMenu();
				AddStaticItem(3385);
				AddStaticItem(179, false);
				AddMenuItem(3201, "MenuQuit");
				AddMenuItem(591, "TakeGold01");
			}
			else
			{
				ClearMenu();
				AddStaticItem(3386);
				AddStaticItem(179, false);
				AddMenuItem(3201, "MenuQuit");
				AddMenuItem(591, "TakeGold02");
			}
		}]

        TakeGold01[ ()
		{
			TakeGold01 = GetPlayer().GetGold();
			if (TakeGold01 < 1000)
			{
			ClearMenu();
				AddStaticItem(3375);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
			}
			else
			{
				ClearMenu();
				AddStaticItem(3398);
				AddStaticItem(179, false);
				AddMenuItem(591, "Train_Player");
				TakeGold01 = TakeGold01 - 1000;
			        GetPlayer().SetGold(TakeGold01);
			        Level.saved_ThiefTrainer + 1;
			}
		}]

	TakeGold02[ ()
		{
			TakeGold02 = GetPlayer().GetGold();
			if (TakeGold02 < 1000)
			{
				ClearMenu();
				AddStaticItem(3375);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
			}
			else
			{
				ClearMenu();
				AddStaticItem(3399);
				AddStaticItem(179, false);
				AddMenuItem(591, "Train_Player");
				TakeGold02 = TakeGold02 - 1500;
			        GetPlayer().SetGold(TakeGold02);
			        Level.saved_ThiefTrainer = 1;

			}
		}]



	CheckClass[ ()
		{
			if( GetPlayer().GetCharacter() = 0 ) { ClassType(10); }
			if( GetPlayer().GetCharacter() = 1 ) { ClassType(40); }
			if( GetPlayer().GetCharacter() = 2 ) { ClassType(40); }
			if( GetPlayer().GetCharacter() = 3 ) { ClassType(40); }
			if( GetPlayer().GetCharacter() = 4 ) { ClassType(20); }
			if( GetPlayer().GetCharacter() = 5 ) { ClassType(40); }
			if( GetPlayer().GetCharacter() = 6 ) { ClassType(40); }
			if( GetPlayer().GetCharacter() = 7 ) { ClassType(40); }
			if( GetPlayer().GetCharacter() = 8 ) { ClassType(30); }
		}]

	ClassType[ (Who)
	{
		switch(Who)
		{
			case 10
			{
				ClearMenu();
				AddStaticItem(3206);
				AddStaticItem(179, false);
				AddMenuItem(591, "CheckGuild");
				return;
			}
			case 20
			{
				ClearMenu();
				AddStaticItem(3207);
				AddStaticItem(179, false);
				AddMenuItem(591, "CheckGuild");
				return;
			}
			case 30
			{
				ClearMenu();
				AddStaticItem(3208);
				AddStaticItem(179, false);
				AddMenuItem(591, "CheckGuild");
				return;
			}
			case 40
			{
				ClearMenu();
				AddStaticItem(3400);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
				return;
			}
		}

	}]

	Train_Player[ ()
		{

			if( GetPlayer().GetCharacter() = 0 ) { Train_A(1); }
			if( GetPlayer().GetCharacter() = 4 ) { Train_A(2); }
			if( GetPlayer().GetCharacter() = 8 ) { Train_A(3); }

		}]

	Train_A[ (bob)
	{
		switch(bob)
		{
			case 1
			{
				ClearMenu();
				AddStaticItem(3401);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
				val = GetPlayer().GetSpecialAbility(val);
				val = val + 5;
				return;
		        }
			case 2
			{
				ClearMenu();
				AddStaticItem(3211);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
				val = GetPlayer().GetSpecialAbility(val);
				val = val + 5;
				return;
			}
			case 3
			{
				ClearMenu();
				AddStaticItem(3402);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
				val = GetPlayer().GetSpecialAbility(val);
				val = val + 5;
				return;
			}

		}
	}]

	MenuQuit[ ()
	{
		Quit();
	}]

}
