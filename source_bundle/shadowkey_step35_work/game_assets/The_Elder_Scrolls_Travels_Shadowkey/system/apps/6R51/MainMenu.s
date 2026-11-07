{
	myPopup
	savePopup
	reallySave
	activeItem
	outOfSpace

	Init[ (s)
	{
		MenuBackground(69);

		AddStaticItem(714);
		AddStaticItem(714);		
		
		CreateMenu("Menus\\\\NewGameMenu");
		CreateMenu("Menus\\\\ChooseCharacterMenu");
		CreateMenu("Menus\\\\ChooseRaceMenu");		
		CreateMenu("Menus\\\\ChoosePortraitMenu");
		CreateMenu("Menus\\\\NameChar");
		CreateMenu("Menus\\\\ShowCharacterClass");
		CreateMenu("Menus\\\\ShowRaceInfo");
		CreateMenu("Menus\\\\LoadingScreen");
		CreateMenu("Menus\\\\MultiPlayerMenu");
		CreateMenu("Menus\\\\HostGameMenu");
		CreateMenu("Menus\\\\JoinGameMenu");
		CreateMenu("Menus\\\\Bluetooth");
		CreateMenu("SaveGameMenu");
		CreateMenu("LoadGameMenu");
		CreateMenu("Options");
		CreateMenu("DeleteSavedGames");
		CreateMenu("ConfigKeys");
		CreateMenu("CheatMenu");
		CreateMenu("Menus\\\\DropGoldMenu");
		
		OnDisplay();
	} ]
	
	OnDisplay[ ()
	{
		activeItem = null;
		MenuBackground(69);
		ClearMenu();
		ClearNewGameHook();
		if (GameActive())
		{
			activeItem=AddMenuItem(1965,"MenuReturnToGame");
			if (CheatsActivated())
			{
				AddMenuItem(549, "MenuCheat");
			}
		}
		else
		{			
			AddMenuItem(716,"MenuNewGame");
		}

		if (GameAvailableForLoad() and not IsMultiplayer() )
		{
			AddMenuItem(717,"MenuLoadGame");
		}
		else
		{
			AddStaticItem(717,0);
		}

		if (GameActive() )
		{
			AddMenuItem(718,"MenuSaveGame");
		}
		//else
		//{		
		//	AddStaticItem(718,0);
		//}

		if(GameAvailableForLoad())
		{
			if( IsMultiplayer() = false )
			{
				AddMenuItem(3702, "MenuDeleteSaveGame");
			}
			else
			{
				AddStaticItem(3702, 0);
			}
		}
		else
		{
			AddStaticItem(3702, 0);
		}


		//AddStaticItem(714);
		if( not GameActive() )
		{
			if ( GameAvailableForLoad() )
			{
				AddMenuItem(1966,"MenuMultiPlayer");	
			}
			else
			{
				AddStaticItem(1966, 0);
			}
		}


		//AddStaticItem(714);
		AddMenuItem(719,"MenuOptions");
		if( not GameActive() )
		{
			AddMenuItem(3283, "MenuCredits");
		}
		//AddStaticItem(714);

		if( GameActive() )
		{
			AddMenuItem(3495, "MenuQuit");
		}
		else
		{
			AddMenuItem(3848,"MenuQuit");
		}
		
		myPopup=CreatePopupMenu(15,75,150,60);
		myPopup.AddItem(4019);
		myPopup.AddItem(4010,"CancelQuitGame");		
		myPopup.AddItem(4009,"ConfirmQuitGame");
		myPopup.SetBack("CancelQuitGame");
		myPopup.SetSelectable(0,false);
		myPopup.SetVisible(false);
		myPopup.SetSelectedItem(1);
		myPopup.SetBackground();

		savePopup=CreatePopupMenu(15,75,150,70);
		savePopup.AddItem(4020);
		savePopup.AddItem(4009,"GoSave");
		savePopup.AddItem(4010,"CancelEndGame");
		savePopup.SetBack("CancelQuitGame");
		savePopup.SetSelectable(0,false);
		savePopup.SetVisible(false);
		savePopup.SetSelectedItem(1);
		savePopup.SetBackground();

		reallySave=CreatePopupMenu(15,75,150,70);
		reallySave.AddItem(4026);
		reallySave.AddItem(4010,"CancelSaveGame");	
		reallySave.AddItem(4009,"ConfirmSaveGame");
		reallySave.SetSelectable(0,false);
		reallySave.SetVisible(false);
		reallySave.SetSelectedItem(1);
		reallySave.SetBackground();

		outOfSpace=CreatePopupMenu(15,75,150,110);
		outOfSpace.AddItem(4027);
		outOfSpace.AddItem(4028,"CancelOutOfSpace");
		outOfSpace.SetBack("CancelOutOfSpace");
		outOfSpace.SetSelectable(0,false);
		outOfSpace.SetVisible(false);
		outOfSpace.SetSelectedItem(1);
		outOfSpace.SetBackground();

		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);
		if( GameActive() )
		{
			funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
			funtext.SetFontNum(1);
		}

		UnFadeMusic();
		
	}]

	MenuHostMulti[ (s)
	{
		MenuBackground(20);
		OpenMenu("Menus\\\\HostGameMenu");
	} ]

	MenuJoinMulti[ (s)
	{
		MenuBackground(20);
		OpenMenu("Menus\\\\JoinGameMenu");
	} ]

	MenuMultiPlayer[ (s)
	{
		//ArenaConnect();
		//OpenMenu("Arena");
		MenuBackground(20);
		OpenMenu("Menus\\\\MultiPlayerMenu");
	} ]

	MenuNewGame[ (s)
	{
		// Tell the engine to start a new game
		//NewGame();
		GetPlayer().SetPlayerClassFlag(false);
		MenuBackground(20);
		OpenMenu("Menus\\\\NewGameMenu");
	} ]

	MenuLoadGame[ (s)
	{
		// Tell the engine to load a new game (probably opens a new menu)
		//MenuBackground(20);
		//Quit();
		//LoadGame();
		OpenMenu("LoadGameMenu");
	} ]

	MenuSaveGame[ (s)
	{
		// Tell the engine to save a new game (probably opens a new menu)
		//SaveGame("SaveGameCallBack");
		if( IsMultiplayerClient() )
		{
			reallySave.SetVisible( true );
			reallySave.SetSelectedItem( 1 );
		}
		else
		{
			OpenMenu("SaveGameMenu");
		}
	} ]
	
	MenuDeleteSaveGame[()
	{
		OpenMenu("DeleteSavedGames");
	}]

	SaveGameCallBack[(s)
	{
		MenuBackground(20);
		ClearMenu();
		if(s = 1)
		{
			AddStaticItem(1967);
		}
		else
		{
			AddStaticItem(1968);
		}
		AddMenuItem(386, "Quit");
	}]

	MenuOptions[ (s)
	{
		//Options();
		MenuBackground(20);
		OpenMenu("Options");		
	} ]

	MenuCredits[ (s)
	{
		ShowCredits();
	} ]

	MenuReturnToGame[ (s)
	{
		MenuBackground(20);
		Quit();
	} ]

	MenuQuit[ (s)
	{
		myPopup.SetVisible(true);
		myPopup.SetSelectedItem(1);
	} ]

	MenuEndGame[ (s)
	{
		savePopup.SetVisible(true);
	} ]

	MenuCheat[ (s)
	{
		MenuBackground(20);
		OpenMenu("CheatMenu");
	} ]

	OnRightSoftkey[ (s)
	{
		MenuBackground(20);
		MenuQuit();
	} ]

	ConfirmQuitGame[ (s)
	{
		if( GameActive() )
		{
			myPopup.SetVisible(false);
			savePopup.SetVisible(true);
			savePopup.SetSelectedItem(1);
		}
		else
		{
			myPopup.SetVisible(false);
			savePopup.SetVisible(false);
			MenuBackground(20);
			QuitGame();
		}
	} ]

	CancelQuitGame[ (s)
	{	
		savePopup.SetVisible(false);
		myPopup.SetVisible(false);
		myPopup.SetSelectedItem(1);
		SetSelectedItem(GetPrevItem());
	} ]

	GoSave[ (s)
	{
		savePopup.SetVisible(false);
		myPopup.SetVisible(false);
		if( IsMultiplayerClient() )
		{
			SetQuitAfterSave(true);
			reallySave.SetVisible( true );
			reallySave.SetSelectedItem( 1 );
		}
		else
		{
			SetQuitAfterSave(true);
			OpenMenu("SaveGameMenu");
		}
	} ]

	CancelEndGame[ (s)
	{
		myPopup.SetVisible(false);
		savePopup.SetVisible(false);
		QuitToMenu();
		OnDisplay();
	} ]

	MainMenuBack[ (s)
	{
		if( GameActive() )
		{
			MenuBackground(20);
			Quit();
		}
	} ]

	CancelSaveGame[ (s)
	{
		reallySave.SetVisible( false );
		prevItem = GetPrevItem();
		if (prevItem != null)
		{
			SetSelectedItem(prevItem);
		}

	} ]

	ConfirmSaveGame[ (s)
	{
		reallySave.SetVisible( false );
		ActuallySaveGame( GetMultiplayerSlot() );
		prevItem = GetPrevItem();
		if (prevItem != null)
		{
			SetSelectedItem(prevItem);
		}
	} ]

	CancelOutOfSpace[ (s)
	{
		outOfSpace.SetVisible( false );
		SetSelectedItem(activeItem);
	} ]

	NotEnoughSpace[ (s)
	{
		outOfSpace.SetVisible( true );
		outOfSpace.SetSelectedItem(1);
	} ]

}