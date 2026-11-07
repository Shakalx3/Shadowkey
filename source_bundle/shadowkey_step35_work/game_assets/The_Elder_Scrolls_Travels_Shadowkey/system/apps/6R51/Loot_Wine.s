{
	Init[ (s)
	{
		SetName(1897);
		SetUseText(457);
		SetUsable( true );

		Item = Level.CreateEntity( 706 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
		//DestroyObject(self);
	} ]
}