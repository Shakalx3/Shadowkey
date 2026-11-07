{
	Init[ ()
	{
		if (GetPlayer().saved_Guild = 2)
		{
			ClearMenu();
			AddStaticItem(3123);
			AddStaticItem(179, false);
			AddMenuItem(755, "MenuQuit");
			AddMenuItem(3124, "LeaveGuild");
		}
		else
		{
			ClearMenu();
			AddStaticItem(3119);
			AddStaticItem(3120);
			AddStaticItem(179, false);
			AddMenuItem(3122, "CheckGuild");
			AddMenuItem(3121, "MenuQuit");
		}
	}]
	CheckGold[ ()
	{
		TakeGold02 = GetPlayer().GetGold();
		if (TakeGold02 < 750)
		{
			ClearMenu();
			AddStaticItem(3127);
			AddStaticItem(179, false);
			AddMenuItem(591, "MenuQuit");
		}
		else
		{

			TakeGold02 = GetPlayer().GetGold();
			TakeGold02 = TakeGold02 - 750;
			ClearMenu();
			AddStaticItem(3928);
			AddStaticItem(179, false);
			AddMenuItem(3929, "MenuQuit");
			GetPlayer().SetGold(TakeGold02);
			GetPlayer().saved_Guild = 2;
		}
	}]
	LeaveGuild[ ()
	{
		ClearMenu();
		if (GetPlayer().saved_Guild = 1)
		{
			AddStaticItem(3655);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");
			GetPlayer().saved_Guild = 0;
		}
		if (GetPlayer().saved_Guild = 2)
		{
			AddStaticItem(3631);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");
			GetPlayer().saved_Guild = 0;
		}
		if (GetPlayer().saved_Guild = 3)
		{
			AddStaticItem(3623);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");
			GetPlayer().saved_Guild = 0;
		}

	}]
	QuitGuild[ ()
	{
		ClearMenu();
		AddStaticItem(3632);
		AddStaticItem(179, false);
		AddMenuItem(386, "LeaveGuild");
		AddMenuItem(992, "MenuQuit");
	}]
	CheckGuild[ ()
	{

		if( GetPlayer().saved_Guild = 0 ) { GuildMenu(0); }
		if( GetPlayer().saved_Guild = 1 ) { GuildMenu(1); }
		if( GetPlayer().saved_Guild = 2 ) { GuildMenu(2); }
		if( GetPlayer().saved_Guild = 3 ) { GuildMenu(3); }
	}]
	GuildMenu[ (Who)
	{
		switch(Who)
		{
			case 0
			{

				Guild750();
				return;
			}
			case 1
			{
				ClearMenu();
				AddStaticItem(3625);
				AddStaticItem(179, false);
				AddMenuItem(3428,"MenuQuit");
				AddMenuItem(3626, "LeaveGuild");
				return;
			}
			case 2
			{
				return;
			}
			case 3
			{
				ClearMenu();
				AddStaticItem(3633);
				AddStaticItem(179, false);
				AddMenuItem(3428,"MenuQuit");
				AddMenuItem(3634, "LeaveGuild");
				return;
			}
		}
	}]
	MenuQuit[ ()
	{
		Quit();
	}]
	Guild750[ ()
	{

		ClearMenu();
		AddStaticItem(3125);
		AddStaticItem(179, false);
		AddMenuItem(3122, "CheckGold");
		AddMenuItem(3126, "MenuQuit");
	}]
}