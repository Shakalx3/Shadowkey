{
	save_StartCreated[0]
	save_WitchZone[0]
	save_WolfZone[0]
	save_wolvesKilled[0]
	save_bZombiesKilled[false]
	save_VioletZone[0]
	saved_Olpac[0]
	saved_OlpacTwo[0]
	saved_vig[0]
	saved_SetZone[0]

	Init[ (s)
	{
		Level.PlayAmbient(72,100);

		if(saved_SetZone = 0)
		{
			SetZone(4, 5000);
			saved_SetZone = 1;
		}

		zombieTrigger = AddTrigger("zombiesKilled");
		zombieTrigger.SetCallback("GPZombiesKilled");
		zombieTrigger.SetEntityID(104);
		zombieTrigger.SetLimit(2);

		fight12 = AddEncounters("fight12","fight12W","fight12S");
		fight12.AddRandomSets(205, 2);
		fight12.AddRandomSets(200, 2);
		fight12.AddRandomSets(200, 1, 205, 1);
		fight12.AddRandomSets(205, 1, 200, 2);
		fight12.AddRandomSets(200, 3);

		fight13 = AddEncounters("fight13","fight13C","fight13W");
		fight13.AddRandomSets(107, 2);
		fight13.AddRandomSets(114, 1, 107, 1);
		fight13.AddRandomSets(114, 1, 118, 1, 114, 1);
		fight13.AddRandomSets(114, 2, 118, 1);
		fight13.AddRandomSets(114, 2, 107, 2);

		if (GetPlayer().QuestCompleted(17) = true)
		{
			cameo = Level.GetEntity("cameo");
			if (cameo != null)
			{
				cameo.DestroyObject(cameo);
			}
		}
		return;
	} ]

	EnterZone[ (s)
	{
		if( s = "vig")
		{
			Log("-----> Vignette var is 0");
			if(saved_vig = 0)
			{
				Log("-----> Vignette var is 1 (saved)");
				Level.Vignette(3);
				saved_vig = 1;
			}
		}
		if( s = "Azra" )
		{
			LoadLevel("azra");
			GetPlayer().SetCameraStart( 15834, 29338, -7682, 0, 32691, 0 );
		}
		if( s = "Twilight" )
		{
			LoadLevel("twilite");
			GetPlayer().SetCameraStart( 1005, 16000, 0, 0, 16384, 0 );
		}
		if( s = "start" )
		{
			if( save_StartCreated = 0 )
			{
				GetPlayer().OpenMenu("ghstpass\\\\GP_Menu1");
				save_StartCreated = 1;
			}
		}
		if (s = "witchtree" )
		{
			if (save_WitchZone = 0)
			{
				GetPlayer().OpenMenu("ghstpass\\\\GP_Menu2");
				save_WitchZone=1;
			}
		}
		if (s = "wolves" )
		{
			if (save_WolfZone = 0)
			{
				if (save_wolvesKilled = 0)
				{
					GetPlayer().OpenMenu("ghstpass\\\\GP_Menu4");
					save_WolfZone=1;
				}
			}
		}
		if (s = "violet" )
		{
			if (save_VioletZone = 0)
			{
				GetPlayer().OpenMenu("ghstpass\\\\GP_Menu4");
				save_VioletZone=1;
			}
		}
		if (s = "snowline" )
		{
			GetPlayer().OpenMenu("ghstpass\\\\GP_Menu5");
		}
		if (s = "tosnowline" )
		{
			LoadLevel("snowline");
			GetPlayer().SetCameraStart( 2678, 6228, -2944, 0, 17920, 0 );
		}
		if (s = "BrokenWing" )
		{
			LoadLevel("broken1");
			GetPlayer().SetCameraStart( 16768, 1388, -1024, 0, 0, 0 );
		}
		if (s = "Stouts" )
		{
			LoadLevel("stouttp");
			GetPlayer().SetCameraStart( 18110, 4824, -4512, 0, 443, 0 );
		}
	} ]

	GPZombiesKilled[ (s)
	{
		Level.Log("GPZombiesKilled");
		save_bZombiesKilled=true;
		GetPlayer().SetQuestSolved(14);
	}]

	MenuQuit[ (s)
	{
		Quit();
	} ]
}