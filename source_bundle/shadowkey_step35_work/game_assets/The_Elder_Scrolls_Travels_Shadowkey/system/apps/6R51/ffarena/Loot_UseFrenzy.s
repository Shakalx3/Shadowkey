{
	DestroyMe [0]

	Init[ (s)
	{
		SetName(456);
		SetUseText(457);
		SetUsable( true );

		Scroll = Level.CreateEntity( 4022 );
		Scroll.SetScroll(true);
		Scroll.SetLevel(10);
		AddObject(Scroll);
	} ]

	OnUse[ (s)
	{
		OpenMenu("LootMenu");
	} ]
}