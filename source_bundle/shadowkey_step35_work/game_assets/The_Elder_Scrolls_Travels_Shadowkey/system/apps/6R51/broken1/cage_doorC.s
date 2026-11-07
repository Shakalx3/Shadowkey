{
	Init[()
	{
		SetName(3722);
		SetUsable( true );
		SetUseText(3722);
	} ]

	OnUse[ ()
	{
		GetPlayer().OpenMenu("broken1\\\\cagedoor");
		GetPlayer().PlaySound( 57 );

		Cage7 = Level.GetEntity("cage7");
		Cage7.DestroyObjectMirror(Cage7);

		Cage8 = Level.GetEntity("cage8");
		Cage8.DestroyObjectMirror(Cage8);

		Cage9 = Level.GetEntity("cage9");
		Cage9.DestroyObjectMirror(Cage9);
		
		Level.saved_cageC=1;

		SetUsable(false);
	}]
}