{
	DestroyMe [0]

	Init[ (s)
	{
		SetName(857);
		SetUseText(3109);
		SetUsable( true );

		Item = Level.CreateEntity( 803 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}

}
