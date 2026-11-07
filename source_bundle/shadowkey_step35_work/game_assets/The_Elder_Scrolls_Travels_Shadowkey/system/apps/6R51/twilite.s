{
	saved_TT_Menu1 [0]
	saved_TT_Menu2 [0]
	saved_TT_Menu2b [0]
	saved_TT_Menu3 [0]
	saved_PrayerMenu [0]
	saved_PrstMenu [0]
	saved_zombieQuest [0]
	saved_zombieDusk [0]
	saved_Goblin [0]
	saved_SetZone[0]
	saved_Dawn [0]
	saved_OpenA[0]
	saved_OpenB[0]
	saved_OpenC[0]
	saved_SSdoor[0]

	Init[ (s)
	{
		Level.CreateEffect( 193, 204, 1, 17290, 18560, 0, 128, 0, 512, 40 );
		Level.CreateEffect( 193, 204, 1, 15242, 17018, 0, 128, 0, 300, 64 );
		Level.CreateEffect( 193, 204, 1, 13696, 17022, 0, 128, 0, 256, 32 );
		Level.CreateEffect( 193, 204, 1, 15756, 14716, 0, 128, 0, 512, 64 );
		Level.CreateEffect( 193, 204, 1, 18304, 15224, 0, 128, 0, 512, 64 );

		PlayAmbient(74,75);

		if(saved_SetZone = 0)
		{
			SetZone(5, 6000);
			saved_SetZone = 1;
		}

		if (saved_Goblin = 1 )
		{
			Gobie = GetEntity("gobtalk");
			if( Gobie!= null)
			{
				Gobie.SetAggressive(true);
				Gobie.SetInvulnerable(false);
				Gobie.SetUsable(false);
			}
		}

		if (saved_OpenA = 1)
		{
			UnlockZone("4a_open");
		}

		if (saved_OpenB = 1)
		{
			UnlockZone("4b_open");
		}

		if (saved_OpenC = 1)
		{
			UnlockZone("4c_open");
		}

		if (saved_SSdoor = 1)
		{
			UnlockZone("sdoorA");
			UnlockZone("sdoorB");
		}
	} ]

	EnterZone[ (ZoneName)
	{
		if(ZoneName = "zombie_check")
		{
			if (saved_zombieQuest = 1 )
			{
				Dawn1 = GetEntity("dawn1");
				Dawn2 = GetEntity("dawn2");
				if( Dawn1 != null){Dawn1.SetInvulnerable(false);}
				if( Dawn2 != null){Dawn2.SetInvulnerable(false);}

			}
		}
		if(ZoneName = "zombie_dusk")
		{
			if (saved_zombieDusk = 1 )
			{
				Dusk1 = GetEntity("dusk1");
				Dusk2 = GetEntity("dusk2");
				Dusk3 = GetEntity("dusk3");
				Dusk4 = GetEntity("dusk4");
				if( Dusk1 != null){Dusk1.SetInvulnerable(false);}
				if( Dusk2 != null){Dusk2.SetInvulnerable(false);}
				if( Dusk3 != null){Dusk3.SetInvulnerable(false);}
				if( Dusk4 != null){Dusk4.SetInvulnerable(false);}

			}
		}
		if(ZoneName = "GhstPass")
		{
			LoadLevel("GhstPass");
			GetPlayer().SetCameraStart( 30080, 25216, -2560, 0, -15909, 0 );
		}
		if(ZoneName = "Steam01")
		{
			GetPlayer().OpenMenu("twilite\\\\MistMenu");
		}

		if(ZoneName = "Steam02")
		{
			GetPlayer().OpenMenu("twilite\\\\MistMenu");
		}

		if(ZoneName = "Steam03")
		{
			GetPlayer().OpenMenu("twilite\\\\MistMenu");
		}

		if(ZoneName = "Steam04")
		{
			GetPlayer().OpenMenu("twilite\\\\MistMenu");
		}

		if(ZoneName = "Steam05")
		{
			GetPlayer().OpenMenu("twilite\\\\MistMenu");
		}

		if(ZoneName = "Prayer_Menu")
		{
			if ((saved_PrayerMenu = 0) and (GetPlayer().QuestCompleted(20)=false))
			{
				GetPlayer().OpenMenu("twilite\\\\PrayMenu");
				saved_PrayerMenu = 1;
			}
		}

		if(ZoneName = "Priest_Menu")
		{
			if( saved_PrstMenu = 0)
			{
				GetPlayer().OpenMenu("twilite\\\\PrstMenu");
				saved_PrstMenu = 1;
			}
		}

		if(ZoneName = "TT_Menu1")
		{
			if( saved_TT_Menu1 = 0)
			{
				GetPlayer().OpenMenu("twilite\\\\TL_Menu1");
				saved_TT_Menu1 = 1;
			}
		}

		if(ZoneName = "TT_Menu2")
		{
			if( saved_TT_Menu2 = 0)
			{
				GetPlayer().OpenMenu("twilite\\\\TL_Menu2");
				saved_TT_Menu2 = 1;
			}
		}
		//if(ZoneName = "TT_Menu2b")
		//{
		//	if( saved_TT_Menu2b = 0)
		//	{
		//		GetPlayer().OpenMenu("twilite\\\\TL_Menu2");
		//		saved_TT_Menu2b = 1;
		//	}
		//}

		if(ZoneName = "TT_Menu3")
		{
			if( saved_TT_Menu3 = 0)
			{
				if(GetPlayer().FindInventory("dskscrl") = null)
				{
					GetPlayer().OpenMenu("twilite\\\\TL_Menu3");
					saved_TT_Menu3 = 1;
				}
			}
		}
		if(ZoneName = "Popup")
		{
			if( saved_TT_Menu3 = 0)
			{
				GetPlayer().OpenMenu("twilite\\\\TL_Menu3");
				saved_TT_Menu3 = 1;
			}
		}
		if(ZoneName = "4a_open")
		{
			if(GetPlayer().FindInventory("dwnscrl") != null)
			{
				Door = GetEntity("4a_left");
				Door.OpenDoor("Open Door");
				saved_OpenA = 1;
			}
		}

		if(ZoneName = "4b_open")
		{
			if(GetPlayer().FindInventory("dskscrl") != null)
			{

				Door = GetEntity("4b_rght");
				Door.OpenDoor("Open Door");
				saved_OpenB=1;
			}
		}

		if(ZoneName = "4c_open")
		{
			if((GetPlayer().FindInventory("dwnscrl") != null) and (GetPlayer().FindInventory("dskscrl") != null))
			{
				Door = GetEntity("4c_door");
				Door.OpenDoor("Open Door");
				saved_OpenC=1;
			}
		}
		if(ZoneName = "7_open")
		{
			if(GetPlayer().FindInventory("skey3") != null)
			{
				Door = GetEntity("7_left");
				Door.OpenDoor("Open Door");

				Door = GetEntity("7_right");
				Door.OpenDoor("Open Door");
			}
		}
	}]
}