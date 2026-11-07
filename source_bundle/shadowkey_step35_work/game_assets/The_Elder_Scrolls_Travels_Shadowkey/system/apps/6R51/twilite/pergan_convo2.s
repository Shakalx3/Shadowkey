{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2706);
		AddStaticItem(2707);
		AddStaticItem(179, false);
		AddMenuItem(182, "OnDeath");
	}]

	OnDeath[()
	{
		ClearMenu();
		AddStaticItem(2708);
		AddStaticItem(2709);
		AddStaticItem(179, false);
		AddMenuItem(182, "TakeShadowKey");
	}]

	TakeShadowKey[()
	{
		ClearMenu();
		AddStaticItem(2710);
		AddStaticItem(179, false);
		AddMenuItem(517, "Quit");
		GetPlayer().SetQuestSolved(20);
		
		if (not IsMultiplayerClient())
		{		
			Item = Level.CreateEntity( 910 );
			GetPlayer().PickupItem( Item );
		}
	}]
}