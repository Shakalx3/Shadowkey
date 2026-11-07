{
	saved_Open[0]
	bPlaySound[true]
	Init[ (s)
	{
		if (saved_Open = 0)
		{	
			SetUseText(3958);
		}
		else
		{
			SetUseText(714);
			SetUsable(false);
		}		
	} ]

	OpenDoor[ (s)
	{
		saved_bCanOpen=true;

		if( saved_Open = 0 )
		{
			if (saved_bCanOpen = true)
			{
				if (bPlaySound = true)
				{
					// the door is closed.  open it!
					GetPlayer().PlaySound( 63 );
				}
				else
				{
					bPlaySound = true;
				}
				
				SetPassable( true );
				AddRotationTurn( -64*256 );
				SetPassable( true );
				saved_Open = 1;
				DoorOpened(self,1,0); //replicate door open  1 for open, 0 for normal door
				SetUsable(false);
				SetUseText(714);
				return;
			}
		}
	} ]
}