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
			Item = Level.CreateEntity( 712 );
			AddObject( Item );
		}
		else
		{
			if( whichItem < 51 )
			{
				Item = Level.CreateEntity( 702 );
				AddObject( Item );
				Item = Level.CreateEntity( 702 );
				AddObject( Item );
			}
			else
			{
				if( whichItem < 61 )
				{
					Item = Level.CreateEntity( 4720 );
					AddObject( Item );
				}
				else
				{
					if( whichItem < 86 )
					{
						Item = Level.CreateEntity( 4700 );
						AddObject( Item );
					}
					else
					{
						if( whichItem < 101 )
						{
							Scroll = Level.CreateEntity( 51 );
							Scroll.SetScroll(true);
							Scroll.SetLevel(15);
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