{
	saved_StartUpCreated [0]
	saved_DoneRoom4	[0]
	saved_DoneRoom5	[0]
	saved_DoneRoom6	[0]
	saved_DoneRoom15[0]
	saved_DoneRoom34 [0]
	saved_Given [0]
	saved_GateA [0]
	saved_GateB [0]
	saved_prison [0]
	saved_Charges [5]
	saved_taker [0]
	saved_SDoor [0]
	saved_Birgitta [0]
	saved_windone [0]
	saved_Griz [0]
	saved_Menu8 [0]
	saved_SSdoor [0]
	saved_locke [0]
	saved_vig[0]
	saved_DelfSpeech [0]
	saved_Birg [0]
	saved_SetZone[0]
	saved_Wake [0]

	Init[ (s)
	{
		if (saved_DoneRoom34 = 1)
		{
			UnlockZone("Room34");
		}

		if ( saved_GateA = 1 )
		{
			UnlockZone("Gate_KeyA");
		}

		if ( saved_GateB = 1 )
		{
			UnlockZone("Gate_KeyB");
		}
		
		if (saved_SSdoor = 1 )
		{
			UnlockZone("swdoor");
		}

		if(GetPlayer().QuestCompleted(233)=true)
		{
			Makor = Level.GetEntity("makor");
			if(Makor != null)
			{
				Makor.DestroyObjectMirror(Makor);
			}
		}

		if(GetPlayer().saved_EndGame = 1)
		{
			Vil1 = Level.GetEntity("vil1");
			if(Vil1 != null)
			{
				Vil1.DestroyObjectMirror(Vil1);
			}

			Vil2 = Level.GetEntity("vil2");
			if(Vil2 != null)
			{
				Vil2.DestroyObjectMirror(Vil2);
			}

			Vil3 = Level.GetEntity("vil3");
			if(Vil3 != null)
			{
				Vil3.DestroyObjectMirror(Vil3);
			}

			Vil4 = Level.GetEntity("vil4");
			if(Vil4 != null)
			{
				Vil4.DestroyObjectMirror(Vil4);
			}

			Heather = Level.GetEntity("heather");
			if(Heather != null)
			{
				Heather.DestroyObjectMirror(Heather);
			}

			Birg = Level.GetEntity("birg");
			if(Birg != null)
			{
				Birg.DestroyObjectMirror(Birg);
			}

			Skelos = Level.GetEntity("skelos");
			if(Skelos != null)
			{
				Skelos.DestroyObjectMirror(Skelos);
			}
		}

		PlayAmbient(74,100);

		if(saved_SetZone = 0)
		{
			SetZone(2, 3000);
			saved_SetZone = 1;
		}
	} ]

	EnterZone[ (ZoneName)
	{
		if(ZoneName = "vig")
		{
			if(saved_vig = 0)
			{
				Level.Vignette(0);
				saved_vig = 1;
			}
		}
		if(ZoneName = "exit" )
		{
			LoadLevel("azra");
			GetPlayer().SetCameraStart( 6417, 27963, -7686, 0, -9108, 0 );
		}
		if(ZoneName = "startup" )
		{
			if( saved_StartUpCreated = 0 )
			{
				GetPlayer().OpenMenu("delfhide\\\\DH_Menu1");
			}
		}
		if(ZoneName = "dh_magpool" )
		{
				GetPlayer().OpenMenu("delfhide\\\\ManaPool");
		}
		if(ZoneName = "Room4" )
		{
			if( saved_DoneRoom4 = 0 )
			{
				GetPlayer().OpenMenu("delfhide\\\\DH_Menu2");
				saved_DoneRoom4 = 1;
			}
		}
		if(ZoneName = "Room5" )
		{
			if( saved_DoneRoom5 = 0 )
			{
				GetPlayer().OpenMenu("delfhide\\\\DH_Menu3");
				saved_DoneRoom5 = 1;
			}
		}
		if(ZoneName = "Room6" )
		{
			if( saved_DoneRoom6 = 0 )
			{
				GetPlayer().OpenMenu("delfhide\\\\DH_Menu4");
				saved_DoneRoom6 = 1;
			}
		}
		if(ZoneName = "Room15" )
		{
			if( saved_DoneRoom15 = 0 )
			{
				GetPlayer().OpenMenu("delfhide\\\\DH_Menu5");

			}
		}
		if(ZoneName = "Arch_Wake" )
		{
			if( saved_Wake = 0 )
			{
				Arch = Level.GetEntity("guard");
				saved_Wake = 1;
				if( Arch != null)
				{
					Arch.AiDetect();
				}

			}
		}
		if(ZoneName = "S_Door")
		{
			if ( saved_SSdoor = 0 )
			{
				if(GetPlayer().FindInventory("skey1") != null)
				{
					GetPlayer().OpenMenu("delfhide\\\\S_door_convo");

				}
			}
		}
		if(ZoneName = "DH_menu8")
		{
			if( saved_Menu8 = 0 )
			{
				GetPlayer().OpenMenu("delfhide\\\\DH_Menu8");
			}
		}
		if(ZoneName = "Room34" )
		{
			if( saved_DoneRoom34 = 0 )
			{
				GetPlayer().OpenMenu("delfhide\\\\DH_Menu9");
			}
		}
		if(ZoneName = "Gate_KeyA" )
		{
			if ( saved_GateA = 0 )
			{
				if(GetPlayer().FindInventory( "keya" ) != null)
				{
					GetPlayer().OpenMenu("delfhide\\\\Gate_Open_A");
				}
				else
				{
					GetPlayer().OpenMenu("delfhide\\\\Gate_Locked_A");
				}
			}
		}
		if(ZoneName = "Gate_KeyB" )
		{
			if ( saved_GateB = 0 )
			{
				if(GetPlayer().FindInventory( "keyb" ) != null)
				{
					GetPlayer().OpenMenu("delfhide\\\\Gate_Open_B");

				}
				else
				{
					GetPlayer().OpenMenu("delfhide\\\\Gate_Locked_B");
				}
			}
		}
		return;
	}]

	MenuQuit[ (s)
	{
		Quit();
	} ]
}