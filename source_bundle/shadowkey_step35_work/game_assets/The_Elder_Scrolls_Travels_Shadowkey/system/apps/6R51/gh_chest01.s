{
	Init[ (s)
	{
		SetUseText(368);
		SetName(368);
		SetUsable( true );

		Item = Level.CreateEntity(52);
		Item.SetQuantity( Random( 5, 30 ) );
		AddObject( Item );
	}]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	}]
}