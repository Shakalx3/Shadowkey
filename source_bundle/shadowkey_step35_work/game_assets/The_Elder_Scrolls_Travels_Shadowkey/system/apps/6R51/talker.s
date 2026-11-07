{
	Init[ (s)
	{
		if ( Level.saved_taker = 0 )
		{
			AddStaticItem( 3301);
			AddStaticItem(179, false);
			AddMenuItem( 2538, "Talker" );
			AddMenuItem( 3302, "MenuQuit" );

			bone1=Level.GetEntity("bone1");
			if ( isObject( bone1 ) )
			{
				bone1.SetAggressive( true );
				bone1.SetUsable( false );
			}

			bone2=Level.GetEntity("bone2");
			if ( isObject( bone2 ) )
			{
				bone2.SetAggressive( true );
				bone2.SetUsable( false );
			}
		}
		else
		{
			Quit();
		}
	}]

	Talker[ (s)
	{
		ClearMenu();
		AddStaticItem( 3303 );
		AddStaticItem(179, false);
		AddMenuItem( 528, "MenuQuit" );
		bone1=Level.GetEntity("bone1");
		if( isObject( bone1 ) )
		{
			bone1.SetAggressive( true );
			bone1.SetUsable( false );
		}

		bone2=Level.GetEntity("bone2");
		if ( isObject( bone2 ) )
		{
			bone2.SetAggressive( true );
			bone2.SetUsable( false );
		}
	} ]

	MenuQuit[ (s)
	{
		Quit();
		Level.saved_taker = 1;

	} ]
}

