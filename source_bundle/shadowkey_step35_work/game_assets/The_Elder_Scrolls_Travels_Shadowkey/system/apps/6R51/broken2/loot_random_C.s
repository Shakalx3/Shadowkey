{

	Init[()
	{
		SetName(610);
		SetUseText(610);
		SetUsable( true );

		rand = Random(1,99);

		if ((rand > 0) and (rand < 21))
		{
			Item = Level.CreateEntity( 4735 ); //scythe crystals
			AddObject( Item );
		}

		if ((rand > 20) and (rand < 36))
		{
			Item = Level.CreateEntity( 669 ); //silver shield
			AddObject( Item );
		}

		if ((rand > 35) and (rand < 56))
		{
			Scroll = Level.CreateEntity( 51 );
			Scroll.SetScroll(true);
			Scroll.SetLevel(10);
			AddObject(Scroll);
		}

		if ((rand > 56) and (rand < 67))
		{
			Scroll = Level.CreateEntity( 4009 );
			Scroll.SetScroll(true);
			Scroll.SetLevel(10);
			AddObject(Scroll);
		}

		if ((rand > 66) and (rand < 89))
		{
			Item = Level.CreateEntity( 4729 ); //thunder herb
			AddObject( Item );
		}

		if (rand > 88)
		{
			Item = Level.CreateEntity( 4736 ); //horrid tounge
			AddObject( Item );
		}
	}]

	OnUse[()
	{
		OpenMenu("LootMenu");
	}]
}