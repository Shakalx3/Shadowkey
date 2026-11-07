{
	Init[()
	{
		if( GetPlayer().saved_Guild = 3)
		{
			ClearMenu();
			AddStaticItem(3611);
			AddStaticItem(179, false);
			AddMenuItem(3612, "MenuQuit");
			AddMenuItem(3124, "LeaveGuild");
			if(GetPlayer().saved_Business = 0)
			{
				if(GetPlayer().QuestAssigned(36)=true)
				{
					AddMenuItem(3614, "Business");
				}
			}
		}
		else
		{
			ClearMenu();
			AddStaticItem(3615);
			AddStaticItem(179, false);
			AddMenuItem(3616, "MenuQuit");
			AddMenuItem(3617, "CheckGuild");
			if(GetPlayer().saved_Business = 0)
			{
				if(GetPlayer().QuestAssigned(36)=true)
				{
					AddMenuItem(3614, "Business");
				}
			}
		}
	}]

	JoinGuild[()
	{
		ClearMenu();
		AddStaticItem(3618);
		AddStaticItem(179,false);
		AddMenuItem(3619, "CheckGold");
		AddMenuItem(3616, "MenuQuit");
	}]

	CheckGold[ ()
	{
			TakeGold02 = GetPlayer().GetGold();
			if (TakeGold02 < 750)
			{
				ClearMenu();
				AddStaticItem(3375);
				AddStaticItem(179, false);
				AddMenuItem(3590, "MenuQuit");
			}
			else
			{
				ClearMenu();
				AddStaticItem(3620);
				AddStaticItem(3621);
				AddStaticItem(179, false);
				AddMenuItem(3590, "MenuQuit");
				TakeGold02 = TakeGold02 - 750;
				GetPlayer().SetGold(TakeGold02);
				GetPlayer().saved_Guild = 3;
				if(GetPlayer().QuestAssigned(36)=true)
				{
					AddMenuItem(3622, "Business");

				}
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
		AddStaticItem(3624);
		AddStaticItem(179, false);
		AddMenuItem(992, "MenuQuit");
		AddMenuItem(386, "LeaveGuild");
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
				JoinGuild();
				return;
			}
			case 1
			{
				ClearMenu();
				AddStaticItem(3625);
				AddStaticItem(179, false);
				AddMenuItem(3626, "LeaveGuild");
				AddMenuItem(3428,"MenuQuit");
				return;
			}
			case 2
			{
				ClearMenu();
				AddStaticItem(3627);
				AddStaticItem(179, false);
				AddMenuItem(3124, "LeaveGuild");
				AddMenuItem(3428,"MenuQuit");
				return;
			}
			case 3
			{
				JoinGuild();
				return;
			}
		}
	}]

	Business[()
	{
		ClearMenu();
		AddStaticItem(3628);
		AddStaticItem(179, false);
		AddMenuItem(182, "More1");
		GetPlayer().saved_Business = 1;
	}]

	More1[()
	{
		ClearMenu();
		AddStaticItem(965);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	}]

	More2[()
	{
		ClearMenu();
		AddStaticItem(3378);
		AddStaticItem(179, false);
		AddMenuItem(3629, "More3");
	}]

	More3[()
	{
		ClearMenu();
		AddStaticItem(968);
		AddStaticItem(179, false);
		AddMenuItem(3630, "Done");
	}]

	Done[()
	{
		ClearMenu();
		GetPlayer().SetQuestSolved(36);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}
