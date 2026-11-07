{	

	Init[ (s)
	{
		
		{	ClearMenu();
			AddStaticItem("Dipping into the");
			AddStaticItem("pool restores ");
			AddStaticItem("some of your");
			AddStaticItem("magicka.");
			AddStaticItem("-----");
			//GetPlayer().IncrementMagicka (20); 	// Player adds to current magicka <=max
			AddMenuItem( "Okay", "MenuQuit" );
			
		}


		return;
	} ]

	

	MenuQuit[ (s)
	{
		Quit();
	} ]
}