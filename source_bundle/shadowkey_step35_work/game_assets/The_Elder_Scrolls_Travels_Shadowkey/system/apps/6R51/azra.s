{
	Azra1Created [0]
	Azra2Created [0]
	Azra3Created [0]
	Azra4Created [0]
	Azra5Created [0]
	Azra6Created [0]
	Azra7Created [0]
	Help1Created [0]
	StartCreated [0]
	saved_AzraRatChestClueCreated [0]
	RatChestCreated [0]
	Bandit01Created [0]
	Bandit02Created [0]
	saved_Junction [0]
	saved_Queue [0]
	saved_Temple [0]
	saved_Asked [0]
	saved_Trinket [0]
	saved_TalkedAzra[0]
	saved_OhNoSkelos[0]
	saved_MetTrinket[0]
	saved_vig[0]
	EndGame_Skelos[0]
	EndGame_Trinket[0]
	saved_SetZone[0]
	
	Init[ (s)
	{
		Level.PlayAmbient(73,100);

		if(saved_SetZone = 0)
		{
			SetZone(1, 2000);
			saved_SetZone = 1;
		}

		if(GetPlayer().saved_EndGame = 1)
		{
			M1 = Level.GetEntity("m1");
			if(M1 != null)
			{
				M1.DestroyObjectMirror(M1);
			}

			M2 = Level.GetEntity("m2");
			if(M2 != null)
			{
				M2.DestroyObjectMirror(M2);
			}

			M3 = Level.GetEntity("m3");
			if(M3 != null)
			{
				M3.DestroyObjectMirror(M3);
			}

			M4 = Level.GetEntity("m4");
			if(M4 != null)
			{
				M4.DestroyObjectMirror(M4);
			}

			M5 = Level.GetEntity("m5");
			if(M5 != null)
			{
				M5.DestroyObjectMirror(M5);
			}

			M6 = Level.GetEntity("m6");
			if(M6 != null)
			{
				M6.DestroyObjectMirror(M6);
			}

			M7 = Level.GetEntity("m7");
			if(M7 != null)
			{
				M7.DestroyObjectMirror(M7);
			}

			M8 = Level.GetEntity("m8");
			if(M8 != null)
			{
				M8.DestroyObjectMirror(M8);
			}

			M9 = Level.GetEntity("m9");
			if(M9 != null)
			{
				M9.DestroyObjectMirror(M9);
			}

			M10 = Level.GetEntity("m10");
			if(M10 != null)
			{
				M10.DestroyObjectMirror(M10);
			}

			M11 = Level.GetEntity("m11");
			if(M11 != null)
			{
				M11.DestroyObjectMirror(M11);
			}

			M12 = Level.GetEntity("m12");
			if(M12 != null)
			{
				M12.DestroyObjectMirror(M12);
			}

			M13 = Level.GetEntity("m13");
			if(M13 != null)
			{
				M13.DestroyObjectMirror(M13);
			}

			M14 = Level.GetEntity("m14");
			if(M14 != null)
			{
				M14.DestroyObjectMirror(M14);
			}

			M15 = Level.GetEntity("m15");
			if(M15 != null)
			{
				M15.DestroyObjectMirror(M15);
			}

			M16 = Level.GetEntity("m16");
			if(M16 != null)
			{
				M16.DestroyObjectMirror(M16);
			}

			M17 = Level.GetEntity("m17");
			if(M17 != null)
			{
				M17.DestroyObjectMirror(M17);
			}

			M18 = Level.GetEntity("m18");
			if(M18 != null)
			{
				M18.DestroyObjectMirror(M18);
			}

			M19 = Level.GetEntity("m19");
			if(M19 != null)
			{
				M19.DestroyObjectMirror(M19);
			}

			M20 = Level.GetEntity("m20");
			if(M20 != null)
			{
				M20.DestroyObjectMirror(M20);
			}
		}

		if(saved_MetTrinket = 1)
		{
			Trinket = GetEntity("trinket");
			if( isObject(Trinket) = true )
			{
				Trinket.DestroyObjectMirror(Trinket);
			}
		}

		if( GetPlayer().saved_Birgidda = 1 )
		{
			Birg = GetEntity("birg");
			if( isObject(Birg) = true )
			{
				Birg.SummonMe();
			}
		}

		if( (GetPlayer().saved_Skelos = 1) and (GetPlayer().QuestAssigned(10) = false) )
		{
			Skelos = GetEntity("skelos");
			if( isObject(Skelos) = true )
			{
				Skelos.SummonMe();
			}
		}

		if(GetPlayer().QuestCompleted(24) = true)
		{
			Azra1 = Level.GetEntity("azra");
			if( isObject(Azra1) = true )
			{
				Azra1.SummonMe();
			}
		}

		if(GetPlayer().CountInventory("stooth") = 7)
		{
			Azra2 = Level.GetEntity("azra");
			if( isObject(Azra2) = true )
			{
				Azra2.DestroyObjectMirror(Azra2);
			}
		}

		if(GetPlayer().saved_Rescue1 = 1)
		{
			Vil1 = Level.GetEntity("vil1");
			Vil1.SummonMe();
		}

		if(GetPlayer().saved_Rescue2 = 1)
		{
			Vil2 = Level.GetEntity("vil2");
			Vil2.SummonMe();
		}

		if(GetPlayer().saved_Rescue3 = 1)
		{
			Vil3 = Level.GetEntity("vil3");
			Vil3.SummonMe();
		}

		if(GetPlayer().saved_Rescue4 = 1)
		{
			Vil4 = Level.GetEntity("vil4");
			Vil4.SummonMe();
		}

		if(GetPlayer().saved_Heather = 1)
		{
			Heather = Level.GetEntity("heather");
			Heather.SummonMe();
		}

		if(GetPlayer().QuestAssigned(25) = true)
		{
			Tanyin1 = Level.GetEntity("tanyin");
			if( isObject(Tanyin1) = true )
			{
				Tanyin1.DestroyObjectMirror(Tanyin1);
			}
		}

		if(GetPlayer().QuestAssigned(26) = true)
		{
			Tanyin2 = Level.GetEntity("tanyin");
			if( isObject(Tanyin2) = true )
			{
				Tanyin2.DestroyObjectMirror(Tanyin2);
			}
		}
	} ]

	EnterZone[ (s)
	{
		if( s = "Done")
		{
			if(GetPlayer().saved_EndGame = 1)
			{
				if(saved_vig = 0)
				{
					Level.Vignette(5);
					saved_vig = 1;

					Azra2 = GetEntity("azra2");
					Azra2.SummonMe2();

					if(GetPlayer().saved_SkelosDead = false)
					{
						Skelos2 = GetEntity("skelos2");
						Skelos2.SummonMe();
					}

					if(GetPlayer().QuestSolved(40) = true)
					{
						Trink2 = GetEntity("trink2");
						if(Trink2 != null)
						{
							Trink2.SummonMe();
						}
					}
				}
			}
		}

		if( s = "Skelos_Dead")
		{
			if(saved_OhNoSkelos = 0)
			{
				if(GetPlayer().saved_SkelosDead = true)
				{
					GetPlayer().OpenMenu("OhNoSkelos");
					saved_OhNoSkelos = 1;
				}
			}
		}

		if( s = "YouSure")
		{
			if(GetPlayer().QuestCompleted(8) = true)
			{
				return;
			}
			else
			{
				if(saved_Asked = 0)
				{
					GetPlayer().OpenMenu("azra_menu_yousure");
					saved_Asked = 1;
				}
			}
		}
		if( s = "help1" )
		{
			if( Help1Created = 0 )
			{
				GetPlayer().OpenMenu("daggerhelp");

				Help1Created = 1;
			}
		}
		if( s = "start" )
		{
			if( StartCreated = 0 )
			{
				GetPlayer().OpenMenu("starthelp");
				StartCreated = 1;
			}
		}

		if( s = "junction" )
		{
			if( saved_Junction = 0 )
			{
				GetPlayer().OpenMenu("junction");
				saved_Junction = 1;
			}
		}

		if( s = "queue" )
		{
			if( saved_Queue = 0 )
			{
				m1 = Level.GetEntity("m1");
				if(m1 != null)
				{
					GetPlayer().OpenMenu("action_queue");
					saved_Queue = 1;
				}
			}
		}

		if( s = "temple" )
		{
			if( saved_Temple = 0 )
			{
				GetPlayer().OpenMenu("temple");
				saved_Temple = 1;
			}
		}

		if( s = "ratclue" )
		{
			if( saved_AzraRatChestClueCreated = 0 )
			{
				GetPlayer().OpenMenu("ratchestclue");
				saved_AzraRatChestClueCreated = 1;
			}
		}
		if( s = "ghasts")
		{
			Level.LoadLevel("GhstPass");
			GetPlayer().SetCameraStart( 16000, 3712, -3720, 0, 0, 0 );
			saved_MetTrinket = 1;
		}
		if( s = "ertear")
		{
			Level.LoadLevel("erthcave");
			GetPlayer().SetCameraStart( 1122, 17777, -64, 0, 16456, 0 );
		}
		if( s = "entdelf")
		{
			Level.LoadLevel("delfhide");
			GetPlayer().SetCameraStart( 17024, 1152, 640, 0, -588, 0 );
			saved_MetTrinket = 1;
		}
	} ]

	MenuQuit[ (s)
	{
		Quit();
	} ]
}