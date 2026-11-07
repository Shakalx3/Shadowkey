{
	saved_vig[0]
	saved_SetZone[0]
	Init[ (s)
	{
		PlayAmbient(78,100);

		if(saved_SetZone = 0)
		{
			SetZone(9, 6000);
			saved_SetZone = 1;
		}

		wight=GetEntity("twight");
		if (wight != null)
		{
			wight.DestroyObjectMirror(wight); //hack for models
		}
	} ]

	EnterZone[ (s)
	{
		if(s = "vig")
		{
			if(saved_vig = 0)
			{
				Level.Vignette(2);
				saved_vig = 1;
			}
		}
		if( s = "Dragonstar" )
		{
			LoadLevel("dstar_w");
			GetPlayer().SetCameraStart( 1540, 17440, -2048, 0, 16035, 0 );
		}
		if( s = "Snowline" )
		{
			LoadLevel("snowline");
			GetPlayer().SetCameraStart( 27264, 2944, -2432, 0, -10228, 0 );
		}
		if( s = "Lothna" )
		{
			LoadLevel("LothCav");
			GetPlayer().SetCameraStart( 30894, 16558, 0, 0, -15872, 0 );
		}
		if( s = "Raiders" )
		{
			LoadLevel("raiders");
			GetPlayer().SetCameraStart( 16526, 31293, 0, 0, 32589, 0 );
		}
	} ]
}
