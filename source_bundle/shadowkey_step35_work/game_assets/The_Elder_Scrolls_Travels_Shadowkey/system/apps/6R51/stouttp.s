{
	saved_EgrienTalked[0]
	saved_SetZone[0]
	Init[ (s)
	{
		Level.PlayAmbient(73,100);

		if(saved_SetZone = 0)
		{
			SetZone(17, 10500);
			saved_SetZone = 1;
		}

		GetEntity("trinket").ShowEntity(false);
	} ]

	EnterZone[ (s)
	{
		if( s = "GhastPass" )
		{
			LoadLevel("GhstPass");
			GetPlayer().SetCameraStart( 13911, 30206, -3808, 0, -15676, 0 );
		}
		if( s = "GlacierCrawl" )
		{
			LoadLevel("GlacierCrawl");
			GetPlayer().SetCameraStart( 30508, 15986, -1024, 0, -16539, 0 );
		}
		if( s = "Crypt" )
		{
			LoadLevel("crypt1");
			GetPlayer().SetCameraStart( 3359, 29830, 0, 0, 16000, 0 );
		}
		if( s = "FiveToSix" )
		{
			GetPlayer().SetPosition( 19859, 18660, -1120 );
		}
		if( s = "SixToFive" )
		{
			GetPlayer().SetPosition( 26313, 31018, -2016 );
		}
		if( s = "Trinket" )
		{
			if(GetPlayer().QuestCompleted(40)=true)
			{
				GetEntity("trinket").ShowOG();				
			}
			else
			{
				GetEntity("trinket").ShowEntity(false);
			}
		}
	} ]
}
