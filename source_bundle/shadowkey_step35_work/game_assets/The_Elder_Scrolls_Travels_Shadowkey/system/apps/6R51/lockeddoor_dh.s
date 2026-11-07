{
	saved_Open [0]
	saved_bCanOpen[false]
	resistDisarm[5]
	quest_door[false]
	bPlaySound[true]

	Init[ (s)
	{
		SetMagicDamage(4017);
		SetSpellLevel(8);
		SetDormant(true);

		if (saved_Open = 0)
		{
			SetUseText(1896);
		}
		else
		{
			SetUsable(false);
		}	
		SetMPUsable( true );
	} ]

	OnUse[ (s)
	{
		if (saved_Open = 0)
		{
			if (quest_door = false)
			{
				OpenMenu("Menus\\\\UsePicks");
			}
		}
	}]

	LockPicked[()
	{
		OpenMenu("Menus\\\\LockPickDoor");
		OpenDoor(" ");
		SetUsable(false);
		//MirrorMethod("ReallyPicked");
	}]

	ReallyPicked[ (s)
	{
		OpenDoor(" ");
		SetUsable(false);
	} ]

	MagicDamage[()
	{
		DoMagicDamage(4017);
		OpenMenu("Menus\\\\PickFailedDamage");
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
				SetUsable(false);
				SetUseText(714);
				return;
			}
		}
	} ]
}