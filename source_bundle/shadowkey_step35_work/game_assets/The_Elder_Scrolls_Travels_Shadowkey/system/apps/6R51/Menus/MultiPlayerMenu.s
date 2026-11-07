{
	myPopup
	askPopup
	whichAsk
	whichGame
	activeItem
	hostButton
	joinButton
	bluetoothButton

	Init[ (s)
	{	
		SetPrevMenu("MainMenu");
		MenuBackground(20);
		return;
	} ]

	OnDisplay[ ()
	{	
		ClearMenu();
		AddStaticItem(3527,false);
		AddStaticItem(714);
		hostButton=AddMenuItem(3528, "MenuAskHost");
		joinButton=AddMenuItem(3529,"MenuAskJoin");
		bluetoothButton=AddMenuItem(3496, "MenuBluetooth");
		activeItem = bluetoothButton;

		myPopup=CreatePopupMenu(15,75,150,90);
		myPopup.AddItem(4021);
		myPopup.AddItem(4009,"TurnOnBT");
		myPopup.AddItem(4010,"DoNotTurnOnBT");		
		myPopup.SetBack("CloseBTPopup");
		myPopup.SetSelectable(0,false);
		myPopup.SetVisible(false);
		myPopup.SetSelectedItem(1);
		myPopup.SetBackground();

		whichAsk = 0;

		askPopup=CreatePopupMenu(15,75,150,90);
		askPopup.AddItem(4022);
		askPopup.AddItem(3281,"Cancel");
		askPopup.SetSelectable(0,false);
		askPopup.SetVisible(false);
		askPopup.SetSelectedItem(1);
		askPopup.SetBackground();
		askPopup.SetBack("Cancel");
		
		if( not GetBluetoothStatus() )
		{
			// do popup
			myPopup.SetVisible(true);

		}

		//AddQuitButton("Back","MenuBack");
		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);

		FadeMusic();
	} ]
	
	ArenaMenu[ (s)
	{
		if (not ArenaActive())
		{
			ArenaConnect();
		}
	} ]

	MenuDownloads[ (s)
	{
		MenuBackground(20);
		OpenMenu("Menus\\\\DownloadsMenu");
	} ]

	MenuBluetooth[ (s)
	{
		activeItem=bluetoothButton;
		OpenMenu("Menus\\\\Bluetooth");
	} ]

	MenuHostMultiDirect[ (s)
	{
		MPPreHost();
		MenuBackground(20);
		OpenMenu("Menus\\\\HostGameMenu");
	} ]

	MenuJoinMultiDirect[ (s)
	{
		MPPreJoin();
		MenuBackground(20);
		OpenMenu("Menus\\\\JoinGameMenu");
	} ]

	MenuHostMulti[ (s)
	{
		if( MPPreHost() )
		{
			MenuBackground(20);
			OpenMenu("Menus\\\\HostGameMenu");
		}
		else
		{
			MenuBackground(20);
			OpenMenu("Menus\\\\NewGameMenu");
		}
		
	} ]

	MenuJoinMulti[ (s)
	{
		if( MPPreJoin() )
		{
			MenuBackground(20);
			OpenMenu("Menus\\\\JoinGameMenu");
		}
		else
		{
			MenuBackground(20);
			OpenMenu("Menus\\\\NewGameMenu");
		}
	} ]

	MultiPlayerMenuBack[ (s)
	{
		if( myPopup.IsVisible() )
		{
			myPopup.SetVisible( false );
			return;
		}
		if( askPopup.IsVisible() )
		{
			askPopup.SetVisible( false );
			return;
		}
		UnFadeMusic();
		OpenMenu("MainMenu");
	} ]

	TurnOnBT[ (s)
	{
		SetBluetooth( true );
		myPopup.SetVisible( false );
		SetSelectedItem(bluetoothButton);
		/*
		prevItem = GetPrevItem();
		if (prevItem != null)
		{
			SetSelectedItem(prevItem);
		}
		*/
	} ]

	DoNotTurnOnBT[ (s)
	{
		myPopup.SetVisible( false );
		OpenMenu("MainMenu");
	} ]
	
	CloseBTPopup[ ()
	{
		SetSelectedItem(bluetoothButton);
		myPopup.SetVisible( false );
		OpenMenu("MainMenu");			
	}]

	ProcessSavedGames[ (s)
	{
		askPopup.ClearMenu();		
		askPopup.AddItem(4023);
		askPopup.AddItem(3281,"Cancel");
		askPopup.SetSelectable(0,false);
		askPopup.SetSelectedItem(1);
		
		if( GameAvailableForLoad(0) )
		{
			askPopup.AddItem(3276, "Game1");			
		}
		if( GameAvailableForLoad(1) )
		{
			askPopup.AddItem(3278, "Game2");
		}
		if( GameAvailableForLoad(2) )
		{
			askPopup.AddItem(3279, "Game3");
		}
		if( GameAvailableForLoad(3) )
		{
			askPopup.AddItem(3280, "Game4");
		}
	} ]

	MenuAskHost[ (s)
	{
		activeItem=hostButton;
		ProcessSavedGames();
		askPopup.SetVisible( true );
		askPopup.SetSelectedItem( 1 );
		whichAsk = 0;
	} ]

	MenuAskJoin[ (s)
	{
		activeItem=joinButton;
		ProcessSavedGames();
		askPopup.SetVisible( true );
		askPopup.SetSelectedItem( 1 );
		whichAsk = 1;
	} ]

	NewCharHook[ (s)
	{
		if( whichAsk = 0 )
		{
			ClearNewGameHook(1);
		}		
		if( whichAsk = 1 )
		{
			ClearNewGameHook(2);
		}
		MenuBackground(20);
		OpenMenu("Menus\\\\NewGameMenu");
	} ]

	DoIt[ (s)
	{
		if( whichAsk = 0 )
		{
			MPPreHost( whichGame );
			MenuBackground(20);
			OpenMenu("Menus\\\\HostGameMenu");
		}
		else
		{
			MPPreJoin( whichGame );
			MenuBackground(20);
			OpenMenu("Menus\\\\JoinGameMenu");
		}
	} ]

	Game1[ (s)
	{
		ClearNewGameHook(0);
		whichGame = 0;
		DoIt();		
	} ]

	Game2[ (s)
	{
		ClearNewGameHook(0);
		whichGame = 1;
		DoIt();
	} ]

	Game3[ (s)
	{
		ClearNewGameHook(0);
		whichGame = 2;
		DoIt();
	} ]

	Game4[ (s)
	{
		ClearNewGameHook(0);
		whichGame = 3;
		DoIt();
	} ]

	Cancel[ (s)
	{
		SetSelectedItem(activeItem);
		askPopup.SetVisible( false );
	} ]
}