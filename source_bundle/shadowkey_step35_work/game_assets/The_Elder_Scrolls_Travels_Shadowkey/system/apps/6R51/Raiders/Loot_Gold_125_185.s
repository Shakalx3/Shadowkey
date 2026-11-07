{
	DestroyMe [0]

	Init[ (s)
	{
		SetName(456);
		SetUseText(457);
		SetUsable( true );

		Item = Level.CreateEntity( 52 );
		Item.SetQuantity( Random( 125, 185 ) );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}