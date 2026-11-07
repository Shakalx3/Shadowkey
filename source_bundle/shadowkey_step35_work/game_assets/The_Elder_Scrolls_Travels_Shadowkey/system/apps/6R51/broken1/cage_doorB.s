{
	Init[()
	{
		SetName(3721);
		SetUsable( true );
		SetUseText(3721);
	} ]

	OnUse[ ()
	{
		GetPlayer().OpenMenu("broken1\\\\cagedoor");
		GetPlayer().PlaySound( 57 );

		Cage10 = Level.GetEntity("cage10");
		Cage10.DestroyObjectMirror(Cage10);

		Cage11 = Level.GetEntity("cage11");
		Cage11.DestroyObjectMirror(Cage11);

		Cage12 = Level.GetEntity("cage12");
		Cage12.DestroyObjectMirror(Cage12);
		
		Level.saved_cageB=1;

		SetUsable(false);
	}]
}