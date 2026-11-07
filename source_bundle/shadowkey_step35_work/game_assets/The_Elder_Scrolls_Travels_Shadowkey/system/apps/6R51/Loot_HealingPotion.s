{
	Init[ (s)
	{
		SetName(1645);
		SetUseText(457);
		SetUsable( true );

		Item = Level.CreateEntity( 702 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");


	} ]
}