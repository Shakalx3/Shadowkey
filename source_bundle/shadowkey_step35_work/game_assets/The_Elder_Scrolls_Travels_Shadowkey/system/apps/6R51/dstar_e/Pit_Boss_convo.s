{
	Init[()
	{

		if( Level.saved_pitopen = 0 ){ Bab(1); }
		if( Level.saved_pitopen = 1 ){ Bab(2); }
		if( Level.saved_pitopen = 2 ){ Bab(3); }
		if( Level.saved_pitopen = 3 ){ Bab(4); }
		if( Level.saved_pitopen = 4 ){ Bab(5); }
		if( Level.saved_pitopen = 5 ){ Bab(6); }
	}]

	Bab[ (Who)

	{

		switch(Who)
		{
			case 1
			{
				Level.Log("Menu Case 1");
				ClearMenu();
				AddStaticItem(3157);
				AddStaticItem(179, false);
				AddMenuItem(182, "TLK01");
			}
			case 2
			{
				Level.Log("Menu Case 2");
				ClearMenu();
				AddStaticItem(3158);
				AddStaticItem(179, false);
				AddMenuItem(3159, "TLK03");
				AddMenuItem(3428, "MenuQuit");
			}
			case 3
			{
				Level.Log("Menu Case 3");
				ClearMenu();
				AddStaticItem(3429);
				AddStaticItem(3430);
				AddStaticItem(179, false);
				AddMenuItem(3159, "TLK04");
				AddMenuItem(3428, "MenuQuit");
			}
			case 4
			{
				Level.Log("Menu Case 4");
				ClearMenu();
				AddStaticItem(3162);
				AddStaticItem(3163);
				AddStaticItem(179, false);
				AddMenuItem(3159, "TLK05");
				AddMenuItem(3428, "MenuQuit");
			}
			case 5
			{
				Level.Log("Menu Case 5");
				ClearMenu();
				AddStaticItem(3164);
				AddStaticItem(179, false);
				AddMenuItem(3159, "TLK06");
				AddMenuItem(3428, "MenuQuit");
			}
			case 6
			{
				Level.Log("Menu Case 6");
				ClearMenu();
				AddStaticItem(3165);
				AddStaticItem(179, false);
				AddMenuItem(591, "MenuQuit");
			}

		}

	}]

	TLK01[ ()
	{
		Level.Log("Talk 01");
		ClearMenu();
		AddStaticItem(3166);
		AddStaticItem(3167);
		AddStaticItem(179, false);
		AddMenuItem(591, "TLK02");
		AddMenuItem(3431, "MenuQuit");

	}]
	TLK02[ ()
	{
		ClearMenu();
		AddStaticItem(3432);
		AddStaticItem(179, false);
		AddMenuItem(3170, "Fight01");
	}]
	Fight01[ ()
	{
		 GetPlayer().OpenMenu("dstar_e\\\\Pit_Boss_Battle");
	}]

	TLK03[ ()
	{
		ClearMenu();
		AddStaticItem(3433);
		AddStaticItem(179, false);
		AddMenuItem(3170, "Fight02");
	}]
	Fight02[ ()
	{
		 GetPlayer().OpenMenu("dstar_e\\\\Pit_Boss_Battle");
	}]

	TLK04[ ()
	{
		ClearMenu();
		AddStaticItem(3172);
		AddStaticItem(179, false);
		AddMenuItem(3170, "Fight03");
	}]

	Fight03[ ()
	{
		 GetPlayer().OpenMenu("dstar_e\\\\Pit_Boss_Battle");
	}]

	TLK05[ ()
	{
		ClearMenu();
		AddStaticItem(3434);
		AddStaticItem(179, false);
		AddMenuItem(3170, "Fight04");
	}]
	Fight04[ ()
	{
		 GetPlayer().OpenMenu("dstar_e\\\\Pit_Boss_Battle");
	}]

	TLK06[ ()
	{
		ClearMenu();
		AddStaticItem(3174);
		AddStaticItem(179, false);
		AddMenuItem(3175, "MenuQuit");
		AddMenuItem(3176, "TLK07");
	}]

	TLK07[ ()
	{
		ClearMenu();
		AddStaticItem(3177);
		AddStaticItem(179, false);
		AddMenuItem(3170, "Fight05");
	}]
	Fight05[ ()
	{
		 GetPlayer().OpenMenu("dstar_e\\\\Pit_Boss_Battle");
	}]

	MenuQuit[ ()
	{
		Quit();
	}]
}
