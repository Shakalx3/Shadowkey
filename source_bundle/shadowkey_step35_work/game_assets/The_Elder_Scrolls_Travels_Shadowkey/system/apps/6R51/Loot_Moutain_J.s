{
	Init[ (s)
	{
		SetName(1367);
		SetUseText(457);
		SetUsable( true );

		Item = Level.CreateEntity( 4720 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}
