{
	Init[ (s)
	{
		SetName(456);
		SetUseText(457);
		SetUsable( true );
		Item = Level.CreateEntity( 915 );
		Item.SetID("skey8");
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}