{
	Init[ (s)
	{
		SetName(611);
		SetUseText(368);
		SetUsable( true );

		Item = Level.CreateEntity( 547 );
		AddObject( Item );
		Scroll = Level.CreateEntity( 4002 );
		Scroll.SetScroll(true);
		Scroll.SetLevel(10);
		AddObject(Scroll);
		Scroll = Level.CreateEntity( 4002 );
		Scroll.SetScroll(true);
		Scroll.SetLevel(10);
		AddObject(Scroll);
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}