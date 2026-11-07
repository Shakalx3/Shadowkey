{
	Init[ (s)
	{
		SetName(610);
		SetUseText(610);
		SetUsable( true );

		Item = Level.CreateEntity( 52 );
		Item.SetQuantity( 250 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}