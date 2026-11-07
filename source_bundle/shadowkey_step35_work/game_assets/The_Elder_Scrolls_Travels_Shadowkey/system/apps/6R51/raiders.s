{
	saved_Entrance[0]
	saved_Red [0]
	saved_Blue [0]
	saved_Gold [0]
	saved_Dead_Yelnicin [0]
	saved_Dead_Devron [0]
	saved_Dead_Wulfbris [0]
	saved_NoQuest_Yelnicin [0]
	saved_NoQuest_Devron [0]
	saved_NoQuest_Wulfbris [0]
	saved_EnterGuard [0]
	saved_SetZone[0]
	saved_SSdoor[0]

	Init[ (s)
	{
		PlayAmbient(69,12);

		if(saved_SetZone = 0)
		{
			SetZone(10, 14000);
			saved_SetZone = 1;
		}
		
		if( saved_Blue = 1 )
		{
			UnlockZone("blue_door");
		}
		if( saved_Red = 1 )
		{
			UnlockZone("red_door");
		}
		if( saved_Gold = 1 )
		{
			UnlockZone("gold_door");
		}	
		if (saved_SSdoor = 1)
		{
			UnlockZone("swdoor");
		}			
	}]

	EnterZone[ (ZoneName)
	{
		if(ZoneName = "Exit")
		{
			LoadLevel("drgnfld");
			GetPlayer().SetCameraStart( 20722, 3681, -2856, 0, -1118, 0 );
		}

		if(ZoneName = "eglar_room")
		{
			if( saved_Entrance = 0 )
			{
				saved_Entrance=1;
				GetPlayer().OpenMenu("raiders\\\\eglar_convo");
			}
		}

		if(ZoneName = "red_door")
		{
			if( saved_Red = 0 )
			{
				if(GetPlayer().FindInventory( "redam" ) != null)
				{
					GetPlayer().OpenMenu("Raiders\\\\Red_convo");
				}
			}
		}

		if(ZoneName = "blue_door")
		{
			if( saved_Blue = 0 )
			{
				if(GetPlayer().FindInventory( "blueam" ) != null)
				{
					GetPlayer().OpenMenu("Raiders\\\\Blue_convo");
				}
			}
		}

		if(ZoneName = "gold_door")
		{
			if( saved_Gold = 0 )
			{
				if(GetPlayer().FindInventory("goldam") != null)
				{
					GetPlayer().OpenMenu("Raiders\\\\Gold_convo");
				}
			}
		}
	}]
}