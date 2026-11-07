{
	saved_Open [0]

	Init[ (s)
	{
		SetUseText(941);
		SetMPUsable(true);
	} ]

	OnUse[ (s)
	{
		if( saved_Open = 0 )
		{
			// the door is closed.  open it!
			SetPassable( true );
			AddRotationTurn( -64*256 );
			SetPassable( true );
			saved_Open = 1;
			DoorOpened(self,1,0); //replicate door open  1 for open, 0 for normal door
			SetUseText(2989);
			return;
		}
		if( saved_Open = 1 )
		{
			// the door is open, close it!
			SetPassable( true );
			AddRotationTurn( 64*256 );
			SetPassable( false );
			saved_Open = 0;
			DoorOpened(self,0,0); //replicate door open  0 for closed, 0 for normal door
			SetUseText(941);
			return;
		}
	} ]
}