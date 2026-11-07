{
	Init[()
	{
		SetName(3723);
		SetUsable( true );
		SetUseText(3723);
	} ]

	OnUse[ ()
	{
		GetPlayer().OpenMenu("broken1\\\\cagedoor");
		GetPlayer().PlaySound( 57 );

		Cage2 = Level.GetEntity("cage2");
		Cage2.DestroyObjectMirror(Cage2);

		Cage3 = Level.GetEntity("cage3");
		Cage3.DestroyObjectMirror(Cage3);

		Cage4 = Level.GetEntity("cage4");
		Cage4.DestroyObjectMirror(Cage4);
		
		Level.saved_cageD=1;

		SetUsable(false);
	}]
}