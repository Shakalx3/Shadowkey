{
	DestroyMe [0]

	Init[ (s)
	{
		SetName(1367);
		SetUseText(2212);
		SetUsable( true );

		Item = Level.CreateEntity( 717 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}
