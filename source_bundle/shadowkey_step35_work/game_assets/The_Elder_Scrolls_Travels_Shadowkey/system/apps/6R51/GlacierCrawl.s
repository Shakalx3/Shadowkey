{
	saved_13skey[0]
	saved_2skey[0]
	saved_Ice2[0]
	saved_Ice1[0]
	saved_Nym[0]
	saved_vig[0]
	saved_SetZone[0]
	Init[ (s)
	{
		Level.PlayAmbient(74,100);

		if(saved_SetZone = 0)
		{
			SetZone(18, 32500);
			saved_SetZone = 1;
		}
		
		if(saved_Ice2 = 1)
		{
			UnlockZone("13skey");
		}
		
		if(saved_Ice1 = 1)
		{
			UnlockZone("2skey");
		}		
	} ]

	EnterZone[(s)
	{
		if(s = "vig")
		{
			if(saved_vig = 0)
			{
				Level.Vignette(4);
				saved_vig = 1;
			}
		}
		if(s = "CaptainNym")
		{
			if(saved_Nym = 0)
			{
				CreateEntity(921, 9728, 4505, 400);
				GetPlayer().OpenMenu("glcrcrwl\\\\nym_convo");
				saved_Nym = 1;
			}
		}

		if( s = "Stouts" )
		{
			LoadLevel("stouttp");
			GetPlayer().SetCameraStart( 4033, 10562, -4509, 0, 9941, 0 );
		}

		if( s = "13skey" )
		{
			if(saved_Ice2 = 0)
			{
				if(GetPlayer().FindInventory("skey11") != null)
				{
					GetPlayer().OpenMenu("glcrcrwl\\\\s_ice2");
				}
				else
				{
					GetPlayer().OpenMenu("glcrcrwl\\\\IceWall");
				}
			}
		}

		if( s = "2skey" )
		{
			if(saved_Ice1 = 0)
			{
				if(GetPlayer().FindInventory("skey11") != null)
				{
					GetPlayer().OpenMenu("glcrcrwl\\\\s_ice1");
				}
				else
				{
					GetPlayer().OpenMenu("glcrcrwl\\\\IceWall");
				}
			}
		}
	}]
}