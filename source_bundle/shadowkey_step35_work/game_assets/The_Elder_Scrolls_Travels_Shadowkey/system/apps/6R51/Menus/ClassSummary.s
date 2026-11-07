{
	statsTable
	
	Init[ (s)
	{
		ClearMenu();
		MenuBackground(20);

		AddTitle("Class Summary");
		
		statsTable=AddTable(12, 15, 20, 180, 160);
		statsTable.AddColumn(115);
		statsTable.AddColumn(50);
		//statsTable.SetSelectable(false);	
		
		statsTable.SetText(0, 0, "Strength:");
		statsTable.SetText(1, 0, "Will Power:");
		statsTable.SetText(2, 0, "Speed:");
		statsTable.SetText(3, 0, "Personality:");
		statsTable.SetText(4, 0, "Intelligence:");
		statsTable.SetText(5, 0, "Agility:");
		statsTable.SetText(6, 0, "Endurance:");
		statsTable.SetText(7, 0, "Luck:");		
		statsTable.SetText(8, 0, "Defense:");		
		statsTable.SetText(9, 0, "Experience:");
		statsTable.SetText(10, 0, "Next Level+:");
		statsTable.SetText(11, 0, "Special Ability:");
		statsTable.SetCallback("OnTableSel");
	
		
		//AddQuitButton("Back","MenuBack");	
		funtext=AddFloatingTextJustify("Accept", 0, 195, false,32767);
		funtext.SetFontNum(1);
		funtext=AddFloatingTextJustify("Back", 176, 195, true,32767);
		funtext.SetFontNum(1);
	} ]
		
	OnDisplay[ ()
	{
		statsTable.SetText(0, 1, GetPlayer().GetStrength());
		statsTable.SetText(1, 1, GetPlayer().GetWil());
		statsTable.SetText(2, 1, GetPlayer().GetSpeed());
		statsTable.SetText(3, 1, GetPlayer().GetPersonality());
		statsTable.SetText(4, 1, GetPlayer().GetIntelligence());
		statsTable.SetText(5, 1, GetPlayer().GetAgility());
		statsTable.SetText(6, 1, GetPlayer().GetEndurance());
		statsTable.SetText(7, 1, GetPlayer().GetLuck());
		statsTable.SetText(8, 1, GetPlayer().GetDefense());
		statsTable.SetText(9, 1, GetPlayer().GetExperience());
		statsTable.SetText(10, 1, GetPlayer().GetExpToNextLevel());	
		
		statsTable.SetText(11, 0, GetPlayer().GetSpecialAbilityText());	
		statsTable.SetText(11, 1, GetPlayer().GetSpecialAbility());
	}]
	
	OnTableSel[ ()
	{
		SetSelectedItem(back);
	}]		
}