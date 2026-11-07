{
	Init[ (s)
	{
		AddStaticItem(766);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
	} ]

	More[ (s)
	{
		ClearMenu();
		AddStaticItem(767);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	} ]

	More2[ (s)
	{
		ClearMenu();
		AddStaticItem(768);
		AddStaticItem(179, false);
		AddMenuItem(182, "More3");
	} ]

	More3[ (s)
	{
		ClearMenu();
		AddStaticItem(769);
		AddStaticItem(179, false);
		AddMenuItem(182, "More4");
	} ]

	More4[ (s)
	{
		ClearMenu();
		AddStaticItem(770);
		AddStaticItem(179, false);
		AddMenuItem(771, "Done");
	} ]

	Done[ (s)
	{
		GetPlayer().SetQuestSolved(3);
		Item = Level.CreateEntity( 920 );
		GetPlayer().PickupItem( Item );
		Quit();
	} ]
}