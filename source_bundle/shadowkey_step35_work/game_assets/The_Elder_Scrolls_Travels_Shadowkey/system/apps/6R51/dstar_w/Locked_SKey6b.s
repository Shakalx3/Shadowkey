{
	saved_Open [0]

	Init[ (s)
	{
		SetUseText(3403);
	}]

	OnUse[ (s)
	{
		if( saved_Open = 0 )
		{

			if(GetPlayer().FindInventory( "skey7" ) != null)
			{
				Door = Level.GetEntity("sdoor2");
				Door.DestroyObjectMirror(Door);
				Level.saved_doorB=1;
				return;
			}
			else
			{
				OpenMenu("dstar_w\\\\Skey6_convo");
			}
		}
		if( saved_Open = 1 )
		{
			// the door is open, close it!
			GetPlayer().PlaySound( 62 );
			SetPassable( true );
			AddRotationTurn( 64*256 );
			SetPassable( false );
			saved_Open = 0;
			DoorOpened(self,0,0); //replicate door open  0 for closed, 0 for normal door
			SetUseText(941);
			return;
		}
	} ]

	MenuQuit[ (s)
	{
		Quit();
	}]
}