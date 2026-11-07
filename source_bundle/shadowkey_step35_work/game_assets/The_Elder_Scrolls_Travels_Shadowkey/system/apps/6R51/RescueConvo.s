{

	Init[ (s)
	{	
		Roll = Random (1,5);
		if(Roll = 1 )
		{
			ClearMenu();
			AddStaticItem("Praise the fates!");
			AddStaticItem("Those ruffians meant ");
			AddStaticItem("us ill.");
			AddStaticItem("-----");
			AddMenuItem("You are free now!", "MenuQuit");
		}
		
		if( Roll = 2 )
		{	
			ClearMenu();
			AddStaticItem( "I would have");
			AddStaticItem( "shown those rascals, ");
			AddStaticItem( "a thing or two");
			AddStaticItem( "if only ...");
			AddStaticItem("-----");
			AddMenuItem("Go home", "MenuQuit");
		}
		
		if(Roll = 3 )
		{
			ClearMenu();
			AddStaticItem("They took Birgitta");
			AddStaticItem("to a big room  ");
			AddStaticItem("behind two gates.");
			AddStaticItem("-----");
			AddMenuItem("I will find her!", "MenuQuit");
		}
		if(Roll = 4 )
		{
			ClearMenu();
			AddStaticItem("Praise be upon");
			AddStaticItem("you and yours ");
			AddStaticItem("-----");
			AddMenuItem("Please hurry!", "MenuQuit");
		}
		if(Roll = 5 )
		{
			ClearMenu();
			AddStaticItem("Thank you so");
			AddStaticItem("much, I thought ");
			AddStaticItem("I was done for.");
			AddStaticItem("-----");
			AddMenuItem("You're Welcome", "MenuQuit");
		}
		
		return;	
	} ]
		
	
	

	MenuQuit[ (s)
	{
		Quit();
		//Remove Prisoner from game. 
	} ]
}