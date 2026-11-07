{
	Init[ (s)
	{
		AddStaticItem(1449);
		AddStaticItem(179, false);
		AddMenuItem(1450, "Quit");
		Item = Level.CreateEntity( 601 );
		GetPlayer().PickupItem( Item );
		Item = Level.CreateEntity( 613 );
		GetPlayer().PickupItem( Item );
		GetOpener().saved_Looted = 1;
		GetOpener().SetUsable(false);
	} ]
}