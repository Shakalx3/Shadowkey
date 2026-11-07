{
	Init[ (s)
	{
		AddStaticItem(1305);
		AddStaticItem(179);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "Quit");
	} ]

	Take[ (s)
	{
		ClearMenu();
		AddStaticItem(1306);
		AddStaticItem(179);
		AddMenuItem(182, "More");
	} ]

	More[ (s)
	{
		ClearMenu();
		AddStaticItem(1307);
		AddStaticItem(179);
		AddMenuItem(517, "Quit");
		GetPlayer().SetQuestSolved(7);
		Item = Level.CreateEntity( 928 );
		GetPlayer().PickupItem( Item );
		Level.Room11Entered = 1;
	} ]
}