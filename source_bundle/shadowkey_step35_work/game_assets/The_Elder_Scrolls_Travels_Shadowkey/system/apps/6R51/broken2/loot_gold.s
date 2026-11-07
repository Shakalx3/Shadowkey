{

	Init[()
	{
		SetName(456);
		SetUseText(457);
		SetUsable( true );

		Item = Level.CreateEntity( 52 );
		Item.SetQuantity( Random( 250, 450 ) );
		AddObject( Item );
	} ]

	OnUse[()
	{
		OpenMenu("LootMenu");
	} ]
	
}