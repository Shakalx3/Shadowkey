{
	Entrance [0]
	Num_PedUsed [0]
	saved_teethplaced [0]
	saved_Shadowgate [0]
	saved_wayblocked [0]
	saved_PergunDeath [0]
	saved_Keth[0]
	saved_DeathMatch[0]
	saved_OpenSkdoor[0]
	saved_Umbra[0]
	saved_Sanctuary[0]
	saved_Crys1[0]
	saved_Crys2[0]
	saved_Crys3[0]
	saved_Crys4[0]
	saved_Crys5[0]
	saved_Crys6[0]
	saved_Crys7[0]
	num_crystals[0]
	saved_Tele2[0]
	saved_Tele1[0]
	saved_GameOver[0]
	saved_SetZone[0]
	saved_Swdoor[0]
	bUmbraSpawned[false]

	Init[()
	{
		PlayAmbient(74,100);

		if(saved_SetZone = 0)
		{
			SetZone(20, 37500);
			saved_SetZone = 1;
		}
		
		if (saved_Swdoor = 1)
		{
			UnlockZone("swdoor");
		}

		if(saved_Tele1 = 0)
		{
			t1 = GetEntity("tele1");
			if( isObject(t1) )
			{
				t1.ShowEntity(true);
			}
		}
		if(saved_Crys1 = 0)
		{
			c1 = GetEntity("crys1");
			if( isObject(c1) )
			{
				c1.ShowEntity(false);
			}
		}
		if(saved_Crys2 = 0)
		{
			c2 = GetEntity("crys2");
			if( isObject(c2) )
			{
				c2.ShowEntity(false);
			}
		}
		if(saved_Crys3 = 0)
		{
			c3 = GetEntity("crys3");
			if( isObject(c3) )
			{
				c3.ShowEntity(false);
			}
		}
		if(saved_Crys4 = 0)
		{
			c4 = GetEntity("crys4");
			if( isObject(c4) )
			{
				c4.ShowEntity(false);
			}
		}
		if(saved_Crys5 = 0)
		{
			c5 = GetEntity("crys5");
			if( isObject(c5) )
			{
				c5.ShowEntity(false);
			}
		}
		if(saved_Crys6 = 0)
		{
			c6 = GetEntity("crys6");
			if( isObject(c6) )
			{
				c6.ShowEntity(false);
			}
		}
		if(saved_Crys7 = 0)
		{
			c7 = GetEntity("crys7");
			if( isObject(c7) )
			{
				c7.ShowEntity(false);
			}
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
			GetPlayer().OpenMenu("LockedMenu");
		}
	}]

	AddCrystal[()
	{
		num_crystals = num_crystals + 1;
		Log("Crystals are at " # num_crystals);

		if(num_crystals = 7)
		{
			tele = Level.GetEntity("tele1");

			if (tele != null)
			{
				Log("tele1 found!");
				tele.ShowEntity(false);
				tele.SetUseText(false);
			}
			else
			{
				Log("tele1 has gone missing!");
			}

			saved_Tele1 = 1;

			Log("Crystals are working");
			Star = GetEntity("star");
			if (Star != null)
			{
				Star.Delay(1, 0);
			}

			Level.saved_Umbra = 1;
			Level.saved_Keth = 1;
			Level.saved_DeathMatch = 1;
			GetPlayer().AddEffect(Permanent, Defense, Increment, 0, 7);
			GetPlayer().AddEffect(Permanent, ArmorValue, Increment, 0, 7);
		}
	}]

	EnterZone[ (ZoneName)
	{
		if(ZoneName = "UmbraHere")
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

		if(ZoneName = "end_game")
		{
			if(GetPlayer().saved_EndGame = 1)
			{
				LoadLevel("azra");
				GetPlayer().SetCameraStart( 23886, 4506, -2816, 0, 15445, 0 );
			}
		}

		if(ZoneName = "Entrance")
		{
			if( Entrance = 0)
			{
				Entrance = 1;
				GetPlayer().OpenMenu("crypt2\\\\Entrance");
			}
		}

		if(ZoneName = "Port11")
		{
			GetPlayer().saved_KethStatus = 1;

			UmbraKeth = Level.GetEntity("Umbra");
			if(UmbraKeth != null)
			{
				UmbraKeth.DestroyObjectMirror(UmbraKeth);
			}

			Log("My name is Zone Port11");
			player = GetPlayer();
			Log("I have the Player");
			player.SetPositionMirrorAll(4404, 12339, 0);
			Log("My Position has been set.");

			//Umbra = GetEntity("Umbra");
			//if( isObject( Umbra ) )
			//{
			//	Umbra.StopDelay();
			//}
			GetPlayer().saved_GoAway = 1;
		}

		if(saved_DeathMatch = 0)
		{
			if(ZoneName = "Port6a")
			{
				GetPlayer().saved_KethStatus = 0;

				Log("My name is Port6a");
				player = GetPlayer();
				Log("I have the Player");
				player.SetPositionMirrorAll(2472, 16872, 0);
				Log("My Position has been set.");

				UmbraKeth = Level.GetEntity("Umbra");
				if(GetPlayer().QuestSolved(240) = true)
				{
					if (not IsMultiplayerClient())
					{
						if(UmbraKeth != null)
						{
							UmbraKeth.DestroyObjectMirror(UmbraKeth);
						}

						UmbraKeth=Level.CreateEntity(274, GetPlayer().GetPositionX() + 200, GetPlayer().GetPositionY() + 200, GetPlayer().GetPositionZ());
						if (UmbraKeth != null)
						{
							//this final battle
							UmbraKeth.SetCanTeleport(false);
						}

						//if(UmbraKeth != null)
						//{
						//	UmbraKeth.GetDelay();
						//}
					}
				}
			}
		}

		if(ZoneName = "WayBlocked")
		{
			if(saved_PergunDeath = 0)
			{
				GetPlayer().OpenMenu("crypt2\\\\\NoExit");
				GetPlayer().SetPosition( 1800, 31975, 0 );
			}
			if(saved_PergunDeath = 1)
			{
				GetPlayer().OpenMenu("crypt2\\\\\Crypt3");
				saved_PergunDeath = 2;
			}
		}

		if( ZoneName = "crypt1" )
		{
			LoadLevel("crypt1");
			GetPlayer().SetCameraStart( 31128, 31144, 1280, 0, -17293, 0 );
		}

		if( ZoneName = "crypt3" )
		{
			LoadLevel("crypt3");
			GetPlayer().SetCameraStart( 3340, 30991, 1536, 0, -16614, 0 );
		}

		//if( saved_Keth = 0 )
		//{
		//	if( GetPlayer().QuestSolved(240) = true )
		//	{
		//		if( saved_teethplaced = 7 )
		//		{
		//			if( ZoneName = "BringOnKeth" )
		//			{
		//				Level.CreateEntity(274, 4348, 12229, 0);
		//				saved_Umbra = 1;
		//				saved_Keth = 1;
		//				saved_DeathMatch = 1;
		//				GetPlayer().AddEffect(Permanent, Defense, Increment, 0, 7);
		//				GetPlayer().AddEffect(Permanent, ArmorValue, Increment, 0, 7);
		//			}
		//		}
		//	}
		//}

		//if( saved_OpenSkdoor = 0 )
		//{
		//	if( ZoneName = "skdoor" )
		//	{
		//		GetPlayer().OpenMenu("crypt2\\\\skdoor");
		//	}
		//}

		if(saved_Sanctuary = 0)
		{
			if( ZoneName = "Sanctuary" )
			{
				GetPlayer().OpenMenu("crypt2\\\\Sanctuary");
			}
		}
	}]
}