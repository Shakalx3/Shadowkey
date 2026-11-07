{

	Init[()
	{
		SetName(610);
		SetUseText(610);
		SetUsable( true );

		rand = Random(1,99);

		if ((rand > 0) and (rand < 21))
		{
			Item = Level.CreateEntity( 4711 ); //tremble weed
			AddObject( Item );
		}

		if ((rand > 20) and (rand < 34))
		{
			Item = Level.CreateEntity( 4712 ); //goblin wax
			AddObject( Item );
		}

		if ((rand > 33) and (rand < 51))
		{
			Item = Level.CreateEntity( 4708 ); //fox herb
			AddObject( Item );
		}

		if ((rand > 50) and (rand < 61))
		{
			Scroll = Level.CreateEntity( 4022 );
			Scroll.SetScroll(true);
			Scroll.SetLevel(10);
			AddObject(Scroll);
		}

		if ((rand > 60) and (rand < 86))
		{
			Item = Level.CreateEntity( 4706 ); //deathsnow dust
			AddObject( Item );
		}

		if ((rand > 85))
		{
			Scroll = Level.CreateEntity( 51 );
			Scroll.SetScroll(true);
			Scroll.SetLevel(10);
			AddObject(Scroll);
		}
	}]

	OnUse[()
	{
		OpenMenu("LootMenu");
	}]
}