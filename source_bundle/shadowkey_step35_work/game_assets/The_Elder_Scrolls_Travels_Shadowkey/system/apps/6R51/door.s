{
	saved_Open [0]
	bPlaySound[true]

	Init[ (s)
	{
		if (saved_Open = 0)
		{
			SetUseText(941); //open door
		}
		else
		{
			SetUseText(2989);
		}
		SetMPUsable( true );
	} ]

	OnUse[ (s)
	{
		if( saved_Open = 0 )
		{
			// the door is closed.  open it!
			
			if (bPlaySound = true)
			{
				GetPlayer().PlaySound( 63 );
			}
			
			bPlaySound=true;
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
			
			if (bPlaySound = true)
			{
				GetPlayer().PlaySound( 62 );
			}
			
			bPlaySound=true;
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