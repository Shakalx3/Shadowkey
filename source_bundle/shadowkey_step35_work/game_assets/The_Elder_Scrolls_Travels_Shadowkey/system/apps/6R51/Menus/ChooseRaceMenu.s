{
	comboBox
	textArea
	
	Init[ ()
	{
		MenuBackground(20);				
	} ]
	
	OnDisplay[ ()
	{
		ClearMenu();
		AddTitle(3784);
				
		comboBox=AddComboBox(15, 30);
		comboBox.SetWidth(140);
		comboBox.AddOption(1982); //argonian
		comboBox.AddOption(1983); //breton
		comboBox.AddOption(1984); //dark elf
		comboBox.AddOption(1985); //high elf
		comboBox.AddOption(1986); //khajit
		comboBox.AddOption(1987); //nord
		comboBox.AddOption(1988); //redguard
		comboBox.AddOption(1989); //wood elf
		comboBox.SetCallback("OnComboSel");	
		comboBox.SetOnEnterCallback("OnChooseRace");
		
		textArea=AddTextArea(5, 45);
		textArea.SetLocalizedText(2016);
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
		textArea.SetLocalizedText(2016 + index);
	}]
				
	OnChooseRace[ (s)
	{
		raceId = comboBox.GetSelection();
		GetPlayer().ChooseRace(raceId);
		OpenMenu("Menus\\\\ChoosePortraitMenu");
	}]
	
	ChooseRaceMenuBack[ (s)
	{
		OpenMenu("Menus\\\\ChooseCharacterMenu");
	} ]
}