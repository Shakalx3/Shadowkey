{
	Init[()
	{
		AddStaticItem(3130);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
	}]

	More[()
	{
		ClearMenu();
		AddStaticItem(971);
		AddStaticItem(972);
		AddStaticItem(179, false);
		AddMenuItem(3131, "Loot1");
		AddMenuItem(3132, "youBedead");
	}]

	Loot1[()
	{
		ClearMenu();
		AddStaticItem(975);
		AddStaticItem(3133);
		AddStaticItem(179, false);
		AddMenuItem(444, "Tanyin");
		AddMenuItem(3134, "youBedead");
	}]

	Tanyin[()
	{
		ClearMenu();
		AddStaticItem(3135);
		AddStaticItem(179, false);
		AddMenuItem(591, "MenuQuit");
		Item = Level.CreateEntity( 809 );
		GetPlayer().PickupItem( Item );


	}]

	youBedead[()
	{
		GetPlayer().saved_Dstar_Pass = 1;
		SkyA = Level.GetEntity("skyA");
		SkyB = Level.GetEntity("skyB");
		SkyA.SetInvulnerable(false);
		SkyB.SetInvulnerable(false);
		Level.saved_Guard = 1;
		Quit();
	}]
	MenuQuit[ ()
	{
		SkyA = Level.GetEntity("skyA");
		SkyB = Level.GetEntity("skyB");
		SkyA.SetInvulnerable(false);
		SkyB.SetInvulnerable(false);
		Level.saved_Guard = 1;
		Quit();
	}]
}
