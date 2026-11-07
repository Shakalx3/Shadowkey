{
	loadslot
	bGoBack[0]
	failed

	Init[ (s)
	{
		SetPrevMenu("MainMenu");
	} ]

	OnDisplay[ (s)
	{		
		bGoBack=0;
		MenuBackground(69);
		ClearMenu();
		AddStaticItem(717,0);
		AddStaticItem(714);
		first=0;
		if( GameAvailableForLoad(0) )
		{
			first=AddMenuItem(3276, "LoadSlot0");
		}
		else
		{
			first=AddStaticItem(3277,false);
		}
		
		SetSelectedItem(first);

		if( GameAvailableForLoad(1) )
		{
			AddMenuItem(3278, "LoadSlot1");
		}
		else
		{
			AddStaticItem(3277,false);
		}

		if( GameAvailableForLoad(2) )
		{
			AddMenuItem(3279, "LoadSlot2");
		}
		else
		{
			AddStaticItem(3277,false);
		}

		if( GameAvailableForLoad(3) )
		{
			AddMenuItem(3280, "LoadSlot3");
		}
		else
		{
			AddStaticItem(3277,false);
		}

		failed=CreatePopupMenu(15,75,150,110);
		failed.AddItem(4057);
		failed.AddItem(4028,"OnClosePopup");
		failed.SetBack("OnClosePopup");
		failed.SetSelectable(0,false);
		failed.SetVisible(false);
		failed.SetSelectedItem(1);
		failed.SetAutoAdjust(true);
		
		//AddMenuItem(3281, "MenuQuit");
		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	} ]

	LoadSlot0[ (s)
	{
		loadslot = 0;
		if( GameActive() )
		{
			bGoBack=1;
			ClearMenu();
			AddStaticItem(3282,false);
			AddMenuItem(1389, "OnDisplay");
			AddMenuItem(1375, "LoadSlot");
			funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
			funtext.SetFontNum(1);
			funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
			funtext.SetFontNum(1);
		}
		else
		{
			LoadSlot();
		}
	} ]

	LoadSlot1[ (s)
	{
		loadslot = 1;
		if( GameActive() )
		{
			bGoBack=1;
			ClearMenu();
			AddStaticItem(3282,false);
			AddMenuItem(1389, "OnDisplay");
			AddMenuItem(1375, "LoadSlot");
			funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
			funtext.SetFontNum(1);
			funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
			funtext.SetFontNum(1);
		}
		else
		{
			LoadSlot();
		}
	} ]

	LoadSlot2[ (s)
	{
		loadslot = 2;
		if( GameActive() )
		{
			bGoBack=1;
			ClearMenu();
			AddStaticItem(3282);
			AddMenuItem(1389, "OnDisplay");
			AddMenuItem(1375, "LoadSlot");
			funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
			funtext.SetFontNum(1);
			funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
			funtext.SetFontNum(1);
		}
		else
		{
			LoadSlot();
		}
	} ]

	LoadSlot3[ (s)
	{
		loadslot = 3;
		if( GameActive() )
		{
			bGoBack=1;
			ClearMenu();
			AddStaticItem(3282);
			AddMenuItem(1389, "OnDisplay");
			AddMenuItem(1375, "LoadSlot");
			funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
			funtext.SetFontNum(1);
			funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
			funtext.SetFontNum(1);
			
		}
		else
		{
			LoadSlot();
		}
	} ]

	LoadSlot[ (s)
	{
		//MenuBackground(20);
		LoadGame( loadslot );
	} ]

	LoadGameMenuBack[ (s)
	{
		if (bGoBack = 1)
		{
			OnDisplay();
		}
		else
		{
			OpenMenu("MainMenu");
		}
	} ]
	
	SaveCorrupted[ ()
	{
		//MenuBackground(69);
		failed.SetVisible(true);
	}]
	
	OnClosePopup[ ()
	{
		failed.SetVisible(false);
		if ( (GameAvailableForLoad(0) = false) and (GameAvailableForLoad(1) = false) and (GameAvailableForLoad(2) = false) and (GameAvailableForLoad(3) = false) )
		{
			OpenMenu("MainMenu");
		}
		else
		{
			OnDisplay();
		}
	}]
}