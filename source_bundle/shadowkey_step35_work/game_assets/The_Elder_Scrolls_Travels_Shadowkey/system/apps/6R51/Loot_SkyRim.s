{
	Init[ (s)
	{
		SetName(456);
		SetUseText(457);
		SetUsable( true );

		Item = Level.CreateEntity( 800 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		GetPlayer().SetQuestSolved(6);
		OpenMenu("LootMenu");
	}]

}