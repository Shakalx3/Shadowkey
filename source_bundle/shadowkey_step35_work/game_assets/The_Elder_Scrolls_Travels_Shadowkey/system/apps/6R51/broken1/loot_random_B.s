{

	Init[()
	{
		SetName(610);
		SetUseText(610);
		SetUsable( true );

		rand = Random(1,99);

		if ((rand > 0) and (rand < 16))
		{
			Item = Level.CreateEntity( 707 ); //smack water
			AddObject( Item );
		}

		if ((rand > 15) and (rand < 29))
		{
			Item = Level.CreateEntity( 702 ); //healing potion
			AddObject( Item );
		}

		if ((rand > 28) and (rand < 58))
		{
			Item = Level.CreateEntity( 4726 ); //skyrim restorative
			AddObject( Item );
		}

		if ((rand > 57) and (rand < 76))
		{
			Item = Level.CreateEntity( 703 ); //magicka potion
			AddObject( Item );
		}

		if ((rand > 75) and (rand < 88))
		{
			Item = Level.CreateEntity( 708 ); //bitter tea
			AddObject( Item );
		}

		if (rand > 87)
		{
			Item = Level.CreateEntity( 702 ); //heal
			AddObject( Item );
			Item = Level.CreateEntity( 702 ); //heal
			AddObject( Item );
			Item = Level.CreateEntity( 703 ); //bitter tea
			AddObject( Item );
		}
	}]

	OnUse[()
	{
		OpenMenu("LootMenu");
	}]
}