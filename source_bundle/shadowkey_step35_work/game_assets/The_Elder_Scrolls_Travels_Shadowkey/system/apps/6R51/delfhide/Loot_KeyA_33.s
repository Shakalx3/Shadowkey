{
	DestroyMe [0]

	Init[ (s)
	{
		SetName(855);
		SetUseText(3108);
		SetUsable( true );

		Item = Level.CreateEntity( 802 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}
