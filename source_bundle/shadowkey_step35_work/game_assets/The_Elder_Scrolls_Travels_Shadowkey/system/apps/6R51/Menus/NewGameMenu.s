{	
	start
	first
	
	Init[ ()
	{			
		MenuBackground(20);								
	} ]
	
	OnDisplay[ ()
	{
		ClearMenu();
		
		first=AddMenuItem(1991,"ChooseCharacter");
		//AddMenuItem(1992,"ChooseRace");
		
		//AddMenuItem(1993, "NameCharacter");
		//AddMenuItem(1994,"ChoosePortrait");
		start=AddMenuItem(1995,"StartGame");				
				
		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
			
		bCreatedChr=GetPlayer().HasCreatedCharacter();
		start.SetSelectable(bCreatedChr);
		SetSelectedItem(first);
	}]

	ChooseCharacter[ ()
	{
		OpenMenu("Menus\\\\ChooseCharacterMenu");
	}]
	
	ChooseRace[ ()
	{
		OpenMenu("Menus\\\\ChooseRaceMenu");
	}]
		
	NameCharacter[()
	{
		OpenMenu("Menus\\\\NameChar");
	}]

	ChoosePortrait[ ()
	{
		OpenMenu("Menus\\\\ChoosePortraitMenu");
	}]
			
	StartGame[ ()
	{
		newGame = NewGameHook();
		if( newGame = 0 )
		{
			NewGame();
		}
		if( newGame = 1 )
		{
			OpenMenu("Menus\\\\HostGameMenu");
		}
		if( newGame = 2 )
		{
			OpenMenu("Menus\\\\JoinGameMenu");
		}
	}]
	
	OnRightSoftKey[ (s)
	{
		MenuQuit();
	} ]	
		
	MenuQuit[ ()
	{
		OpenMenu("MainMenu");
	}]

	NewGameMenuBack[ ()
	{
		MenuQuit();
	}]

}