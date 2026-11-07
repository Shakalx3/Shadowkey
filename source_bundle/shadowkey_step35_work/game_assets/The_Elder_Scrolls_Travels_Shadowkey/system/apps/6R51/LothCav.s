{
	saved_SawPilgrim [0]
	saved_RitualCount [0]
	fight41
	hasKey [0]
	doorTrigger
	save_SawOrb [0]
	saved_Gate2Zone [0]
	saved_Chest08 [0]
	saved_TookQuest43 [0]
	saved_DeadGone [0]
	saved_Quest43Done [0]
	saved_AssQuest44 [0]
	saved_DeadBeGone[0]
	saved_Entrance[0]
	saved_SetZone[0]
	saved_Wake [0]
	saved_madewight[0]


	Init[ (s)
	{
		Level.PlayAmbient(70,100);

		if(saved_SetZone = 0)
		{
			SetZone(13, 21500);
			saved_SetZone = 1;
		}

		fight41 = AddEncounters("battle41");
		fight41.AddRandomSets(272, 1);
		fight41.SetActive(false);
		fight41.SetLimit(0,1);

		wightTrigger = AddTrigger("wight41");
		wightTrigger.SetCallback("WightKilled");
		wightTrigger.SetEntityID(272);
		wightTrigger.SetLimit(1);

		cryTrigger = AddTrigger("Crystal");
		cryTrigger.SetCallback("DestroyedCrystal");
		cryTrigger.SetEntityID(1015);
		cryTrigger.SetLimit(1);

		spikeTrap = AddTrigger("spikes");
		spikeTrap.AddEntity(1013);
		spikeTrap.SetTrap(8, 20, 10);
		spikeTrap.RemainActive();
		spikeTrap.ShowDamageMessage(true);

		ceilTrap = AddTrigger("masher");
		ceilTrap.AddEntity(1011);
		ceilTrap.SetTrap(4, 32, 10);
		ceilTrap.RemainActive();
		ceilTrap.ShowDamageMessage(true);

		steamTrap = AddTrigger("steam vents");
		steamTrap.AddEntity(1012);
		steamTrap.SetTrap(20, 35, 10);
		steamTrap.RemainActive();
		ceilTrap.ShowDamageMessage(true);
	} ]

	EnterZone[ (s)
	{
		if(s = "Wake")
		{
			if (saved_Wake = 0 )
			{
				Du = GetEntity("duvais");
				if( Du != null)
				{
						Du.ShowEntity(true);
						Du.SetPassable(false);
						Du.SetUsable(false);
						Du.AiDetect();
						saved_Wake = 1;
						Du.MirrorMethod("RevealSelf");
				}

			}
		}
		if ( s = "Entrance" )
		{
			if (saved_Entrance = 0)
			{
				GetPlayer().OpenMenu("lothna\\\\Entrance");
			}
		}
		if ( s = "Exit" )
		{
			LoadLevel("drgnfld");
			GetPlayer().SetCameraStart( 2728, 5978, -2374, 0, 16377, 0 );
		}
		if ( s = "ghost" )
		{
			if (saved_SawPilgrim = 0)
			{
				GetPlayer().OpenMenu("lothna\\\\see_ghost");

			}
		}

		if ( s = "graves" )
		{
			if (saved_DeadBeGone = 0)
			{
				if (GetPlayer().QuestCompleted(44) = false)
				{
					if (GetPlayer().QuestAssigned(44) = true)
					{
						GetPlayer().OpenMenu("lothna\\\\pilgrim_remains");
					}
					else
					{
						GetPlayer().OpenMenu("lothna\\\\dead_pilgrims");
					}
				}
			}
		}
		if ( s = "orbzone" )
		{
			if (save_SawOrb = 0)
			{
				GetPlayer().OpenMenu("lothna\\\\view_orb");
				save_SawOrb=1;
			}
		}

		if( s = "exit" )
		{
			Level.LoadLevel("azra");
			GetPlayer().SetCameraStart( 15416, 30336, -7664, 0, 4679, 0 );
		}
	} ]

	LC_PruneDungeon[ ()
	{
		pilgrm = GetEntity("pilgrm");
		if (pilgrm != null)
		{
			pilgrm.DestroyObjectMirror(pilgrm);
		}

		skull1 = GetEntity("skul1");
		if (skull1 != null)
		{
			skull1.DestroyObjectMirror(skull1);
		}

		skull2 = GetEntity("skul2");
		if (skull2 != null)
		{
			skull2.DestroyObjectMirror(skull2);
		}

		skull3 = GetEntity("skul3");
		if (skull3 != null)
		{
			skull3.DestroyObjectMirror(skull3);
		}

		skull4 = GetEntity("skul4");
		if (skull4 != null)
		{
			skull4.DestroyObjectMirror(skull4);
		}
	}]

	WightKilled[ (id, who)
	{
		//UnlockZone("lock41");
		GetPlayer().SetQuestSolved(44);
	}]

	DestroyedCrystal[ ()
	{
		//TODO... Make minions easier to kill
		GetPlayer().OpenMenu("lothna\\\\crystal_convo");
	}]

	OpenGate2[ (trigger, who)
	{
		if (doorTrigger.IsActive() = true)
		{
			GetPlayer().OpenMenu("lothna\\\\no_skey8");
		}
		else
		{
			GetPlayer().OpenMenu("lothna\\\\open_gate2");
		}

		//who=GetEntity("sgate");
		x=who.GetPositionX();
		y=who.GetPositionY();
		z=who.GetPositionZ() + 1200;
		who.SetPosition(x,y,z);
		DoorOpened(who); //make this door relevant to all players
		who.SetUsable(false);
	}]

	MenuQuit[ (s)
	{
		Quit();
	} ]
}