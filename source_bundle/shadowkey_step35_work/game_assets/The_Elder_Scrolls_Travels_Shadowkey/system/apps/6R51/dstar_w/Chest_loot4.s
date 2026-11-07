{
	ChestLoot4 [0]
	Init[ (s)
	{
		SetUseText(368);
		SetUsable(true);
		Item = Level.CreateEntity( 4701 );
		AddObject( Item );
		Item = Level.CreateEntity( 4707 );
		AddObject( Item );
		Item = Level.CreateEntity( 4706 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{

		OpenMenu("LootMenu");

	} ]

}