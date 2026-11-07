{
	popup
	errorPopup
	queueTable
	quitButton
	selectedItem
	defaultError[4058]
	
	Init[ (s)
	{	
		MenuBackground(20);

	} ]

	MenuBack[ (s)
	{
		DisplayCharacterManager();
	} ]
	
	OnDisplay[ ()
	{
		ClearMenu();
		
		AddTitle(3777);
		//rows, x, y, width, height				
		queueTable=AddTable(6, 10, 45, 150, 110);
		queueTable.AddColumn(120);
		queueTable.SetLineWrap(true);	
		queueTable.SetCallback("ShowPopup");
		queueTable.SetRowSelect(true);
		SetTable(queueTable);	
						
		popup=CreatePopupMenu(5,30,150,60,false);
		popup.AddItem(4024,"AddToLeft");
		//popup.AddItem(4025,"AddToRight");	
		popup.AddItem(3281,"HidePopup");
		popup.SetBack("HidePopup");
		popup.SetVisible(false);
				
		quitButton=AddQuitButton(3281,"MenuBack");					

		errorPopup=CreatePopupMenu(5,30,150,60,false);
		errorPopup.AddItem(defaultError,"");
		errorPopup.AddItem(3281,"HideErrorPopup");
		errorPopup.SetSelectable(0,false);
		errorPopup.SetSelectedItem(1);
		errorPopup.SetBack("HideErrorPopup");
		errorPopup.SetVisible(false);
		
		SetSelectedItem(queueTable);
		UpdateTextItems();	
		quitButton.SetEnabled(true);
				
	}]

	RemoveQueueBack[ (s)
	{
		DisplayCharacterManager();
	}]
	
	AddToLeft[ ()
	{
		selectedItem = queueTable.GetSelectedRow();
		inventory = selectedItem.GetAssociatedObject();			
		
		if (GetPlayer().MoveToLeftQueue(inventory) = false)
		{
			popup.SetVisible(0);
			errorPopup.SetVisible(true);
			errorPopup.SetSelectedItem(1);		
		}
		else
		{
			self.HidePopup();
		}
	}]
	
	
	ShowPopup[ ()
	{	
		popup.SetVisible(true);
		//popup.SetToWidget(selectedItem,5,10);	
	}]
	
	HidePopup[ ()
	{
		popup.SetVisible(false);
		self.OnDisplay();		
	}]
	
	HideErrorPopup[ ()
	{
		errorPopup.SetVisible(false);
		SetSelectedItem(queueTable);
	}]

}