{	
	questTable
	
	Init[ (s)
	{	
		MenuBackground(20);				
	} ]
	
	OnDisplay[ ()
	{
		ClearMenu();
		AddTitle(3785,10);
		AddTitle(3786,25);
		
		//rows, x, y, width, height				
		questTable=AddTable(6, 10, 45, 150, 110);
		questTable.AddColumn(175);
		questTable.SetLineWrap(true);	
		questTable.SetCallback("MenuBack");	
		
		AddQuitButton(3281,"MenuBack");		
	
		DisplayObjectives(questTable);
	}]

	OnRightSoftKey[ ()
	{
		MenuBack();
	}]

	QuestLogBack[ (s)
	{
		DisplayCharacterManager();
	} ]
	
	MenuBack[ (s)
	{
		DisplayCharacterManager();
	} ]
	
}