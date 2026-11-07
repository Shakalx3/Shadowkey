{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem(1326);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
	} ]

	More[ (s)
	{
		ClearMenu();
		AddStaticItem(1327);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	} ]

	More2[ (s)
	{
		ClearMenu();
		Item = Level.CreateEntity( 4702 );
		GetPlayer().PickupItem( Item );
		Level.saved_bandage = 1;
		Ban = Level.GetEntity("ban");
		if( isObject( Ban ) )
		{
			Ban.SetUsable(false);
		}	
		AddStaticItem(1328);
		AddStaticItem(179, false);
		AddMenuItem(182, "More3");

	} ]

	More3[ (s)
	{
		ClearMenu();
		AddStaticItem(1329);
		AddStaticItem(179, false);
		AddMenuItem(182, "More4");
	} ]

	More4[ (s)
	{
		ClearMenu();
		AddStaticItem(1330);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
	} ]
}