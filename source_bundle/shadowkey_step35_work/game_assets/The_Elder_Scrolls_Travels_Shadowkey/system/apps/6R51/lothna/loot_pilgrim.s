{

	Init[ (s)
	{
		SetName(1924);
		
		ShowEntity(false);

		if( not Level.IsMultiplayerClient() )
		{
			SetUsable( true );
			SetUseText(368);
		}

		Item = Level.CreateEntity( 4032 );
		AddObject( Item );
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	}]
}