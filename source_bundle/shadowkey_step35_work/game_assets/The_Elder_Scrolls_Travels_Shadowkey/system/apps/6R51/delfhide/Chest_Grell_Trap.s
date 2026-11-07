{
	Init[ (s)
	{
		AddStaticItem(772);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
	} ]

	More[ (s)
	{
		ClearMenu();
		AddStaticItem(773);
		AddStaticItem(179, false);
		AddMenuItem(774, "More2");
	} ]

	More2[ (s)
	{
		ClearMenu();
		AddStaticItem(775);
		AddStaticItem(179, false);
		AddMenuItem(182, "More3");
	} ]

	More3[ (s)
	{
		ClearMenu();
		AddStaticItem(776);
		AddStaticItem(179, false);
		AddMenuItem(771, "Done");
	} ]

	Done[ (s)
	{
		GetPlayer().SetQuestSolved(3);
		Item = Level.CreateEntity( 920 );
		GetPlayer().PickupItem( Item );
		GetPlayer().SetHealth(GetPlayer().GetHealth() - 6);
		Quit();
	} ]
}