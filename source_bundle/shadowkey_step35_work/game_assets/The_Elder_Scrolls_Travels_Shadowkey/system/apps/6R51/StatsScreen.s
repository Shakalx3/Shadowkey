{
	statsTable
	back
	comboBox
			
	Init[ (s)
	{	
		MenuBackground(20);
	} ]
	
	OnDisplay[ ()
	{
		ClearMenu();
		comboBox=AddComboBox(15, 7);
		comboBox.SetWidth(140);		
		comboBox.AddOption(3043); //stats
		comboBox.AddOption(3042); //skills
		comboBox.SetCallback("OnComboSel");
		
		statsTable=AddTable(15, 15, 25, 180, 150);
		statsTable.AddColumn(100);
		statsTable.AddColumn(60);
		statsTable.SetCellSpacing(10);
		statsTable.SetSelectable(true);	
		//statsTable.SetRowSelect(true);
		statsTable.SetCallback("OnTableSel");	
		//statsTable.SetLineWrap(true);	
		
		back=AddQuitButton(3281,"MenuBack");	
		SetSelectedItem(comboBox);

		//ondisplay	
		OnComboSel();
	}]
	
	ShowStats[ ()
	{
		statsTable.Clear();
		statsTable.SetText(0, 0, GetLocalizedString(1887)#":");		
		statsTable.SetText(0, 1, ""#GetPlayer().GetStrength() + GetPlayer().GetStrengthBonus());
		
		statsTable.SetText(1, 0, GetLocalizedString(1889)#":");
		statsTable.SetText(1, 1, ""#GetPlayer().GetWill());
		
		statsTable.SetText(2, 0, GetLocalizedString(1891)#":");
		statsTable.SetText(2, 1, ""#GetPlayer().GetSpeed());
		
		statsTable.SetText(3, 0, GetLocalizedString(1893)#":");
		statsTable.SetText(3, 1, ""#GetPlayer().GetPersonality());
		
		statsTable.SetText(4, 0, GetLocalizedString(1888)#":");
		statsTable.SetText(4, 1, ""#GetPlayer().GetIntelligence());
		
		statsTable.SetText(5, 0, GetLocalizedString(1890)#":");
		statsTable.SetText(5, 1, ""#GetPlayer().GetAgility());
		
		statsTable.SetText(6, 0, GetLocalizedString(1892)#":");
		statsTable.SetText(6, 1, ""#GetPlayer().GetEndurance());
		
		statsTable.SetText(7, 0, GetLocalizedString(1894)#":");		
		statsTable.SetText(7, 1, ""#GetPlayer().GetLuck());
		
		statsTable.SetText(8, 0, GetLocalizedString(3046)#":");	
		statsTable.SetText(8, 1, ""#GetPlayer().GetDefense());	
		
		statsTable.SetText(9, 0, GetLocalizedString(3045)#":");	
		statsTable.SetText(9, 1, ""#GetPlayer().GetAttack());				
				
		statsTable.SetText(10, 0, GetLocalizedString(3051)#":");	
		statsTable.SetText(10, 1, ""#GetPlayer().GetArmorRating());	
						
		statsTable.SetText(11, 0, GetLocalizedString(3781)#":");
		statsTable.SetText(11, 1, ""#GetPlayer().GetSpellToHit());
		statsTable.SetText(12, 0, GetLocalizedString(3782)#":");
		statsTable.SetText(12, 1, ""#GetPlayer().GetSpellResistance());	
						
		statsTable.SetText(13, 0, GetLocalizedString(3067)#":");
		statsTable.SetText(13, 1, ""#GetPlayer().GetExperience());
		
		statsTable.SetText(14, 0, GetLocalizedString(3780)#":");				
		statsTable.SetText(14, 1, ""#GetPlayer().GetExpToNextLevel());																																
					
	}]
	
	ShowSkills[ ()
	{
		statsTable.Clear();
		statsTable.SetText(0, 0, GetPlayer().GetSpecialAbilityText());	
		statsTable.SetText(0, 1, ""#GetPlayer().GetSpecialAbility());		
		statsTable.SetText(1, 0, GetPlayer().GetRaceAbilityText());	
		statsTable.SetText(1, 1, ""#GetPlayer().GetRaceAbility());		
	}]
	
	OnTableSel[ ()
	{
		SetSelectedItem(back);
	}]
	
	OnComboSel[ ()
	{
		index = comboBox.GetSelection();
		if (index = 1)
		{
			ShowSkills();
		}
		else
		{
			ShowStats();
		}
	}]

	OnRightSoftKey[ (s)
	{
		DisplayCharacterManager();
	} ]
	
	MenuBack[ (s)
	{
		DisplayCharacterManager();
	} ]

	StatsScreenBack[ (s)
	{
		DisplayCharacterManager();
	} ]

}