{
	Init[ (s)
	{
		if(Level.saved_Given = 0)
		{
			AddStaticItem(751);
			AddStaticItem(179, false);
			AddMenuItem(182, "More");
		}
		else
		{
			AddStaticItem(752);
			AddStaticItem(179, false);
			AddMenuItem(753, "Quit");
		}
	} ]

	More[ (s)
	{
		ClearMenu();
		AddStaticItem(754);
		AddStaticItem(179, false);
		AddMenuItem(755, "More2");
	} ]

	More2[ (s)
	{
		ClearMenu();
		AddStaticItem(756);
		AddStaticItem(179, false);
		AddMenuItem(758, "FeedNow");
		AddMenuItem(757, "Quit");
	} ]

	FeedNow[ (s)
	{
		ClearMenu();
		AddStaticItem(759);
		AddStaticItem(179, false);
		AddMenuItem(760, "GiveKey");
		AddMenuItem(761, "GiveKeyScowl");
		AddMenuItem(762, "GiveKeyScowl");
	} ]

	GiveKey[ (s)
	{
		ClearMenu();
		AddStaticItem(763);
		AddStaticItem(179, false);
		AddMenuItem(528, "Quit");
		Key = Level.CreateEntity( 804 );
		GetPlayer().PickupItem( Key );
		Level.saved_Given = 1;
	} ]

	GiveKeyScowl[ (s)
	{
		ClearMenu();
		AddStaticItem(764);
		AddStaticItem(179, false);
		AddMenuItem(182, "ScowlMore");
		Key = Level.CreateEntity( 804 );
		GetPlayer().PickupItem( Key );
		Level.saved_Given = 1;
	} ]

	ScowlMore[ (s)
	{
		ClearMenu();
		AddStaticItem(765);
		AddStaticItem(179, false);
		AddMenuItem(528, "Quit");
	} ]
}