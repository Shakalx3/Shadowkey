{
	myPopup
	langStr ["temp"]
	langButton
	muteButton
	
	Init[ (s)
	{
		MenuBackground(20);
		
		SetPrevMenu("MainMenu");
		
		AddStaticItem(714);
		AddMenuSlider(4062,"SoundFXSlider",100,10);
		AddMenuSlider(4063,"MusicSlider",100,10);
		AddStaticItem(714);
		
		langStr = GetLanguageStr();
		if ( (GameActive() = true) and (langStr = "ENGLISH") )
		{
			if (GetPlayer().GetInvulnerable())
			{
				AddMenuItem(2160,"GodModeOFF");
			}
			else
			{
				AddMenuItem(2161,"GodModeON");
			}
		}
		else
		{
			AddStaticItem(714);
		}

		langButton=AddMenuItem(4056,"PopLanguage");				
		AddMenuItem(3286,"CustControlsMenu");

		//funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		//funtext.SetFontNum(1);
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);

		if(MuteOnCall())
		{
			muteButton=AddMenuItem(3553, "MuteOff");
		}
		else
		{
			muteButton=AddMenuItem(3554, "MuteOn");
		}
		
		if (GameActive())
		{
			myPopup=CreatePopupMenu(15,75,150,90);
			myPopup.AddItem(langStr);
			myPopup.AddItem("English","SetEnglish");
			myPopup.AddItem("Español","SetSpanish");
			myPopup.AddItem("Deutsch","SetGerman");
			myPopup.AddItem("Français","SetFrench");
			myPopup.AddItem("Italiano","SetItalian");
			myPopup.AddItem("UK English","SetEnglishUK");
			myPopup.SetSelectable(0,false);
			myPopup.SetVisible(false);
			myPopup.SetSelectedItem(1);
			myPopup.SetBackground();
			myPopup.SetBack("OptionsClosePopup");
		}
		else
		{
			myPopup=CreatePopupMenu(15,75,150,90);
			myPopup.AddItem(langStr);
			myPopup.AddItem("English","SetEnglish");
			myPopup.AddItem("Español","SetSpanish");
			myPopup.AddItem("Deutsch","SetGerman");
			myPopup.AddItem("Français","SetFrench");
			myPopup.AddItem("Italiano","SetItalian");
			myPopup.AddItem("UK English","SetEnglishUK");
			myPopup.SetSelectable(0,false);
			myPopup.SetVisible(false);
			myPopup.SetSelectedItem(1);
			myPopup.SetBackground();
			myPopup.SetBack("OptionsClosePopup");

		}
		
	} ]
	
	SetEnglish[ ()
	{
		SetLanguage(0);
		myPopup.SetVisible(false);
		ClearMenu();
		Init();
		SetSelectedItem(langButton);
	} ]
	
	SetSpanish[ ()
	{
		SetLanguage(1);
		myPopup.SetVisible(false);
		ClearMenu();
		Init();
		SetSelectedItem(langButton);
	} ]
	
	SetGerman[ ()
	{
		SetLanguage(2);
		myPopup.SetVisible(false);
		ClearMenu();
		Init();
		SetSelectedItem(langButton);
	} ]
	
	SetFrench[ ()
	{
		SetLanguage(3);
		myPopup.SetVisible(false);
		ClearMenu();
		Init();
		SetSelectedItem(langButton);
	} ]
	
	SetItalian[ ()
	{
		SetLanguage(4);
		myPopup.SetVisible(false);
		ClearMenu();
		Init();
		SetSelectedItem(langButton);
	} ]
	
	SetEnglishUK[ ()
	{
		SetLanguage(5);
		myPopup.SetVisible(false);
		ClearMenu();
		Init();
		SetSelectedItem(langButton);
	} ]

	OptionsClosePopup[ ()
	{
		myPopup.SetVisible(false);
		SetSelectedItem(langButton);
	} ]

	
	PopLanguage[ ()
	{
		langStr = GetLanguageStr();
		myPopup.UpdatePopupItem(0,""#langStr);

		myPopup.SetVisible(true);
		myPopup.SetSelectedItem(1);
	} ]
	
	OptionsBack[ (s)
	{
		OpenMenu("MainMenu");
	} ]

	CustControlsMenu[ (s)
	{
		OpenMenu("ConfigKeys");
	} ]

	GodModeOFF[ (s)
	{
		GetPlayer().SetInvulnerable(false);
		ClearMenu();
		Init();
	} ]

	GodModeON[ (s)
	{
		GetPlayer().SetInvulnerable(true);
		ClearMenu();
		Init();
	} ]

	OnRightSoftkey[ (s)
	{
		OptionsMenuBack();
	} ]

	MuteOff[()
	{
		SetMuteOnCall(false);
		ClearMenu();
		Init();
		SetSelectedItem(muteButton);
	}]
	MuteOn[()
	{
		SetMuteOnCall(true);
		ClearMenu();
		Init();
		SetSelectedItem(muteButton);
	}]

}