{
	save_Blind01[0]
	save_Blind02[0]
	saved_Money1[0]
	saved_Money2[0]
	saved_Bread1[0]
	saved_Bread2[0]
	saved_Bread3[0]
	saved_Talk1[0]
	saved_Talk2[0]
	saved_Talk05 [0]
	saved_Entrance [0]
	saved_Displace [0]
	saved_SkeyDoor [0]
	saved_SkeyAttribute [0]
	saved_MageTrainer [0]
	saved_Rbread_menu0 [0]
	saved_Rbread_menu1 [0]
	saved_Rbread_menu2 [0]
	saved_Rbread_menu3 [0]
	saved_Rbread_menu4 [0]
	saved_RMoney0 [0]
	saved_RMoney1 [0]
	saved_RMoney2 [0]
	saved_RMoney3 [0]
	saved_RaidersQ37 [0]
	saved_skyrim_convo [0]
	saved_Guild [0]
	saved_shadowdoor6 [0]
	saved_SetZone[0]
	saved_doorB[0]
	saved_doorC[0]
	saved_doorA[0]
	saved_VisitVolstok[0]
	saved_NoMoreVolstok[0]

	Init[ (s)
	{
		PlayAmbient(73,12);

		if(saved_SetZone = 0)
		{
			SetZone(11, 11500);
			saved_SetZone = 1;
		}

		if (saved_doorB = 1)
		{
			UnlockZone("sdoor6");
		}

		if (saved_doorC = 1)
		{
			UnlockZone("sdoor3");
		}

		if (saved_doorA = 1)
		{
			UnlockZone("sdoor01");
		}

		if(GetPlayer().QuestCompleted(20) = true)
		{
			if(saved_NoMoreVolstok = 0)
			{
				saved_VisitVolstok = 1;
			}
		}
	}]

	EnterZone[ (ZoneName)
	{
		if(ZoneName = "Exit_w")
		{
			LoadLevel("drgnfld");
			GetPlayer().SetCameraStart( 29824, 16512, -2752, 0, -17626, 0 );
		}
		if(ZoneName = "Geldwyr_zone")
		{
			if (saved_shadowdoor6 = 0)
			{
				if(GetPlayer().FindInventory( "skey6" ) != null)
				{
					GetPlayer().OpenMenu("dstar_w\\\\Geldwyr_convo");
				}
			}
		}
		if(ZoneName = "Exit_e")
		{
			if(GetPlayer().QuestCompleted(37)=true)
			{
				LoadLevel("dstar_e");
				GetPlayer().SetCameraStart( 1110, 16818, -2176, 0, 16251, 0 );
			}
			else
			{
				GetPlayer().OpenMenu("dstar_w\\\\Quest37");
			}
		}
		if(ZoneName = "zone_porliss")
		{
			if((GetPlayer().QuestCompleted(29) = true) or (GetPlayer().QuestCompleted(88) = true))
			{
				Porliss = GetEntity("porliss");
				Porliss.ShowEntity(true);
				Porliss.SetUsable(true);
				Porliss.SetPassable(false);
			}
			else
			{
				Porliss = GetEntity("porliss");
				Porliss.ShowEntity(false);
				Porliss.SetUsable(false);
				Porliss.SetPassable(true);
			}
		}
		if(ZoneName = "Zvoldoor")
		{

			if(GetPlayer().QuestSolved(20)=true)
			{
				Zvol = GetEntity("volo");
				Zvol.ShowEntity(true);
				Zvol.SetUsable(true);
				Zvol.SetPassable(false);
			}
			else
			{
				Zvol = GetEntity("volo");
				Zvol.ShowEntity(false);
				Zvol.SetUsable(false);
				Zvol.SetPassable(true);
			}
		}

		if(ZoneName = "Displace")
		{
			if(saved_Displace = 0)
			{
				GetPlayer().OpenMenu("dstar_w\\\\Displace");
				saved_Displace = 1;
			}
		}

		if(ZoneName = "sk6zone1")
		{
			if(GetPlayer().FindInventory("skey7") != null)
			{
				Door = GetEntity("sk6dr1");
				Door.OpenDoor("Open Door");
			}
		}

		if(ZoneName = "sk6zone2")
		{
			if(GetPlayer().FindInventory("skey7") != null)
			{
				Door = GetEntity("sk6dr2");
				Door.OpenDoor("Open Door");
			}
		}

		if(ZoneName = "skeyatr")
		{
			if(saved_SkeyAttribute = 0)
			{
				GetPlayer().OpenMenu("dstar_w\\\\skey_attribute");
				saved_SkeyAttribute = 1;
			}
		}

		if(ZoneName = "sk6zone3")
		{
			if(GetPlayer().FindInventory("skey7") != null)
			{
				Door = GetEntity("sk6dr3");
				Door.OpenDoor("Open Door");
				Doorb = GetEntity("sk6dr3b");
				Doorb.OpenDoor("Open Door");
			}
		}
	}]
}