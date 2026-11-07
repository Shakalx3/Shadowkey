{

	Init[()
	{
		SetName(456);
		SetUseText(457);
		SetUsable( true );

		Item = Level.CreateEntity( 52 );
		Item.SetQuantity( Random( 500, 750 ) );
		AddObject( Item );
	} ]

	OnUse[()
	{
		OpenMenu("LootMenu");
	} ]
	
}