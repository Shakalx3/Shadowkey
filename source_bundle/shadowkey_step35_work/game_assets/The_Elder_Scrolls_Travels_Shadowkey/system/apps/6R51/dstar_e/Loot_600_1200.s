{
	Init[ (s)
	{
		SetName(456);
		SetUseText(3405);
		SetUsable( true );
		Item = Level.CreateEntity( 52 );
		Item.SetQuantity( Random( 600, 1200 ) );
		AddObject( Item );
	}]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	}]
}