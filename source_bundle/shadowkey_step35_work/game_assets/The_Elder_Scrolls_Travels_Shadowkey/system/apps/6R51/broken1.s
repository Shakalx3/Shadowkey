{

	EntryZone [0]
	EntryZone2 [0]
	ArcheryRange [0]
	Makor [0]
	saved_Pit [0]
	ShadowKey10 [0]
	BledDesk [0]
	saved_SetZone[0]
	saved_cageA[0]
	saved_cageB[0]
	saved_cageC[0]
	saved_cageD[0]

	Init[()
	{
		if(GetPlayer().QuestSolved(233)=true)
		{
			Makor = Level.GetEntity("makor");
			if(Makor != null)
			{
				Makor.DestroyObject(Makor);
			}
		}
		PlayAmbient(69,100);

		if(saved_SetZone = 0)
		{
			SetZone(15, 20500);
			saved_SetZone = 1;
		}

		if (saved_cageA = 1)
		{
			UnlockZone("cageA");
		}

		if (saved_cageB = 1)
		{
			UnlockZone("cageB");
		}

		if (saved_cageC = 1)
		{
			UnlockZone("cageC");
		}

		if (saved_cageD = 1)
		{
			UnlockZone("cageD");
		}

		spikeTrap = AddTrigger("spikes");
		spikeTrap.AddEntity(1013);
		spikeTrap.SetTrap(8, 16, 10);
		spikeTrap.RemainActive();
	}]

	EnterZone[(zone)
	{
		//if (zone = "entry")
		//{
		//	if (EntryZone = 0)
		//	{
		//		EntryZone = 1;
		//		GetPlayer().OpenMenu("broken1\\\\b1_menu1");

				//Entry01 = GetEntity("ent01");
				//if( isObject( Entry01 ) )
				//{
				//	Entry01.WalkTo(17834,2538,0,2);
				//}
                                //
				//Entry02 = GetEntity("ent02");
				//if( isObject( Entry02 ) )
				//{
				//	Entry02.WalkTo(17834,3733,1,2);
				//}
                                //
				//Entry03 = GetEntity("ent03");
				//if( isObject( Entry03 ) )
				//{
				//	Entry03.WalkTo(17834,4949,2,2);
				//}
		//	}
		//}

		if (zone = "entry2")
		{
			if (EntryZone2 = 0)
			{
				EntryZone2 = 1;

				//Entry04 = GetEntity("ent04");
				//if( isObject( Entry04 ) )
				//{
				//	Entry04.WalkTo(15722,6293,3,2);
				//}
                                //
				//Entry05 = GetEntity("ent05");
				//if( isObject( Entry05 ) )
				//{
				//	Entry05.WalkTo(15530,7893,4,2);
				//}
                                //
				//Entry06 = GetEntity("ent06");
				//if( isObject( Entry06 ) )
				//{
				//	Entry06.WalkTo(14656,8789,5,2);
				//}
			}
		}

		if (zone = "pit")
		{
			if (saved_Pit = 0)
			{
				saved_Pit = 1;
				GetPlayer().OpenMenu("broken1\\\\pit");
			}
		}

		if (zone = "archery")
		{
			if (ArcheryRange = 0)
			{
				ArcheryRange = 1;
				GetPlayer().OpenMenu("broken1\\\\b1_menu2");
			}
		}

		if (zone = "5a-zone")
		{
			FiveA01 = GetEntity("5a01");
			if( isObject( FiveA01 ) )
			{
				FiveA01.SetAggressive(true);
			}

			FiveA02 = GetEntity("5a02");
			if( isObject( FiveA02 ) )
			{
				FiveA02.SetAggressive(true);
			}
		}

		if (zone = "5b-zone")
		{
			FiveB01 = GetEntity("5b01");
			if( isObject( FiveB01 ) )
			{
				FiveB01.SetAggressive(true);
			}
			FiveB02 = GetEntity("5b02");
			if( isObject( FiveB02 ) )
			{
				FiveB02.SetAggressive(true);
			}
		}

		if (zone = "5d-zone")
		{
			FiveD01 = GetEntity("5d01");
			if( isObject( FiveD01 ) )
			{
				FiveD01.SetAggressive(true);
			}
			FiveD02 = GetEntity("5d02");
			if( isObject( FiveD02 ) )
			{
				FiveD02.SetAggressive(true);
			}
		}

		if (zone = "5e-zone")
		{
			FiveE01 = GetEntity("5e01");
			if( isObject( FiveE01 ) )
			{
				FiveE01.SetAggressive(true);
			}
			FiveE02 = GetEntity("5e02");
			if( isObject( FiveE02 ) )
			{
				FiveE02.SetAggressive(true);
			}
		}

		if (zone = "5f-zone")
		{
			FiveF01 = GetEntity("5f01");
			if( isObject( FiveF01 ) )
			{
				FiveF01.SetAggressive(true);
			}
			FiveF02 = GetEntity("5f02");
			if( isObject( FiveF02 ) )
			{
				FiveF02.SetAggressive(true);
			}
		}

		if (zone = "5g-zone")
		{
			FiveG01 = GetEntity("5g01");
			if( isObject( FiveG01 ) )
			{
				FiveG01.SetAggressive(true);
			}
			FiveG02 = GetEntity("5g02");
			if( isObject( FiveG02 ) )
			{
				FiveG02.SetAggressive(true);
			}
		}

		if (zone = "5h-zone")
		{
			FiveH01 = GetEntity("5h01");
			if( isObject( FiveH01 ) )
			{
				FiveH01.SetAggressive(true);
			}
		}

		if (zone = "Exit")
		{
			LoadLevel("GhstPass");
			GetPlayer().SetCameraStart( 7678, 7112, -1344, 0, -16467, 0 );
		}

		if (zone = "BW_2")
		{
			//GetPlayer().OpenMenu("broken1\\\\To_BW2");
			LoadLevel("broken2");
			GetPlayer().SetCameraStart( 13440, 14976, 0 + 512, 0, 0, 0 );
		}

	}]

	Broken1_PruneDungeon[ ()
	{
		BledDesk = 1;

		branson = GetEntity("branson");
		if (branson != null)
		{
			branson.DestroyObjectMirror(branson);
		}

		helena = GetEntity("helena");
		if (helena != null)
		{
			helena.DestroyObjectMirror(helena);
		}

		meya = GetEntity("meya");
		if (meya != null)
		{
			meya.DestroyObjectMirror(meya);
		}

		makor = GetEntity("makor");
		if (makor != null)
		{
			makor.DestroyObjectMirror(makor);
		}

		loot6 = GetEntity("loot6");
		if (loot6 != null)
		{
			loot6.DestroyObjectMirror(loot6);
		}

		loot7 = GetEntity("loot7");
		if (loot7 != null)
		{
			loot7.DestroyObjectMirror(loot7);
		}

		loot8 = GetEntity("loot8");
		if (loot8 != null)
		{
			loot8.DestroyObjectMirror(loot8);
		}
	}]
}