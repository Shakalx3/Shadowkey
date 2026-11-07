{
	page [1]
	myPopup

	Init[ (s)
	{
		SetPrevMenu("Options");
		MenuBackground(20);

		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	} ]

	OnDisplay[ (s)
	{
		if (page = 0)
		{
			page=1;
			OpenMenu("Options");
			return;
		}

		ConfigKeysMenu(page);
		//CreatePopups();
	} ]

	CreatePopups[ ()
	{
		myPopup=CreatePopupMenu(15,75,100,100);
		myPopup.AddItem(4071); //cod 490
		myPopup.AddItem(4009,"ActuallyDefaultKeys");
		myPopup.AddItem(4010,"CancelDefaultKeys");
		myPopup.SetSelectable(0,false);
		myPopup.SetVisible(false);
		myPopup.SetSelectedItem(2);
		myPopup.SetBackground();
		myPopup.SetAutoAdjust(true);
	}]

	DefaultKeys[ (s)
	{
		CreatePopups();
		myPopup.SetVisible(true);
		myPopup.SetSelectedItem(2);
	}]

	ActuallyDefaultKeys[ (s)
	{
		myPopup.SetVisible(false);
		ConfigKeysDefault();
		ClearMenu();
		OnDisplay();
	}]

	CancelDefaultKeys[ (s)
	{
		myPopup.SetVisible(false);
		ClearMenu();
		OnDisplay();
	}]

	NextPage[ (s)
	{

		page = page + 1;
		ConfigKeysMenu(page);
	}]

	PrevPage[ (s)
	{

		page = page - 1;
		if (page = 0)
		{
			page=1;
			OpenMenu("Options");
			return;
		}
		ConfigKeysMenu(page);
	}]

	OptionsMenu[ (s)
	{
		OpenMenu("Options");
	}]

	BackToConfig[ (s)
	{
		//ConfigKeysMenu(page);
		//OpenMenu("Options");
		ClearMenu();
		OnDisplay();
	}]

	ConfigKeysBack[ (s)
	{
		if (page = 0)
		{
			OpenMenu("Options");
		}
		else
		{
			PrevPage();
		}
	}]
}