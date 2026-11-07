{
	saved_Open [0]

	Init[ (s)
	{
		SetUseText(1896);
	} ]

	OnUse[ (s)
	{
		if (saved_Open = 0)
		{
			OpenMenu("Crypt1\\\\ctaker_door");
			OpenDoor(" ");
			SetUsable(false);
			saved_Open = 1;
			return;
		}
	}]

	OpenDoor[ (s)
	{
		SetUseText(s);
		saved_bCanOpen=true;

		if( saved_Open = 0 )
		{
			if (saved_bCanOpen = true)
			{
				// the door is closed.  open it!
				SetPassable( true );
				AddRotationTurn( -64*256 );
				SetPassable( true );
				saved_Open = 1;
				DoorOpened(self,1,0); //replicate door open  1 for open, 0 for normal door
				return;
			}
		}
	} ]
}