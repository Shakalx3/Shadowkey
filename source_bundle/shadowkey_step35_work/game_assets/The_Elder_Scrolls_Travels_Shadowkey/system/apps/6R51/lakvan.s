{
	saved_Entrance[0]
	saved_Opened[0]
	saved_LakvanAgro[0]
	saved_SetZone[0]
	saved_SeeLakvan[0]
	saved_OpenSDoorA[0]
	saved_OpenSDoorB[0]
	saved_OpenSDoorC[0]
	saved_OpenSDoorD[0]
	saved_SSdoor[0]

	Init[ (s)
	{
		PlayAmbient(74,75);

		if(saved_SetZone = 0)
		{
			SetZone(10, 24000);
			saved_SetZone = 1;
		}

		if (saved_SeeLakvan = 1)
		{
			UnlockZone("lakvans_room");
		}
		
		if (saved_SSdoor = 1)
		{
			UnlockZone("sdwdoor");
		}
		
		if (saved_OpenSDoorA = 1) 
		{
			UnlockZone("11s");
		}
		
		if (saved_OpenSDoorB = 1) 
		{
			UnlockZone("gg5");
		}		
		if (saved_OpenSDoorC = 1) 
		{
			UnlockZone("sdoor1");
		}		
		if (saved_OpenSDoorD = 1) 
		{
			UnlockZone("hh6");
		}		
	} ]

	EnterZone[ (ZoneName)
	{
		if(ZoneName = "Exit")
		{
			LoadLevel("snowline");
			GetPlayer().SetCameraStart( 29312, 27660, -4224, 0, 32163, 0 );
		}
		if(ZoneName = "Entrance")
		{
			if( saved_Entrance = 0)
			{
				GetPlayer().OpenMenu("lakvan\\\\Entrance");
				saved_Entrance = 1;
			}
		}

		if(ZoneName = "lakvans_room")
		{
			if(GetPlayer().FindInventory("bandkey") != null)
			{
				Door = GetEntity("lakdoor");
				Door.OpenDoor("Open Door");
				saved_SeeLakvan=1;
			}
		}
		if (ZoneName = "To_4A")
		{
			GetPlayer().SetPosition(8089, 4480);
		}

		if (ZoneName = "To_4B")
		{
			GetPlayer().SetPosition(25728, 28313);
		}
	}]
}