{
	saved_Open [0]
	saved_bCanOpen[false]
	resistDisarm[5]
	quest_door[false]
	bPlaySound[true]

	Init[ (s)
	{
		if (saved_Open = 0)
		{
			SetUseText(1896);
		}
		else
		{
			SetUsable(false);
		}
		SetMPUsable(true);
	} ]

	OpenDoor[ (s)
	{
		saved_bCanOpen=true;

		if( saved_Open = 0 )
		{
			if (saved_bCanOpen = true)
			{
				// the door is closed.  open it!
				if (bPlaySound = true)
				{
					GetPlayer().PlaySound( 63 );
				}
				
				bPlaySound=true;
				SetPassable( true );
				AddRotationTurn( 64*256 );
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