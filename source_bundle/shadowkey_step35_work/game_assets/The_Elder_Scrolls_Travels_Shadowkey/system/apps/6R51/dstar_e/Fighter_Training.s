{
	Init[ ()
	{
		Lvl = GetPlayer().GetLevel();
		Lvl = Lvl +5;
		if (Level.saved_FighterTrainer < Lvl)
		{
			ClearMenu();
			AddStaticItem(3380);
			AddStaticItem(179, false);
			AddMenuItem(3197, "The_Deal");
			AddMenuItem(3381, "MenuQuit");

		}
		else
		{
			ClearMenu();
			AddStaticItem(3382);
			AddStaticItem(179, false);
			AddMenuItem(591, "MenuQuit");
		}
	}]

	The_Deal[ ()
		{
			ClearMenu();
			AddStaticItem(3383);
			AddStaticItem(3384);
			AddStaticItem(179, false);

			AddMenuItem(3202, "CheckClass");
			AddMenuItem(3201, "MenuQuit");
		}]

	CheckGuild[ ()
	     	{
			if( GetPlayer().saved_Guild = 2)
			{
				ClearMenu();
				AddStaticItem(3385);
				AddStaticItem(179, false);

				AddMenuItem(591, "TakeGold01");
				AddMenuItem(3201, "MenuQuit");
			}
			else
			{
				ClearMenu();
				AddStaticItem(3386);
				AddStaticItem(179, false);

				AddMenuItem(591, "TakeGold02");
				AddMenuItem(3201, "MenuQuit");
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
				AddStaticItem(3387);
				AddStaticItem(179, false);
				AddMenuItem(591, "Train_Player");
				//TakeGold01 = TakeGold01 - 1000;
			     //   GetPlayer().SetGold(TakeGold01);
			     GetPlayer().StatModGold(-1000);

			}
		}]

	TakeGold02[ ()
		{
			TakeGold02 = GetPlayer().GetGold();
			if (TakeGold02 < 1500)
			{
				ClearMenu();
				AddStaticItem(3375);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
			}
			else
			{
				ClearMenu();
				AddStaticItem(3388);
				AddStaticItem(179, false);
				AddMenuItem(591, "Train_Player");
				//TakeGold02 = TakeGold02 - 1500;
			     //   GetPlayer().SetGold(TakeGold02);
				GetPlayer().StatModGold(-1500);

			}
		}]

	CheckClass[ ()
		{
			if( GetPlayer().GetCharacter() = 0 ) { ClassType(3); }
			if( GetPlayer().GetCharacter() = 1 ) { ClassType(1); }
			if( GetPlayer().GetCharacter() = 2 ) { ClassType(3); }
			if( GetPlayer().GetCharacter() = 3 ) { ClassType(4); }
			if( GetPlayer().GetCharacter() = 4 ) { ClassType(3); }
			if( GetPlayer().GetCharacter() = 5 ) { ClassType(2); }
			if( GetPlayer().GetCharacter() = 6 ) { ClassType(3); }
			if( GetPlayer().GetCharacter() = 7 ) { ClassType(3); }
			if( GetPlayer().GetCharacter() = 8 ) { ClassType(3); }
		}]

	ClassType[ (Who)
	{
		switch(Who)
		{
			case 1
			{
				ClearMenu();
				AddStaticItem(3389);
				AddStaticItem(179, false);
				AddMenuItem(591, "CheckGuild");
				return;
			}
			case 2
			{
				ClearMenu();
				AddStaticItem(3390);
				AddStaticItem(179, false);
				AddMenuItem(591, "CheckGuild");
				return;
			}

			case 3
			{
				ClearMenu();
				AddStaticItem(3391);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
				return;
			}
			case 4
			{
				ClearMenu();
				AddStaticItem(3392);
				AddStaticItem(179, false);
				AddMenuItem(591, "CheckGuild");
				return;
			}
		}

	}]

	Train_Player[ ()
		{

			if( GetPlayer().GetCharacter() = 1 ) { Train_A(1); }
			if( GetPlayer().GetCharacter() = 3 ) { Train_A(2); }
			if( GetPlayer().GetCharacter() = 5 ) { Train_A(3); }
		}]

	Train_A[ (bob)
	{
		switch(bob)
		{
			case 1
			{
				ClearMenu();
				AddStaticItem(3393);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
				val = GetPlayer().GetSpecialAbility();
				val = val + 1;
				GetPlayer().SetSpecialAbility(val);
				Level.saved_FighterTrainer = Level.saved_FighterTrainer + 1;
				return;
		        }
			case 2
			{
				ClearMenu();
				AddStaticItem(3394);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
				val = GetPlayer().GetSpecialAbility();
				val = val + 1;
				GetPlayer().SetSpecialAbility(val);
				Level.saved_FighterTrainer = Level.saved_FighterTrainer + 1;
				return;
			}
			case 3
			{
				ClearMenu();
				AddStaticItem(3395);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
				val = GetPlayer().GetSpecialAbility();
				val = val + 1;
				GetPlayer().SetSpecialAbility(val);
				Level.saved_FighterTrainer = Level.saved_FighterTrainer + 1;
				return;
			}

		}
	}]

	MenuQuit[ ()
	{
		Quit();
	}]

}
