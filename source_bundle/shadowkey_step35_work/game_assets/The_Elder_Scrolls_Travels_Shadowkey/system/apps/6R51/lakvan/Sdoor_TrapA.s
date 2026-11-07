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
	}]

	MagicDamage[()
	{
		GetPlayer().DoDamage(20);
		OpenMenu("dstar_e\\\\ChestPickFailed");
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
				DestroyObjectMirror();
				if (GetID() = "11s")
				{
					Level.saved_OpenSDoorA=1;
				}
				if (GetID() = "gg5")
				{
					Level.saved_OpenSDoorB=1;
				}
				if (GetID() = "sdoor1")
				{
					Level.saved_OpenSDoorC=1;
				}
				if (GetID() = "hh6")
				{
					Level.saved_OpenSDoorD=1;
				}				
				return;
			}
		}
	} ]
}