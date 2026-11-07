{
	Init[ (s)
	{
		SetUseText(368);
		SetName(368);

		Item = Level.CreateEntity( 50 );
		AddObject( Item );
	}]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	}]

}