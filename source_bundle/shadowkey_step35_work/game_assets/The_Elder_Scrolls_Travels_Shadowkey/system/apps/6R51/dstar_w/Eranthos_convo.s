{
	Init[ (s)
	{
		AddStaticItem(3475);
		AddStaticItem(179, false);
		AddMenuItem(3197, "Train");
		AddMenuItem(1126, "BuyItems");
		AddMenuItem(1127, "SellItems");
		AddMenuItem(3476, "MenuQuit");
	}]

	BuyItems[ ()
	{
		Quit();
		GetPlayer().BuyFromMerchant();
	}]

	SellItems[ ()
	{
		Quit();
		GetPlayer().SellToMerchant();
	}]

	Train[ ()
	{
		Lvl = GetPlayer().GetLevel();
		Lvl = Lvl +5;
		if (Level.saved_MageTrainer < Lvl)
		{
			ClearMenu();
			AddStaticItem(3477);
			AddStaticItem(3478);
			AddStaticItem(179, false);

			AddMenuItem(3197, "CheckClass");
			AddMenuItem(3201, "MenuQuit");

		}
		else
		{
			ClearMenu();
			AddStaticItem(3382);
			AddStaticItem(179, false);
			AddMenuItem(591, "MenuQuit");
		}
	}]

	CheckGuild[ ()
	     	{

			if( GetPlayer().saved_Guild = 1)
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
				ClearMenu();
				AddStaticItem(3398);
				AddStaticItem(179, false);
				AddMenuItem(591, "Train_Player");
				PlayerGold = GetPlayer().GetGold();
				PlayerGold = PlayerGold - 1000;
			        GetPlayer().SetGold(PlayerGold);

			}
		}]

	TakeGold02[ ()
		{
			PlayerGold02 = GetPlayer().GetGold();
			if (PlayerGold02 < 1500)
			{
				ClearMenu();
				AddStaticItem(3375);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
			}
			else
			{
				ClearMenu();
				AddStaticItem(3660);
				AddStaticItem(179, false);
				AddMenuItem(591, "Train_Player");
				PlayerGold02 = GetPlayer().GetGold();
				PlayerGold02 = PlayerGold02 - 1500;
			        GetPlayer().SetGold(PlayerGold02);


			}
		}]



	CheckClass[ ()
		{
			if( GetPlayer().GetCharacter() = 0 ) { ClassType(40); }
			if( GetPlayer().GetCharacter() = 1 ) { ClassType(40); }
			if( GetPlayer().GetCharacter() = 2 ) { ClassType(10); }
			if( GetPlayer().GetCharacter() = 3 ) { ClassType(40); }
			if( GetPlayer().GetCharacter() = 4 ) { ClassType(40); }
			if( GetPlayer().GetCharacter() = 5 ) { ClassType(40); }
			if( GetPlayer().GetCharacter() = 6 ) { ClassType(20); }
			if( GetPlayer().GetCharacter() = 7 ) { ClassType(30); }
			if( GetPlayer().GetCharacter() = 8 ) { ClassType(40); }
		}]

	ClassType[ (Who)
	{
		switch(Who)
		{
			case 10
			{
				ClearMenu();
				AddStaticItem(3479);
				AddStaticItem(179, false);
				AddMenuItem(591, "CheckGuild");
				return;
			}
			case 20
			{
				ClearMenu();
				AddStaticItem(3480);
				AddStaticItem(179, false);
				AddMenuItem(591, "CheckGuild");
				return;
			}
			case 30
			{
				ClearMenu();
				AddStaticItem(3481);
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

			if( GetPlayer().GetCharacter() = 2 ) { Train_A(1); }
			if( GetPlayer().GetCharacter() = 6 ) { Train_A(2); }
			if( GetPlayer().GetCharacter() = 7 ) { Train_A(3); }

		}]

	Train_A[ (bob)
	{
		switch(bob)
		{
			case 1
			{
				ClearMenu();
				AddStaticItem(3482);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
				val = GetPlayer().GetSpecialAbility();
				val = val + 1;
				GetPlayer().SetSpecialAbility(val);
				Level.saved_MageTrainer = Level.saved_MageTrainer + 1;
				return;
		        }
			case 2
			{
				ClearMenu();
				AddStaticItem(3483);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
				val = GetPlayer().GetSpecialAbility();
				val = val + 1;
				GetPlayer().SetSpecialAbility(val);
				Level.saved_MageTrainer = Level.saved_MageTrainer + 1;
				return;
			}
			case 3
			{
				ClearMenu();
				AddStaticItem(3484);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
				val = GetPlayer().GetSpecialAbility();
				val = val + 1;
				GetPlayer().SetSpecialAbility(val);
				Level.saved_MageTrainer = Level.saved_MageTrainer + 1;
				return;
			}

		}
	}]

	MenuQuit[ ()
	{
		Quit();
	}]
	
	
	Eranthos_convoBack[ ()
	{
		Quit();
	}]

}

