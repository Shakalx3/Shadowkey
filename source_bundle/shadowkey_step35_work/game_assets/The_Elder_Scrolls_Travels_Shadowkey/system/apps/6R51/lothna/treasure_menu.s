{
	Init[ (s)
	{
		ClearMenu();

		AddStaticItem( 1955 );
		AddStaticItem(179, false);
		AddMenuItem( 1956, "ShadowGrace" );
		AddMenuItem( 887, "ShadowStabber" );
		return;
	} ]

	ShadowGrace[ (s)
	{
		ClearMenu();
		AddStaticItem( 1957 );
		AddStaticItem(1958);
		AddStaticItem(179, false);
		AddMenuItem( 182, "Grace2" );
	} ]

	Grace2[ (s)
	{
		ClearMenu();
		AddStaticItem( 1959);
		AddStaticItem(1960);
		AddStaticItem(179, false);
		AddMenuItem( 182, "Grace3" );
	} ]

	Grace3[ (s)
	{
		personality = GetPlayer().GetPersonality();
		personality = personality + 5;
		GetPlayer().SetPersonality(personality);

		intelligence = GetPlayer().GetIntelligence();
		intelligence = intelligence + 5;
		GetPlayer().SetIntelligence(intelligence);

		//hack to pump max health by 20
		GetPlayer().ModHealthBonus(20);

		luck = GetPlayer().GetLuck();
		luck = luck + 15;
		GetPlayer().SetLuck(luck);

		ClearMenu();
		AddStaticItem( 1961);
		AddStaticItem(179, false);
		AddMenuItem( 386, "MenuQuit" );
	} ]

	ShadowStabber[ (s)
	{
		GetPlayer().GiveItem(553);
		ClearMenu();
		AddStaticItem( 1962);
		AddStaticItem(179, false);
		AddMenuItem( 386, "MenuQuit" );
	} ]

	MenuQuit[ (s)
	{
		Quit();
	} ]
}