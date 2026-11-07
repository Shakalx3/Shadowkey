{
	deleteConfirm
	deleteSlot
	allConfirm

	Init[()
	{
		SetPrevMenu("MainMenu");
	}]

	OnDisplay[ (s)
	{
		MenuBackground(69);
		ClearMenu();

		if( GameAvailableForLoad(0) and (GetMultiplayerSlot() != 0) )
		{
			AddMenuItem(3276,"DeleteSlot0");
			time = GetSavedTimeStr(0);
			//AddStaticItem(time,false,25,32767);
		}
		else
		{
			AddStaticItem(3277,false);
		}
		//AddStaticItem(714);

		if( GameAvailableForLoad(1) and (GetMultiplayerSlot() != 1) )
		{
			AddMenuItem(3278,"DeleteSlot1");
			time = GetSavedTimeStr(1);
			//AddStaticItem(time,false,25,32767);
		}
		else
		{
			AddStaticItem(3277,false);
		}
		//AddStaticItem(714);

		if( GameAvailableForLoad(2) and (GetMultiplayerSlot() != 2) )
		{
			AddMenuItem(3279,"DeleteSlot2");
			time = GetSavedTimeStr(2);
			//AddStaticItem(time,false,25,32767);
		}
		else
		{
			AddStaticItem(3277,false);
		}
		//AddStaticItem(714);

		if( GameAvailableForLoad(3) and (GetMultiplayerSlot() != 3) )
		{
			//AddMenuItem(3280, "LoadSlot3");
			AddMenuItem(3280,"DeleteSlot3");
			time = GetSavedTimeStr(3);
			//AddStaticItem(time,false,25,32767);
		}
		else
		{
			AddStaticItem(3277,false);
		}
		AddStaticItem(714);
		AddMenuItem(3589,"DeleteAll");

		deleteConfirm=CreatePopupMenu(15,75,150,70);
		deleteConfirm.AddItem(4008);
		deleteConfirm.AddItem(4010,"GoCancel");
		deleteConfirm.AddItem(4009,"GoDelete");		
		deleteConfirm.SetBack("GoCancel");
		deleteConfirm.SetSelectable(0,false);
		deleteConfirm.SetVisible(false);
		deleteConfirm.SetSelectedItem(1);
		deleteConfirm.SetBackground();

		allConfirm=CreatePopupMenu(15,75,150,85);
		allConfirm.AddItem(4011);
		allConfirm.AddItem(4010,"AllCancel");
		allConfirm.AddItem(4009,"AllConfirm");
		allConfirm.SetBack("AllCancel");
		allConfirm.SetSelectable(0,false);
		allConfirm.SetVisible(false);
		allConfirm.SetSelectedItem(1);
		allConfirm.SetBackground();

		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
                funtext.SetFontNum(1);
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	}]

	DeleteSlot0[()
	{
		deleteSlot = 0;
		deleteConfirm.SetSelectedItem(1);
		deleteConfirm.SetVisible(true);
	}]

	DeleteSlot1[()
	{
		deleteSlot = 1;
		deleteConfirm.SetSelectedItem(1);
		deleteConfirm.SetVisible(true);
	}]

	DeleteSlot2[()
	{
		deleteSlot = 2;
		deleteConfirm.SetSelectedItem(1);
		deleteConfirm.SetVisible(true);
	}]

	DeleteSlot3[()
	{
		deleteSlot = 3;
		deleteConfirm.SetSelectedItem(1);
		deleteConfirm.SetVisible(true);
	}]

	GoDelete[()
	{
		DeleteGame(deleteSlot);
		deleteConfirm.SetVisible(false);
		OnDisplay();
	}]
	GoCancel[()
	{
		deleteConfirm.SetVisible(false);
		//OnDisplay();
		SetSelectedItem(GetPrevItem());
	}]

	DeleteSavedGamesBack[ (s)
	{
		if( allConfirm.IsVisible() )
		{
			allConfirm.SetVisible( false );
			return;
		}

		if( deleteConfirm.IsVisible() )
		{
			deleteConfirm.SetVisible( false );
			return;
		}
		OpenMenu("MainMenu");
	}]

	DeleteAll[ (s)
	{
		allConfirm.SetVisible(true);
		allConfirm.SetSelectedItem(1);
	} ]

	AllConfirm[ (s)
	{
		allConfirm.SetVisible(false);
		allConfirm.SetSelectedItem(1);
		DeleteAllGames();
		OnDisplay();
	} ]

	AllCancel[ (s)
	{
		allConfirm.SetVisible(false);
		allConfirm.SetSelectedItem(1);
		SetSelectedItem(GetPrevItem());
	} ]
}