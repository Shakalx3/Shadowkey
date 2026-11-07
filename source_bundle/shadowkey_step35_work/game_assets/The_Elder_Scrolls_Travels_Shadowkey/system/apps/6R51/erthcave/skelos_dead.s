{
	Init[()
	{
		AddStaticItem(3882);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
	}]

	More[()
	{
		ClearMenu();
		AddStaticItem(3883);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
	}]

	Take[()
	{
		if(GetPlayer().saved_StarTooth = 1)
		{
			Item = Level.CreateEntity( 714 );
			GetPlayer().PickupItem( Item );
		}
		else
		{
			if(GetPlayer().saved_StarTooth = 2)
			{
				Item = Level.CreateEntity( 714 );
				GetPlayer().PickupItem( Item );

				Item = Level.CreateEntity( 714 );
				GetPlayer().PickupItem( Item );
			}
			else
			{
				if(GetPlayer().saved_StarTooth = 3)
				{
					Item = Level.CreateEntity( 714 );
					GetPlayer().PickupItem( Item );

					Item = Level.CreateEntity( 714 );
					GetPlayer().PickupItem( Item );

					Item = Level.CreateEntity( 714 );
					GetPlayer().PickupItem( Item );
				}
				else
				{
					if(GetPlayer().saved_StarTooth = 4)
					{
						Item = Level.CreateEntity( 714 );
						GetPlayer().PickupItem( Item );

						Item = Level.CreateEntity( 714 );
						GetPlayer().PickupItem( Item );

						Item = Level.CreateEntity( 714 );
						GetPlayer().PickupItem( Item );

						Item = Level.CreateEntity( 714 );
						GetPlayer().PickupItem( Item );
					}
					else
					{
						Item = Level.CreateEntity( 714 );
						GetPlayer().PickupItem( Item );

						Item = Level.CreateEntity( 714 );
						GetPlayer().PickupItem( Item );

						Item = Level.CreateEntity( 714 );
						GetPlayer().PickupItem( Item );

						Item = Level.CreateEntity( 714 );
						GetPlayer().PickupItem( Item );

						Item = Level.CreateEntity( 714 );
						GetPlayer().PickupItem( Item );
					}
				}
			}
		}

		Quit();
	}]
}