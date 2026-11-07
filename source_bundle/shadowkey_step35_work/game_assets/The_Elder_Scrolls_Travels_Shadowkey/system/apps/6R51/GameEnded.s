{
	savePopup
	reallySave

	Init[ (s)
	{
		ClearMenu();
		AddStaticItem("");
		AddStaticItem(4081); //Game terminated by the host.

		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);

		savePopup=CreatePopupMenu(15,75,150,70);
		savePopup.AddItem(4020); //Do you wish to save before ending the game?
		savePopup.AddItem(1375,"GoSave"); //yes
		savePopup.AddItem(1389,"CancelEndGame"); //no
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
	} ]

	GoSave[ (s)
	{
		savePopup.SetVisible(false);
		SetQuitAfterSave(true);
		reallySave.SetVisible(true);
		reallySave.SetSelectedItem(1);
		//OpenMenu("SaveGameMenu");
	} ]

	CancelEndGame[ (s)
	{
		savePopup.SetVisible(false);
		QuitToMenu();
		Init();
	} ]

	GameEndedBack[ (s)
	{
		if( savePopup.IsVisible() )
		{
			savePopup.SetVisible( false );
			savePopup.SetSelectedItem(1);
		}
		else
		{
			if( reallySave.IsVisible() )
			{
				reallySave.SetVisible( false );
			}
			else
			{
				savePopup.SetVisible(true);
				savePopup.SetSelectedItem(1);
			}
		}
	} ]

	CancelSaveGame[ (s)
	{
		reallySave.SetVisible( false );
	} ]

	ConfirmSaveGame[ (s)
	{
		reallySave.SetVisible( false );
		ActuallySaveGame( GetMultiplayerSlot() );
	} ]
}