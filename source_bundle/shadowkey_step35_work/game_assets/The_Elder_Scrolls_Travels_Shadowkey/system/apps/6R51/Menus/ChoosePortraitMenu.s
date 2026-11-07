{	
	maleId[0]
	femaleId[0]
	male
	female
	race[0]
	
	Init[ (s)
	{	
		MenuBackground(20);							
				
	} ]
	
	OnDisplay[ ()
	{	
		ClearMenu();
		AddTitle(1981);
		male=AddFloatingSprite(maleId, "ChooseMale", 25, 70, true);	
		female=AddFloatingSprite(femaleId, "ChooseFemale", 90, 70, true);
		SetUseHoriz(true);
				
		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);

		race = GetPlayer().GetRace();
		maleId = GetMalePortrait(race);
		femaleId = GetFemalePortrait(race);
		male.SetSprite(maleId);
		female.SetSprite(femaleId);	
	}]
	
	ChooseMale[ ()
	{
		GetPlayer().SetPortraitID(maleId);
		GetPlayer().SetSex(true);
		GetPlayer().UpdateAttributes(true);
		OpenMenu("Menus\\\\NameChar");
	}]
	
	ChooseFemale[ ()
	{
		GetPlayer().SetPortraitID(femaleId);
		GetPlayer().SetSex(false); 
		GetPlayer().UpdateAttributes(true);
		OpenMenu("Menus\\\\NameChar");
	}]
			
	ChoosePortraitMenuBack[ ()
	{
		OpenMenu("Menus\\\\ChooseRaceMenu");
	}]
}