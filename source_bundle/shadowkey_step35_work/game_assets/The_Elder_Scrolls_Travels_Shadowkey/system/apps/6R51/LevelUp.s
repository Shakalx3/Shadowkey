{
	myPopup
	strbut
	intbut
	wilbut
	agibut
	spdbut
	endbut
	perbut
	lucbut
			
	Init[ (s)
	{
		MenuBackground(20);
	} ]

	OnDisplay[ (s)
	{
		MenuBackground(20);
		SetStartCoord(10);

		LevelUpPoints = GetPlayer().GetLevelUpPoints();
		if( LevelUpPoints < 1 )
		{
			Quit();
		}

		ClearMenu();
		AddStaticItem(1886, false);
		AddStaticItem(179);
		if( LevelUpPoints = 1 )
		{
			AddStaticItem(GetLocalizedString(3806)#" " # LevelUpPoints # GetLocalizedString(3807), false);
		}
		else
		{
			AddStaticItem(GetLocalizedString(3806)#" " # LevelUpPoints # GetLocalizedString(3807), false);
		}
		strbut=AddMenuItem(1887, "AskStr");
		intbut=AddMenuItem(1888, "AskInt");
		wilbut=AddMenuItem(1889, "AskWil");
		agibut=AddMenuItem(1890, "AskAgi");
		spdbut=AddMenuItem(1891, "AskSpd");
		endbut=AddMenuItem(1892, "AskEnd");
		perbut=AddMenuItem(1893, "AskPer");
		lucbut=AddMenuItem(1894, "AskLuck");

		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);

		myPopup=CreatePopupMenu(15,75,150,60);
		myPopup.AddItem(4018);
		myPopup.AddItem(4010,"CancelStat");
		myPopup.AddItem(4009,"ConfirmStat");
		myPopup.SetBack("CancelStat");
		myPopup.SetSelectable(0,false);
		myPopup.SetVisible(false);
		myPopup.SetSelectedItem(1);
		myPopup.SetBackground();
		myPopup.SetAutoAdjust(true);
	} ]

	CancelStat[ (s)
	{
		myPopup.SetVisible(false);
		prevItem = GetPrevItem();
		if (prevItem != null)
		{
			SetSelectedItem(prevItem);
		}
	} ]

	AskStr[ (s)
	{
		myPopup.SetVisible( true );
		myPopup.SetSelectedItem( 1 );
		myPopup.UpdatePopupItem( 2, 4009, "ChooseStr" );
	} ]
	
	ChooseStr[ (s)
	{
		myPopup.SetVisible( false );
		GetPlayer().SetStrength( GetPlayer().GetStrength() + 5 );
		GetPlayer().DecreaseLevelUpPoints();
		OnDisplay();
		SetSelectedItem(strbut);		
	} ]

	AskInt[ (s)
	{
		myPopup.SetVisible( true );
		myPopup.SetSelectedItem( 1 );
		myPopup.UpdatePopupItem( 2, 4009, "ChooseInt" );
	} ]

	ChooseInt[ (s)
	{
		myPopup.SetVisible( false );
		GetPlayer().SetIntelligence( GetPlayer().GetIntelligence() + 5 );
		GetPlayer().DecreaseLevelUpPoints();
		OnDisplay();
		SetSelectedItem(intbut);		
	} ]

	AskWil[ (s)
	{
		myPopup.SetVisible( true );
		myPopup.SetSelectedItem( 1 );
		myPopup.UpdatePopupItem( 2, 4009, "ChooseWil" );
	} ]

	ChooseWil[ (s)
	{
		myPopup.SetVisible( false );
		GetPlayer().SetWillpower( GetPlayer().GetWillpower() + 5 );
		GetPlayer().DecreaseLevelUpPoints();
		OnDisplay();
		SetSelectedItem(wilbut);	
	} ]

	AskAgi[ (s)
	{
		myPopup.SetVisible( true );
		myPopup.SetSelectedItem( 1 );
		myPopup.UpdatePopupItem( 2, 4009, "ChooseAgi" );
	} ]

	ChooseAgi[ (s)
	{
		myPopup.SetVisible( false );
		GetPlayer().SetAgility( GetPlayer().GetAgility() + 5 );
		GetPlayer().DecreaseLevelUpPoints();
		OnDisplay();
		SetSelectedItem(agibut);	
	} ]

	AskSpd[ (s)
	{
		myPopup.SetVisible( true );
		myPopup.SetSelectedItem( 1 );
		myPopup.UpdatePopupItem( 2, 4009, "ChooseSpd" );
	} ]

	ChooseSpd[ (s)
	{
		myPopup.SetVisible( false );
		GetPlayer().SetSpeed( GetPlayer().GetSpeed() + 5 );
		GetPlayer().DecreaseLevelUpPoints();
		OnDisplay();
		SetSelectedItem(spdbut);		
	} ]

	AskEnd[ (s)
	{
		myPopup.SetVisible( true );
		myPopup.SetSelectedItem( 1 );
		myPopup.UpdatePopupItem( 2, 4009, "ChooseEnd" );
	} ]

	ChooseEnd[ (s)
	{
		myPopup.SetVisible( false );
		GetPlayer().SetEndurance( GetPlayer().GetEndurance() + 5 );
		GetPlayer().DecreaseLevelUpPoints();
		OnDisplay();
		SetSelectedItem(endbut);		
	} ]

	AskPer[ (s)
	{
		myPopup.SetVisible( true );
		myPopup.SetSelectedItem( 1 );
		myPopup.UpdatePopupItem( 2, 4009, "ChoosePer" );
	} ]

	ChoosePer[ (s)
	{
		myPopup.SetVisible( false );
		GetPlayer().SetPersonality( GetPlayer().GetPersonality() + 5 );
		GetPlayer().DecreaseLevelUpPoints();
		OnDisplay();
		SetSelectedItem(perbut);	
	} ]

	AskLuck[ (s)
	{
		myPopup.SetVisible( true );
		myPopup.SetSelectedItem( 1 );
		myPopup.UpdatePopupItem( 2, 4009, "ChooseLuck" );
	} ]

	ChooseLuck[ (s)
	{
		myPopup.SetVisible( false );
		GetPlayer().SetLuck( GetPlayer().GetLuck() + 5 );
		GetPlayer().DecreaseLevelUpPoints();
		OnDisplay();
		SetSelectedItem(lucbut);	
	} ]

	LevelUpBack[ (s)
	{
		if( myPopup.IsVisible() )
		{
			myPopup.SetVisible( false );
			return;
		}

		GetPlayer().UpdateAttributes(false);
		Quit();
	} ]
}