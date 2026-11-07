{
	saved_Entrance [0]
	saved_EBread01[0]
	saved_EBread02 [0]
	saved_EBread03 [0]
	saved_EBread04 [0]
	saved_Bread5 [0]
	saved_Bread6 [0]
	saved_Money3 [0]
	saved_Money4 [0]
	saved_Money10 [0]
	saved_Money11 [0]
	saved_Money12 [0]
	save_Cure02 [0]
	saved_HQ [0]
	saved_Temple [0]
	saved_Jail [0]
	saved_SkeyAttribute [0]
	saved_Fighters [0]
	saved_Lock14 [0]
	saved_pitopen [0]
	saved_champion [0]
	saved_CountMonster [0]
	saved_RewardMonster [0]
	saved_pitfans [0]
	saved_ThiefTrainer [0]
	saved_Thief_zone [0]
	saved_Cure01 [0]
	saved_Cure02 [0]
	saved_Moneyconvo01 [0]
	saved_Moneyconvo02 [0]
	saved_Moneyconvo03 [0]
	saved_Moneyconvo04 [0]
	saved_ETalk01 [0]
	saved_ETalk02 [0]
	saved_ETalk03 [0]
	saved_TheifTrap [0]
	ChestBLK01 [0]
	saved_chest01 [0]
	saved_chest02 [0]
	saved_chest03 [0]
	saved_FighterTrainer [0]
	saved_watch_zone [0]
	saved_SetZone[0]
	saved_Moneyconvo10 [0]
	saved_Moneyconvo11 [0]
	saved_Moneyconvo12 [0]
	saved_OpenSwdoor[0]
	saved_Guard[0]

	Init[ (s)
	{
		PlayAmbient(73,12);

		if(saved_SetZone = 0)
		{
			SetZone(12, 16500);
			saved_SetZone = 1;
		}

		doorTrigger = AddTrigger("Chest01");
		doorTrigger.SetTrap(3, 20, 25);
		doorTrigger.SetCallback("OnOpenDoor");
		doorTrigger.RemainActive();

		doorTrigger = AddTrigger("Chest02");
		doorTrigger.SetTrap(10, 90, 25);
		doorTrigger.SetCallback("OnOpenDoor");
		doorTrigger.RemainActive();

		doorTrigger = AddTrigger("Chest03");
		doorTrigger.SetTrap(50,150, 25);
		doorTrigger.SetCallback("OnOpenDoor");
		doorTrigger.RemainActive();

		if(GetPlayer().QuestCompleted(27) = true)
		{
			Tanyin1 = Level.GetEntity("tanyin");
			if( isObject(Tanyin1) = true )
			{
				Tanyin1.SummonMe();
			}
		}

		if(GetPlayer().QuestSolved(26) = true)
		{
			Tanyin1 = Level.GetEntity("tanyin");
			if( isObject(Tanyin1) = true )
			{
				Tanyin1.SummonMe();
			}
		}
		if (saved_OpenSwdoor = 1)
		{
			UnlockZone("sdoor6");
		}
	}]

	EnterZone[ (ZoneName)
	{
		if(ZoneName = "Enter")
		{
			if(saved_Entrance = 0)
			{
				GetPlayer().OpenMenu("dstar_e\\\\entrance");
				saved_Entrance = 1;
			}
		}

		if(ZoneName = "Exit")
		{
			LoadLevel("dstar_w");
			GetPlayer().SetCameraStart( 31437, 17551, -2048, 0, -16575, 0 );
		}

		if(ZoneName = "skey7_attribute")
		{
			if(saved_SkeyAttribute = 0)
			{
				GetPlayer().OpenMenu("dstar_e\\\\skey_attribute");
			}
		}

		if(ZoneName = "HQ")
		{
			if(saved_HQ = 0)
			{
				GetPlayer().OpenMenu("dstar_e\\\\HQ_menu");
				saved_HQ = 1;
			}
		}

		if(ZoneName = "Temple")
		{
			if(saved_Temple = 0)
			{
				GetPlayer().OpenMenu("dstar_e\\\\Temple");
				saved_Temple = 1;
			}
		}
		if(ZoneName = "Fighters")
		{
			if(saved_Fighters = 0)
			{
				GetPlayer().OpenMenu("dstar_e\\\\Fighters");
				saved_Fighters = 1;
			}
		}
		if(ZoneName = "Thief_zone")
		{
			if(saved_Thief_zone = 0)
			{
				GetPlayer().OpenMenu("dstar_e\\\\Thief_zone_convo");
				saved_Thief_zone = 1;
			}
	}
		if(ZoneName = "watch")
		{
			if(saved_watch_zone = 0)
			{
				GetPlayer().OpenMenu("dstar_e\\\\Watch_convo");
				saved_watch_zone = 1;
			}
		}

		if(ZoneName = "Jail")
		{
			if(saved_Jail = 0)
			{
				GetPlayer().OpenMenu("dstar_e\\\\jail_menu");
				saved_Jail = 1;
			}
		}
	}]
}