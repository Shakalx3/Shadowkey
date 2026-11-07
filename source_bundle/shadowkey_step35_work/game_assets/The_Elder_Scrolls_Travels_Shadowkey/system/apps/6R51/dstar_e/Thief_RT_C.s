{
	Init[ (s)
	{
		SetUseText(368);
		SetUsable(true);
		SetName(611);
		SetID("Chest");

		whichItem = Random(1,100);
		if( whichItem < 21 )
		{
			Item = Level.CreateEntity( 649 );
			AddObject( Item );

		}
		else
		{
			if( whichItem < 36 )
			{
				Item = Level.CreateEntity( 661 );
				AddObject( Item );

			}
			else
			{
				if( whichItem < 56 )
				{
					Item = Level.CreateEntity( 655 );
					AddObject( Item );


				}
			else
				{
					if( whichItem < 66 )
				{
						Item = Level.CreateEntity( 612 );
						AddObject( Item );

					}
					else
					{
						if( whichItem < 89 )
						{
							Item = Level.CreateEntity( 619 );
							AddObject( Item );

						}
						else
						{
							if( whichItem < 101 )
							{
								Item = Level.CreateEntity( 503 );
								AddObject( Item );

							}
						}
					}
				}
			}
		}
	} ]

	OnUse[ (s)
	{
	OpenMenu("dstar_e\\\\Thief_LootMenu");
	}]


}