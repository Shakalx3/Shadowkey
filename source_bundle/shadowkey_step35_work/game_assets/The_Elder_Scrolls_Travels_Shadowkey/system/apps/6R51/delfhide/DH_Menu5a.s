{
	Init[ (s)
	{
		if( Level.saved_prison = 0 ){ tlk(1); }
		if( Level.saved_prison = 1 ){ tlk(2); }
	}]

	tlk[ (Who)
	{
		switch(Who)
		{
			case 1
			{
			AddStaticItem(3095);
			AddStaticItem(179, false);
			AddMenuItem(796, "Quit");
			GetOpener().DestroyObjectMirror( GetOpener() );
			}
			case 2
			{
			AddStaticItem(3096);
			AddStaticItem(179, false);
			AddMenuItem(517, "Quit");
			GetOpener().DestroyObjectMirror( GetOpener() );
			}
		}
	}]
	MenuQuit[ (s)
	{
		Quit();
	}]
}
