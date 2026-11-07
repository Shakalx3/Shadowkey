{
	Init[ (s)
	{
		SetUseText(865);
		SetUsable(true);
		SetName(866);
		
	
		Item = Level.CreateEntity( 51 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}