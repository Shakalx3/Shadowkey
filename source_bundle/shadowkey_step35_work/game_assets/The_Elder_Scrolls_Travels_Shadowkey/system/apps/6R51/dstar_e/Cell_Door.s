{
	saved_Open [0]
	saved_bCanOpen[false]
	resistDisarm[5]
	quest_door[false]
	Init[ (s)
	{
		SetUsable(false);
		SetMPUsable(true);

	}]
	LockPicked[()
	{
		OpenMenu("Menus\\\\LockPickDoor");
		OpenDoor(" ");
		SetUsable(false);
	}]

	MagicDamage[()
	{
		//DoMagicDamage(); //Use specific lockeddoor_SPELL.s files to trigger traps
		OpenMenu("Menus\\\\PickFailed");
	}]

	UseKey[ (s)
	{
		OpenMenu("usekey");
	}]

	OpenDoor[ (s)
	{
		saved_bCanOpen=true;

		if( saved_Open = 0 )
		{
			if (saved_bCanOpen = true)
			{
				// the door is closed.  open it!
				GetPlayer().PlaySound( 63 );
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