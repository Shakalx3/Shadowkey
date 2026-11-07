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


				Sdoor = Level.GetEntity("sdoor");
				Sdoor.DestroyObjectMirror(Sdoor);
				GetPlayer().PlaySound( 63 );
				saved_Open = 1;
				return;
			}
		}
	} ]
}