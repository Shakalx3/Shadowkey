{
	saved_Enter [0]
	saved_Ctaker_Exit [0]
	saved_str5 [0]
	saved_agi5 [0]
	saved_end5 [0]
	saved_spd5 [0]
	saved_str6 [0]
	saved_agi6 [0]
	saved_end6 [0]
	saved_spd6 [0]
	saved_str7 [0]
	saved_agi7 [0]
	saved_end7 [0]
	saved_spd7 [0]
	saved_str8 [0]
	saved_str9 [0]
	saved_Umbra[0]
	saved_WeTalked[0]
	saved_vig[0]
	saved_SetZone[0]
	saved_Swdoor[0]
	bUmbraSpawned[false]

	Init[ ()
	{
		PlayAmbient(74,100);

		if(saved_SetZone = 0)
		{
			SetZone(19, 25000);
			saved_SetZone = 1;
		}

		doorTrigger = AddTrigger("door1");
		doorTrigger.SetTrap(3, 23, 25);
		doorTrigger.SetCallback("OnOpenDoor");
		doorTrigger.RemainActive();

		doorTrigger = AddTrigger("door2");
		doorTrigger.SetTrap(10, 90, 25);
		doorTrigger.SetCallback("OnOpenDoor");
		doorTrigger.RemainActive();

		doorTrigger = AddTrigger("door3");
		doorTrigger.SetTrap(0, 0, 25);
		doorTrigger.SetCallback("OnOpenDoor");
		doorTrigger.RemainActive();

		doorTrigger = AddTrigger("door4");
		doorTrigger.SetTrap(0, 0, 25);
		doorTrigger.SetCallback("OnOpenDoor");
		doorTrigger.RemainActive();

		doorTrigger = AddTrigger("door5");
		doorTrigger.SetTrap(3, 23, 25);
		doorTrigger.SetCallback("OnOpenDoor");
		doorTrigger.RemainActive();

		Level.CreateEffect( 181, 192, 1, 26600, 21239, -1152, 128, 0, 512, 40 );
		Level.CreateEffect( 181, 192, 1, 26609, 19456, -1152, 128, 0, 300, 64 );
		Level.CreateEffect( 181, 192, 1, 21742, 21236, -1152, 128, 0, 256, 32 );
		Level.CreateEffect( 181, 192, 1, 21762, 19702, -1152, 128, 0, 512, 64 );

		Level.CreateEffect( 181, 192, 1, 8697, 17638, -768, 128, 0, 300, 64 );
		Level.CreateEffect( 181, 192, 1, 6378, 22053, -768, 128, 0, 512, 64 );
		Level.CreateEffect( 181, 192, 1, 12801, 22246, -400, 128, 0, 300, 40 );
		Level.CreateEffect( 181, 192, 1, 10225, 20465, 0, 128, 0, 256, 32 );

		Azra = GetEntity("azra");
		if(GetPlayer().QuestCompleted(24) = true)
		{
			Azra.SummonMe();
		}

		if (saved_Swdoor = 1)
		{
			UnlockZone("swdoor");
		}
		
		bUmbraSpawned=false;
	}]

	OnOpenDoor[ (trigger,who)
	{
		bActive = trigger.IsActive();
		if (bActive = false)
		{
			who.OpenDoor("Open Door");
		}
		else
		{
			GetPlayer().OpenMenu("TrapMenu");
		}
	}]


	EnterZone[ (zone)
	{
		if(zone = "UmbraHere")
		{
			if(GetPlayer().saved_EndGame = 0)
			{
				if(GetPlayer().QuestSolved(240) = true)
				{
					if ( (not IsMultiplayerClient()) and (bUmbraSpawned = false))
					{
						UmbraKeth = Level.GetEntity("Umbra");
						if(UmbraKeth != null)
						{
							UmbraKeth.DestroyObjectMirror(UmbraKeth);
						}
						UmbraKeth=Level.CreateEntity(274, GetPlayer().GetPositionX() + 50, GetPlayer().GetPositionY() + 50, GetPlayer().GetPositionZ());
						if (UmbraKeth != null)
						{
							UmbraKeth.SetCanTeleport(true);
						}
						
						bUmbraSpawned=true;
					}
				}
			}
		}

		if( zone = "vig")
		{
			if(saved_vig = 0)
			{
				Level.Vignette(1);
				saved_vig = 1;
			}
		}
		if( zone = "fire01")
		{
			GetPlayer().OpenMenu("crypt1\\\\firemenu");
		}

		if( zone = "fire02")
		{
			GetPlayer().OpenMenu("crypt1\\\\firemenu");
		}

		if( zone = "fire03")
		{
			GetPlayer().OpenMenu("crypt1\\\\firemenu");
		}

		if( zone = "fire04")
		{
			GetPlayer().OpenMenu("crypt1\\\\firemenu");
		}

		if( zone = "fire05")
		{
			GetPlayer().OpenMenu("crypt1\\\\firemenu");
		}

		if( zone = "fire06")
		{
			GetPlayer().OpenMenu("crypt1\\\\firemenu");
		}

		if( zone = "fire07")
		{
			GetPlayer().OpenMenu("crypt1\\\\firemenu");
		}

		if( zone = "fire08")
		{
			GetPlayer().OpenMenu("crypt1\\\\firemenu");
		}

		if(saved_Enter = 0)
		{
			if(zone = "Entrance")
			{
				GetPlayer().OpenMenu("crypt1\\\\entrance");
				saved_Enter = 1;
			}
		}

		if(zone = "To_Lvl_2")
		{
			LoadLevel("crypt2");
			GetPlayer().SetCameraStart( 30825, 30475, 1536, 0, -17115, 0 );
		}

		if( zone = "To_Stouts" )
		{
			LoadLevel("stouttp");
			GetPlayer().SetCameraStart( 30144, 28074, -4480, 0, -23264, 0 );
		}

		if ( saved_str5 = 0)
		{
			//Log("You are entering an attribute check zone");
			if ( zone = "str5" )
			{
				//Log("Testing attribute");
				if(GetPlayer().TestStrength(25) = true)
				{
					Log("You have passed, zone is now dead");
					GetPlayer().OpenMenu("crypt1\\\\CheckPass");
					saved_str5 = 1;
				}
				else
				{
					Log("You have failed, zone is still active");
					GetPlayer().OpenMenu("crypt1\\\\CheckFail5");
				}
			}
		}

		if ( saved_agi5 = 0)
		{
			Log("You are entering an attribute check zone");
			if ( zone = "agi5" )
			{
				Log("Testing attribute");
				if(GetPlayer().TestAgility(25) = true)
				{
					Log("You have passed, zone is now dead");
					GetPlayer().OpenMenu("crypt1\\\\CheckPass");
					saved_agi5 = 1;
				}
				else
				{
					Log("You have failed, zone is still active");
					GetPlayer().OpenMenu("crypt1\\\\CheckFail5");
				}
			}
		}

		if ( saved_end5 = 0)
		{
			Log("You are entering an attribute check zone");
			if ( zone = "end5" )
			{
				Log("Testing attribute");
				if(GetPlayer().TestEndurance(25) = true)
				{
					Log("You have passed, zone is now dead");
					GetPlayer().OpenMenu("crypt1\\\\CheckPass");
					saved_end5 = 1;
				}
				else
				{
					Log("You have failed, zone is still active");
					GetPlayer().OpenMenu("crypt1\\\\CheckFail5");
				}
			}
		}

		if ( saved_spd5 = 0)
		{
			Log("You are entering an attribute check zone");
			if ( zone = "spd5" )
			{
				Log("Testing attribute");
				if(GetPlayer().TestSpeed(25) = true)
				{
					Log("You have passed, zone is now dead");
					GetPlayer().OpenMenu("crypt1\\\\CheckPass");
					saved_spd5 = 1;
				}
				else
				{
					Log("You have failed, zone is still active");
					GetPlayer().OpenMenu("crypt1\\\\CheckFail5");
				}
			}
		}

		if ( saved_str6 = 0)
		{
			Log("You are entering an attribute check zone");
			if ( zone = "str6" )
			{
				Log("Testing attribute");
				if(GetPlayer().TestStrength(30) = true)
				{
					Log("You have passed, zone is now dead");
					GetPlayer().OpenMenu("crypt1\\\\CheckPass");
					saved_str6 = 1;
				}
				else
				{
					Log("You have failed, zone is still active");
					GetPlayer().OpenMenu("crypt1\\\\CheckFail6");
				}
			}
		}

		if ( saved_agi6 = 0)
		{
			Log("You are entering an attribute check zone");
			if ( zone = "agi6" )
			{
				Log("Testing attribute");
				if(GetPlayer().TestAgility(30) = true)
				{
					Log("You have passed, zone is now dead");
					GetPlayer().OpenMenu("crypt1\\\\CheckPass");
					saved_agi6 = 1;
				}
				else
				{
					Log("You have failed, zone is still active");
					GetPlayer().OpenMenu("crypt1\\\\CheckFail6");
				}
			}
		}

		if ( saved_end6 = 0)
		{
			Log("You are entering an attribute check zone");
			if ( zone = "end6" )
			{
				Log("Testing attribute");
				if(GetPlayer().TestEndurance(30) = true)
				{
					Log("You have passed, zone is now dead");
					GetPlayer().OpenMenu("crypt1\\\\CheckPass");
					saved_end6 = 1;
				}
				else
				{
					Log("You have failed, zone is still active");
					GetPlayer().OpenMenu("crypt1\\\\CheckFail6");
				}
			}
		}

		if ( saved_spd6 = 0)
		{
			Log("You are entering an attribute check zone");
			if ( zone = "spd6" )
			{
				Log("Testing attribute");
				if(GetPlayer().TestSpeed(30) = true)
				{
					Log("You have passed, zone is now dead");
					GetPlayer().OpenMenu("crypt1\\\\CheckPass");
					saved_spd6 = 1;
				}
				else
				{
					Log("You have failed, zone is still active");
					GetPlayer().OpenMenu("crypt1\\\\CheckFail6");
				}
			}
		}

		if ( saved_str7 = 0)
		{
			Log("You are entering an attribute check zone");
			if ( zone = "str7" )
			{
				Log("Testing attribute");
				if(GetPlayer().TestStrength(35) = true)
				{
					Log("You have passed, zone is now dead");
					GetPlayer().OpenMenu("crypt1\\\\CheckPass");
					saved_str7 = 1;
				}
				else
				{
					Log("You have failed, zone is still active");
					GetPlayer().OpenMenu("crypt1\\\\CheckFail7to9");
				}
			}
		}

		if ( saved_agi7 = 0)
		{
			Log("You are entering an attribute check zone");
			if ( zone = "agi7" )
			{
				Log("Testing attribute");
				if(GetPlayer().TestAgility(35) = true)
				{
					Log("You have passed, zone is now dead");
					GetPlayer().OpenMenu("crypt1\\\\CheckPass");
					saved_agi7 = 1;
				}
				else
				{
					Log("You have failed, zone is still active");
					GetPlayer().OpenMenu("crypt1\\\\CheckFail7to9");
				}
			}
		}

		if ( saved_end7 = 0)
		{
			Log("You are entering an attribute check zone");
			if ( zone = "end7" )
			{
				Log("Testing attribute");
				if(GetPlayer().TestEndurance(35) = true)
				{
					Log("You have passed, zone is now dead");
					GetPlayer().OpenMenu("crypt1\\\\CheckPass");
					saved_end7 = 1;
				}
				else
				{
					Log("You have failed, zone is still active");
					GetPlayer().OpenMenu("crypt1\\\\CheckFail7to9");
				}
			}
		}

		if ( saved_spd7 = 0)
		{
			Log("You are entering an attribute check zone");
			if ( zone = "spd7" )
			{
				Log("Testing attribute");
				if(GetPlayer().TestSpeed(35) = true)
				{
					Log("You have passed, zone is now dead");
					GetPlayer().OpenMenu("crypt1\\\\CheckPass");
					saved_spd7 = 1;
				}
			else
				{
					Log("You have failed, zone is still active");
					GetPlayer().OpenMenu("crypt1\\\\CheckFail7to9");
				}
			}
		}

		if ( saved_str8 = 0)
		{
			Log("You are entering an attribute check zone");
			if ( zone = "str8" )
			{
				Log("Testing attribute");
				if(GetPlayer().TestStrength(40) = true)
				{
					Log("You have passed, zone is now dead");
					GetPlayer().OpenMenu("crypt1\\\\CheckPass");
					saved_str8 = 1;
				}
				else
				{
					Log("You have failed, zone is still active");
					GetPlayer().OpenMenu("crypt1\\\\CheckFail7to9");
				}
			}
		}

		if ( saved_str9 = 0)
		{
			Log("You are entering an attribute check zone");
			if ( zone = "str9" )
			{
				Log("Testing attribute");
				if(GetPlayer().TestStrength(45) = true)
				{
					Log("You have passed, zone is now dead");
					GetPlayer().OpenMenu("crypt1\\\\CheckPass");
					saved_str9 = 1;
				}
				else
				{
					Log("You have failed, zone is still active");
					GetPlayer().OpenMenu("crypt1\\\\CheckFail7to9");
				}
			}
		}
	}]
}