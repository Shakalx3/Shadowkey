{
	StartUpCreated [0]
	Room4Entered [0]
	Room11Entered [0]
	Room24Entered [0]
	saved_WardPassed [0]
	saved_bandage [0]
	saved_Charges0 [5]
	saved_Charges1 [5]
	saved_Charges2 [5]
	saved_Charges3 [5]
	saved_Charges4 [5]
	saved_Charges5 [5]
	saved_WeTalked1[0]
	saved_WeTalked2[0]
	saved_WeTalked3[0]
	saved_WeTalked4[0]
	saved_WeTalked5[0]
	saved_Dead[1]
	saved_OptionGiven[0]
	saved_SetZone[0]
	saved_DontUseMeAnymore[0]

	Init[ (s)
	{
		if(GetPlayer().saved_EndGame = 1)
		{
			Skelos = Level.GetEntity("skelos");
			if(Skelos != null)
			{
				Skelos.DestroyObjectMirror(Skelos);
			}
		}

		if(GetPlayer().QuestAssigned(10) = true)
		{
			Skelos = GetEntity("skelos");
			if(Skelos != null)
			{
				Skelos.SummonMe();
			}
		}

		if(GetPlayer().saved_SkelosDead = true)
		{
			Skelos = GetEntity("skelos");
			if(Skelos != null)
			{
				Skelos.DestroyObjectMirror(Skelos);
			}
		}

		PlayAmbient(72,100);

		if(saved_SetZone = 0)
		{
			SetZone(3, 4000);
			saved_SetZone = 1;
		}

		doorTrigger = AddTrigger("crate1");
		doorTrigger.AddEntity("crate1");
		doorTrigger.SetTrap(3, 14, 10);
		//doorTrigger.SetCallback("OnOpenCrate");
		//doorTrigger.RemainActive();
	} ]

	OnOpenCrate[ (trigger,who)
	{
		bActive = trigger.IsActive();
	if (bActive = false)
		{
			return;
		}
		else
		{
			GetPlayer().OpenMenu("TrapMenu");
		}
	}]

	EnterZone[ (s)
	{
		if( s = "Skelos_Quest")
		{
			if(GetPlayer().QuestCompleted(10) = true)
			{
				if(saved_Dead = 0)
				{
					if(GetPlayer().saved_SkelosDead = true)
					{
						GetPlayer().OpenMenu("erthcave\\\\skelos_dead");
						saved_Dead = 1;
					}
				}
			}
		}
		if( s = "exit" )
		{
			Level.LoadLevel("azra");
			GetPlayer().SetCameraStart( 27819, 25008, -7560, 0, -32263, 0 );

			if(saved_DontUseMeAnymore = 0)
			{
				if(GetPlayer().QuestCompleted(10) = true)
				{
					GetPlayer().saved_SkelosDead = true;
					saved_Dead = 0;
					saved_DontUseMeAnymore = 1;
				}
			}
		}
		if( s = "startup" )
		{
			if( StartUpCreated = 0 )
			{

				GetPlayer().OpenMenu("erthcave\\\\EC_Menu1");
				StartUpCreated = 1;

			}
		}
		if( s = "Room4" )
		{
			if( Room4Entered = 0 )
			{
				GetPlayer().OpenMenu("erthcave\\\\EC_Menu2");
				Room4Entered = 1;
			}
		}
		if( s = "ward" )
		{
			if( saved_WardPassed = 0 )
			{
				GetPlayer().OpenMenu("erthcave\\\\EC_Menu6");
			}
		}
		if( s = "bandage" )
		{
			if( saved_bandage = 0 )
			{
				GetPlayer().OpenMenu("erthcave\\\\EC_Menu8");
			}
		}
	} ]

	MenuQuit[ (s)
	{
		Quit();
	} ]
}