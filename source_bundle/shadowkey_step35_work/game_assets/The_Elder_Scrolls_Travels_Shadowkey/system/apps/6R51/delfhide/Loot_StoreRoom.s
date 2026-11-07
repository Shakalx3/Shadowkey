{
	Init[ (s)
	{
		SetUseText(861);
		SetUsable(true);
		SetName(862);

		whichItem = Random(1,100);
		if( whichItem < 25 )
		{
			Item = Level.CreateEntity( 700 );
				AddObject( Item );
		}
		else
		{
			if( whichItem < 50 )
			{
				Item = Level.CreateEntity( 706 );
				AddObject( Item );
			}
			else
			{
				if( whichItem < 75 )
				{
					Item = Level.CreateEntity( 707 );
					AddObject( Item );
				}
				else
				{
					if( whichItem < 101 )
					{
						Item = Level.CreateEntity( 708 );
						AddObject( Item );
					}
				}
			}
		}
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}