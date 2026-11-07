{

	Init[ (s)
	{

		AddStaticItem(784);
		AddStaticItem(179, false);
		//GetPlayer().IncrementMagicka (20); 	// Player adds to current magicka <=max
		AddMenuItem( 386, "MenuQuit" );
		return;
	} ]



	MenuQuit[ (s)
	{
		Quit();
	} ]
}