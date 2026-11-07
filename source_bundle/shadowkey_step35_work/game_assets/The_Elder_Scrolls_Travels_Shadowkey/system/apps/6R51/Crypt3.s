{
	message1[0]
	message2[0]
	saved_Entered[0]
	saved_Awaits[0]
	saved_Forge[0]
	saved_Umbra[0]
	saved_SetZone[0]
	bJustSpawned[false]
	
	Init[()
	{
		if(saved_SetZone = 0)
		{
			SetZone(21, 28000);
			saved_SetZone = 1;
		}

		PlayAmbient(74,100);
		
		if(GetPlayer().saved_EndGame = 1)
		{
			UmbraKeth = Level.GetEntity("Umbra");
			if(UmbraKeth != null)
			{
				UmbraKeth.DestroyObjectMirror(UmbraKeth);
			}		
		}
		
		bJustSpawned=false;
	}]
	
	EnterZone[(s)
	{
		if(s = "UmbraHere")
		{
			if(GetPlayer().saved_EndGame = 0)
			{
				if(GetPlayer().QuestSolved(240) = true)
				{
					if ( (not IsMultiplayerClient()) and (bJustSpawned = false))
					{
						UmbraKeth = Level.GetEntity("Umbra");
						if(UmbraKeth != null)
						{
							UmbraKeth.DestroyObjectMirror(UmbraKeth);
						}
						UmbraKeth=Level.CreateEntity(274, GetPlayer().GetPositionX() + 50, GetPlayer().GetPositionY() + 50, GetPlayer().GetPositionZ());
						if (UmbraKeth != null)
						{
							UmbraKeth.SetCanTeleport(true);
						}
						
						bJustSpawned=true;
					}
				}
			}
		}

		if( saved_Entered = 0 )
		{
			if( s = "Entrance" )
			{
				GetPlayer().OpenMenu("CryptSH3\\\\enter_menu");
				saved_Entered = 1;
			}
		}

		if( s = "WatersOfRS" )
		{
			GetPlayer().OpenMenu("CryptSH3\\\\WofRS_menu");
		}

		if( s = "crypt2" )
		{
			LoadLevel("crypt2");
			GetPlayer().SetCameraStart( 1768, 29197, -1024, 0, -114, 0 );
		}

		if( s = "Spotted" )
		{
			GetPlayer().SetQuestSolved(240);
			UmbraKeth = Level.GetEntity("Umbra");
			if(UmbraKeth != null)
			{
				UmbraKeth.SetCanTeleport(true);
			}
		}
	}]
}