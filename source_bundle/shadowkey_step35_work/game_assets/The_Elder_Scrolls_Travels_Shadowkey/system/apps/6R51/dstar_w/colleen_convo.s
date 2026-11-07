{
	Init[()
	{
		if( GetPlayer().saved_Guild = 1)
		{

			AddStaticItem(3653);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");
			AddMenuItem(3613, "LeaveGuild");
		}
		else
		{
			AddStaticItem(1142);
			AddStaticItem(179);
			AddMenuItem(960, "CheckGuild");
			AddMenuItem(959, "Quit");
		}
	}]

	Join[ ()
	{
		ClearMenu();
		AddStaticItem(3471);
		AddStaticItem(179, false);
		AddMenuItem(3619, "TakeGold01");
	}]

	 TakeGold01[ ()
	{
		Gold = GetPlayer().GetGold();
		if (Gold < 750)
		{
			ClearMenu();
			AddStaticItem(3375);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");
		}
		else
		{
			ClearMenu();
			AddStaticItem(3472);
			AddStaticItem(3473);
			AddStaticItem(3474);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");
			Gold = GetPlayer().GetGold();
			Gold  = Gold - 750;
		        GetPlayer().SetGold(Gold);
		     	GetPlayer().saved_Guild = 1;
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
			Join();
			return;
		}
		case 1
		{
			Join();
			return;
		}
		case 2
		{
			ClearMenu();
			AddStaticItem(3627);
			AddStaticItem(179, false);
			AddMenuItem(3428,"MenuQuit");
			AddMenuItem(3626, "LeaveGuild");
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
}
