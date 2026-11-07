{
	saved_Open [0]
	saved_bCanOpen[false]

	Init[ (s)
	{
		SetUseText(1895);
	} ]

	OpenDoor[ (s)
	{
		SetUseText(s);
		saved_bCanOpen=true;

		if( saved_Open = 0 )
		{
			if (saved_bCanOpen = true)
			{
				// the crate is trapped
				saved_Open = 1;
				//DoorOpened(self);
				return;
			}
		}
	} ]
}