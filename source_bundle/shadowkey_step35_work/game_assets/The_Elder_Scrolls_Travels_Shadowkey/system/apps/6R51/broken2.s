{

	EntryZone [0]
	ShadowKey10 [0]
	ShadowKey10b [0]
	ShadowKey10_passed [0]
	ShadowKey10b_passed [0]
	saved_MetPero[0]
	saved_SetZone[0]

	Init[()
	{
		PlayAmbient(69,100);

		if(saved_SetZone = 0)
		{
			SetZone(16, 20500);
			saved_SetZone = 1;
		}
	}]

	EnterZone[(zone)
	{
		//if (zone = "Pero")
		//{
		//	if(saved_MetPero = 0)
		//	{
		//		GetPlayer().OpenMenu("broken2\\\\perosius_temp_convo");
		//		saved_MetPero = 1;
		//	}
		//}

		if (zone = "BW_1")
		{
			//GetPlayer().OpenMenu("broken2\\\\To_BW1");
			LoadLevel("broken1");
			GetPlayer().SetCameraStart( 16687, 19106, -1024, 0, 576, 0 );
		}

		if (zone = "entry")
		{
			if (EntryZone = 0)
			{
				EntryZone = 1;
				GetPlayer().OpenMenu("broken2\\\\b2_menu1");
			}
		}

		if (zone = "tele01")
		{
			Player = GetPlayer();
			Player.SetPosition(9216,28949,100);
		}

		if (zone = "shadowgate")
		{
			if (ShadowKey10_passed = 0)
			{
				GetPlayer().OpenMenu("broken2\\\\b2_menu2");
			}
		}

		if (zone = "shadowgate_b")
		{
			if (ShadowKey10b_passed = 0)
			{
				GetPlayer().OpenMenu("broken2\\\\b2_menu2b");
			}
		}

		if (zone = "tele02")
		{
			if (ShadowKey10 = 1)
			{
				Player = GetPlayer();
				Player.SetPosition(31978,28160,0);
				ShadowKey10_passed = 1;
			}
		}

		if (zone = "tele03")
		{
			Player = GetPlayer();
			Player.SetPosition(710,24356,-192);
		}

		if (zone = "tele04")
		{
			Player = GetPlayer();
			Player.SetPosition(28010,22208,0);
		}

		if (zone = "tele05")
		{
			Player = GetPlayer();
			Player.SetPosition(4138,9002,128);
		}

		if (zone = "tele06")
		{
			Player = GetPlayer();
			Player.SetPosition(896,5248,-192);
		}

		if (zone = "tele07")
		{
			if (ShadowKey10b = 1)
			{
				Player = GetPlayer();
				Player.SetPosition(9920,2026,128);
				ShadowKey10b_passed = 1;
			}
		}

		if (zone = "rtele01")
		{
			Player = GetPlayer();
			Player.SetPosition(14592,28288,128);
		}

		if (zone = "rtele02")
		{
			Player = GetPlayer();
			Player.SetPosition(16640,28202,128);
		}

		if (zone = "rtele03")
		{
			Player = GetPlayer();
			Player.SetPosition(7637,22037,128);
		}

		if (zone = "rtele04")
		{
			Player = GetPlayer();
			Player.SetPosition(24320,19050,128);
		}

		if (zone = "rtele05")
		{
			Player = GetPlayer();
			Player.SetPosition(16064,3050,128);
		}

		if (zone = "rtele06")
		{
			Player = GetPlayer();
			Player.SetPosition(22357,12800,128);
		}

		if (zone = "rtele07")
		{
			Player = GetPlayer();
			Player.SetPosition(29888,7658,128);
		}

	}]

	Broken2_PruneDungeon[ ()
	{

		perosius = GetEntity("pero");
		if (perosius != null)
		{
			perosius.DestroyObjectMirror(perosius);
		}

		sloot1 = GetEntity("sloot1");
		if (sloot1 != null)
		{
			sloot1.DestroyObjectMirror(sloot1);
		}

		sloot2 = GetEntity("sloot2");
		if (sloot2 != null)
		{
			sloot2.DestroyObjectMirror(sloot2);
		}
	}]
}