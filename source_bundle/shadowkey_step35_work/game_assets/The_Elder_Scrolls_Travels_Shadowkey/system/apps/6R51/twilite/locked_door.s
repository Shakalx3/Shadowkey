{
	saved_Open [0]
	saved_bCanOpen[false]
	resistDisarm[5]
	quest_door[false]

	Init[ (s)
	{
		SetUseText(1896);
	} ]

	OnUse[ (s)
	{
		OpenMenu("twilite\\\\Door_convo");
	}]

	OpenDoor[ (s)
	{
		saved_bCanOpen=true;

		if( saved_Open = 0 )
		{
			if (saved_bCanOpen = true)
			{

				GetPlayer().PlaySound( 63 );
				SetPassable( true );
				AddRotationTurn( -64*256 );
				SetPassable( true );
				saved_Open = 1;
				DoorOpened(self,1,0); //replicate door open  1 for open, 0 for normal door
				SetUsable(false);
				return;
			}
		}
	} ]
}