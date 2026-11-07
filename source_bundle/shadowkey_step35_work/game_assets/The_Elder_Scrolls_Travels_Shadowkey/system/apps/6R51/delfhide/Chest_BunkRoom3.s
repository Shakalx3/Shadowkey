{
	Init[ (s)
	{
		// 16 gold, two bludgeons, leather shirt.

		SetName(611);
		SetUseText(368);
		SetUsable( true );

		Item = Level.CreateEntity( 500 );
		AddObject( Item );

		Item = Level.CreateEntity( 500 );
		AddObject( Item );

		Item = Level.CreateEntity( 606 );
		AddObject( Item );

		Item = Level.CreateEntity( 52 );
		Item.SetQuantity( 16 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}