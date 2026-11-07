{

	Init[ (s)
	{
		SetName(456);
		SetUseText(457);
		SetUsable( true );

		Item = Level.CreateEntity( 601 );
		AddObject( Item );
		
		Item = Level.CreateEntity( 613 );
		AddObject( Item );		
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}