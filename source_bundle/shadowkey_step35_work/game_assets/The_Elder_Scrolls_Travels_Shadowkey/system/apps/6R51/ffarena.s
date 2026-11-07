{
	saved_Spawn[0]
	saved_Talked [0]
	saved_Failsafe[0]
	saved_TalkedAgain[0]
	saved_SetZone[0]

	Init[()
	{
		PlayAmbient(69,100);

		if(saved_SetZone = 0)
		{
			SetZone(8, 3000);
			saved_SetZone = 1;
		}

		if(GetPlayer().QuestCompleted(24)=true)
		{
			Azra = Level.GetEntity("azra");
			if(Azra != null)
			{
				Azra.DestroyObjectMirror(Azra);
			}
		}
		
		if(saved_Spawn = 1)
		{
			UnlockZone("Crystal");
		}
	}]
	EnterZone[(s)
	{
		if( s = "Crystal" )
		{
			if(saved_Spawn = 0)
			{
				if(GetPlayer().FindInventory("skey4") != null)
				{
					GetPlayer().OpenMenu("ffarena\\\\azra_convo1");
					saved_Spawn = 1;
				}
			}
		}
		if( s = "FearFrost_Exit" )
		{
			LoadLevel("fearfrst");
			GetPlayer().SetCameraStart( 13847, 21810, -1088, 0, 16090, 0 );
		}
	}]
}