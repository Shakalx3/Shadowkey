{
	Init[ ()
	{
		Lvl = GetPlayer().GetLevel();
		Lvl = Lvl +5;
		if (Level.saved_ThiefTrainer < Lvl)
		{
			ClearMenu();
			AddStaticItem(3195);
			AddStaticItem(179, false);

			AddMenuItem(3197, "The_Deal");
			AddMenuItem(3196, "MenuQuit");

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
			AddStaticItem(3396);
			AddStaticItem(3468);
			AddStaticItem(179, false);

			AddMenuItem(3202, "CheckClass");
			AddMenuItem(3201, "MenuQuit");
		}]

	CheckGuild[ ()
	     	{

			if( GetPlayer().saved_Guild = 3)
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
			PlayerGold = GetPlayer().GetGold();
			if (PlayerGold < 1000)
			{
				ClearMenu();
				AddStaticItem(3375);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
			}
			else
			{
				PlayerGold = GetPlayer().GetGold();
				PlayerGold = PlayerGold - 1000;
			        GetPlayer().SetGold(PlayerGold);
			        Train_Player();

			}
		}]

	TakeGold02[ ()
		{
			PlayerGold = GetPlayer().GetGold();
			if (PlayerGold < 1500)
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
				PlayerGold = GetPlayer().GetGold();
				PlayerGold = PlayerGold - 1500;
			        GetPlayer().SetGold(PlayerGold);


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
				val = GetPlayer().GetSpecialAbility();
				val = val + 1;
				GetPlayer().SetSpecialAbility(val);
				Level.saved_ThiefTrainer = Level.saved_ThiefTrainer + 1;
				return;
		        }
			case 2
			{
				ClearMenu();
				AddStaticItem(3211);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
				val = GetPlayer().GetSpecialAbility();
				val = val + 1;
				GetPlayer().SetSpecialAbility(val);
				Level.saved_ThiefTrainer = Level.saved_ThiefTrainer + 1;
				return;
			}
			case 3
			{
				ClearMenu();
				AddStaticItem(3402);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
				val = GetPlayer().GetSpecialAbility();
				val = val + 1;
				GetPlayer().SetSpecialAbility(val);
				Level.saved_ThiefTrainer = Level.saved_ThiefTrainer + 1;
				return;
			}

		}
	}]

	MenuQuit[ ()
	{
		Quit();
	}]

}
