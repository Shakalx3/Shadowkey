{

	Init[ (s)
	{
		SetName(456);
		SetUseText(368);
		SetUsable( true );
		Item = Level.CreateEntity( 4025 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}