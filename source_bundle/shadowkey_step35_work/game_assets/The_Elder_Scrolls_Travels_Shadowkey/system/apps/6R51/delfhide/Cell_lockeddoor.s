{
	saved_Open [0]
	saved_bCanOpen[false]
	resistDisarm[8]
	quest_door[false]

	Init[ (s)
	{
		SetUseText(1896);
		SetMPUsable(true);
	} ]

	OnUse[ (s)
	{
		if (saved_Open = 0)
		{
			if (quest_door = false)
			{
				if(GetPlayer().FindInventory( "cellkey" ) != null)
				{
					OpenMenu("delfhide\\\\Use_Cellkey");
				}
				else
				{
					OpenMenu("delfhide\\\\UsePicks");
				}
			}
		}
	}]

	LockPicked[()
	{
		OpenMenu("delfhide\\\\LockPickDoor");
		OpenDoor(" ");
		SetUsable(false);
	}]

	MagicDamage[()
	{
		//DoMagicDamage(); //Use specific lockeddoor_SPELL.s files to trigger traps
		OpenMenu("Menus\\\\PickFailed");
	}]

	Use_CellKey[ (s)
	{
		OpenMenu("delfhide\\\\use_Cellkey");
	}]

	OpenDoor[ (s)
	{
		saved_bCanOpen=true;

		if( saved_Open = 0 )
		{
			if (saved_bCanOpen = true)
			{
				// the door is closed.  open it!
				GetPlayer().PlaySound( 57 );
				SetPassable( true );
				AddRotationTurn( -64*256 );
				SetPassable( true );
				saved_Open = 1;
				DoorOpened(self,0,0); //replicate door open  1 for open, 0 for normal door
				SetUsable(false);
				SetUseText(714);
				return;
			}
		}
	} ]
}