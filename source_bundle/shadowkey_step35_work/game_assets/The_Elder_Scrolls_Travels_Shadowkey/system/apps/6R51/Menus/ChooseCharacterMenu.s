{
	textArea
	comboBox
	
	Init[ ()
	{
		//OpenMenu Menus\\\\ChooseCharacterMenu
		MenuBackground(20);
		SetPrevMenu("Menus\\\\NewGameMenu");

	} ]
	
	OnDisplay[ ()
	{
		ClearMenu();
		AddTitle(3783);
		
		comboBox=AddComboBox(15, 30);
		comboBox.SetWidth(140);
		comboBox.AddOption(32);
		comboBox.AddOption(33);
		comboBox.AddOption(34);
		comboBox.AddOption(35);
		comboBox.AddOption(36);
		comboBox.AddOption(37);
		comboBox.AddOption(38);
		comboBox.AddOption(39);	
		comboBox.AddOption(40);
		comboBox.SetCallback("OnComboSel");	
		comboBox.SetOnEnterCallback("OnChooseCharacter");
		
		textArea=AddTextArea(5, 45);
		textArea.SetLocalizedText(1996);
		textArea.SetTextWidth(27);
		textArea.SetSelectable(false);

		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
				
		OnComboSel();
	}]
		
	OnComboSel[ ()
	{
		index = comboBox.GetSelection();
		textArea.SetLocalizedText(1996 + index);
	}]		
		
	OnChooseCharacter[ (s)
	{
		classId = comboBox.GetSelection();
		GetPlayer().ChooseCharacter(classId);
		
		//TODO: prompt user can we save their profile to memory card	
		//SaveGame();
				
		OpenMenu("Menus\\\\ChooseRaceMenu");		
	}]


	ChooseCharacterMenuBack[ (s)
	{
		OpenMenu("Menus\\\\NewGameMenu");
	} ]	
}