{
	Init[ (s)
	{
		SetName(1613);
		SetUseText(457);

		Item = Level.CreateEntity( 700 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
		//DestroyObject(self);
	} ]
}