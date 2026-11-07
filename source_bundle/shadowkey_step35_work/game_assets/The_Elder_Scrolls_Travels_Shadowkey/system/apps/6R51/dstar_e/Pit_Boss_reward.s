{
	Init[()
	{
		if( Level.saved_RewardMonster = 0 ){ Reward(1); }
		if( Level.saved_RewardMonster = 1 ){ Reward(2); }
		if( Level.saved_RewardMonster = 2 ){ Reward(3); }
		if( Level.saved_RewardMonster = 3 ){ Reward(4); }
		if( Level.saved_RewardMonster = 4 ){ Reward(5); }

	}]

	Reward[ (Who)
	{
		switch(Who)
		{
		case 1
			{
				GetPlayer().SetGold( GetPlayer().GetGold() + 95 );
				AddStaticItem(3178);
				AddStaticItem(179, false);
				AddMenuItem(591, "WonBattle01");
				return;

			}
			case 2
			{
				GetPlayer().SetGold( GetPlayer().GetGold() + 150 );
				AddStaticItem(3179);
				AddStaticItem(179, false);
				AddMenuItem(591, "WonBattle02");
				return;
			}
			case 3
			{
				GetPlayer().SetGold( GetPlayer().GetGold() + 225 );
				AddStaticItem(3180);
				AddStaticItem(179, false);
				AddMenuItem(591, "WonBattle03");
				return;
			}
			case 4
			{
				GetPlayer().SetGold( GetPlayer().GetGold() + 350);
				AddStaticItem(3181);
				AddStaticItem(179, false);
				AddMenuItem(591, "WonBattle04");
				return;
			}
			case 5
			{
				GetPlayer().SetGold( GetPlayer().GetGold() + 1500 );
				AddStaticItem(3182);
				AddStaticItem(179, false);
				AddMenuItem(591, "WonBattle05");
				return;
			}
		}

	}]

	WonBattle01[()
	{
		ClearMenu();
		GetPlayer().SetPosition(21573,22656,-1700);
		Level.saved_RewardMonster = 1;
		Quit();
	}]
	WonBattle02[()
	{
		ClearMenu();
		GetPlayer().SetPosition(21573,22656,-1700);
		Level.saved_RewardMonster = 2;
		Quit();
	}]
	WonBattle03[()
	{
		ClearMenu();
		GetPlayer().SetPosition(21573,22656,-1700);
		Level.saved_RewardMonster = 3;
		Quit();
	}]
	WonBattle04[()
	{
		ClearMenu();
		GetPlayer().SetPosition(21573,22656,-1700);
		Level.saved_RewardMonster = 4;
		Quit();
	}]
	WonBattle05[()
	{
		ClearMenu();
		GetPlayer().SetPosition(21573,22656,-1700);
		Level.saved_RewardMonster = 5;
		Level.saved_pitfans = 1;
		Quit();
	}]

}