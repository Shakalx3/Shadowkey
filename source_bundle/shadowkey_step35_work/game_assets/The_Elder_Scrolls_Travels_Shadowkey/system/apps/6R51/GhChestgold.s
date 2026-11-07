{
	Init[ (s)
	{
		ClearMenu();
		Roll = GetPlayer().Random( 40, 100 );
		AddStaticItem("You find " #Roll# " gold");
		AddStaticItem(179, false);
		GetPlayer().StatModGold(Roll); 	// +roll gold
		AddMenuItem( 1433, "MenuQuit" );
		GetOpener().SetUsable(false);

	}]


	MenuQuit[ (s)
	{
		Quit();
	}]
}