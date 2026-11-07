{
	Init[()
	{
		SetName(3720);
		SetUsable( true );
		SetUseText(3720);
	} ]

	OnUse[ ()
	{
		GetPlayer().OpenMenu("broken1\\\\cagedoor");
		GetPlayer().PlaySound( 57 );

		Cage1 = Level.GetEntity("cage1");
		Cage1.DestroyObjectMirror(Cage1);

		Cage5 = Level.GetEntity("cage5");
		Cage5.DestroyObjectMirror(Cage5);

		Cage6 = Level.GetEntity("cage6");
		Cage6.DestroyObjectMirror(Cage6);
		
		Level.saved_cageA=1;

		SetUsable(false);
	}]
}