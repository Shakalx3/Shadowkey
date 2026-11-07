{
	Init[ (s)
	{
		SetPrevMenu("SaveGameMenu");
	} ]

	OnDisplay[ (s)
	{
		ClearMenu();
		if( GameAvailableForLoad( GetSaveSlot() ) )
		{
			AddStaticItem(3297);
			AddStaticItem(3298);
			AddMenuItem(1375, "ActuallySaveGame");
			AddMenuItem(1389, "SaveConfirmBack");
			funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
			funtext.SetFontNum(1);
			funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
			funtext.SetFontNum(1);
		}
		else
		{
			ActuallySaveGame( GetSaveSlot() );
		}
	} ]

	SaveConfirmBack[ (s)
	{
		Quit();
	} ]

	MenuDoneSave[ (s)
	{
		if( QuitAfterSave() )
		{
			SetQuitAfterSave( false );
			QuitToMenu();
		}
		else
		{
			Quit();
		}
	} ]

	DoneSave[ (s)
	{
		ClearMenu();
		AddStaticItem(3299);
		AddMenuItem(591, "MenuDoneSave");
	} ]

	NotEnoughSpace[ (s)
	{
		ClearMenu();
		AddStaticItem(3300);
		AddMenuItem(591, "Quit");
	} ]
	SaveFailed[ (s)
	{
		ClearMenu();
		AddStaticItem(4057);
		AddMenuItem(591, "Quit");
	} ]
}