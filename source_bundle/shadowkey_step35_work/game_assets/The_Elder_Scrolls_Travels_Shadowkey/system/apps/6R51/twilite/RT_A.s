{
	Init[ (s)
	{
		SetUseText(610);
		SetUsable(true);
		SetName(610);
		SetID("Container");

		whichItem = Random(1,100);
		if( whichItem < 21 )
		{
			Item = Level.CreateEntity( 711 );
			AddObject( Item );
		}
		else
		{
			if( whichItem < 51 )
			{
				Item = Level.CreateEntity( 710 );
				AddObject( Item );
			}
			else
			{
				if( whichItem < 61 )
				{
					Item = Level.CreateEntity( 700 );
					AddObject( Item );
				}
				else
				{
					if( whichItem < 86 )
					{
						Item = Level.CreateEntity( 4706 );
						AddObject( Item );
					}
					else
					{
						if( whichItem < 101 )
						{
							Scroll = Level.CreateEntity( 51 );
							Scroll.SetScroll(true);
							Scroll.SetLevel(10);
							AddObject(Scroll);
						}
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