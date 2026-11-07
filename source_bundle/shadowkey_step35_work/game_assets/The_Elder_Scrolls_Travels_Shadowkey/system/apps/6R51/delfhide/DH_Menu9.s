{
	Init[ (s)
	{
		if(GetPlayer().FindInventory("TRkey") != null)
		{
			AddStaticItem(812);
			AddStaticItem(179, false);
			AddMenuItem(182, "SolvedMore");
		}
		else
		{
			AddStaticItem(813);
			AddStaticItem(179, false);
			AddMenuItem(182, "More2");
		}
	} ]

	SolvedMore[ (s)
	{
		ClearMenu();
		AddStaticItem(814);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");

		Door = Level.GetEntity("tr_door");
		Level.saved_DoneRoom34 = 1;
		Door.SetPassable( true );
		Door.AddRotationTurn( 64*256 );
		Door.DoorOpened(Door,1,0); //replicate door open  1 for open, 0 for normal door
		poo = GetPlayer().FindInventory("TRkey");
		GetPlayer().RemoveItem(poo);

	} ]

	More2[ (s)
	{
		ClearMenu();
		AddStaticItem(815);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
	} ]
}