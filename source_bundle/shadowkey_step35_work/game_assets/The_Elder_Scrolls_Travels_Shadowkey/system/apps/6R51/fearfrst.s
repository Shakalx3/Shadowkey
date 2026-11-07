{
	spawn[0]
	saved_Entered[0]
	saved_Shrooms[0]
	saved_Done [0]
	saved_SetZone[0]
	Init[()
	{
		PlayAmbient(70,100);

		if(saved_SetZone = 0)
		{
			SetZone(7, 8000);
			saved_SetZone = 1;
		}

		ivg = GetEntity("ivgrizt");



		if(ivg != null)
		{
			ivg.ShowEntity(false);
			ivg.SetPassable(true);
			ivg.SetUsable(false);
		}


	}]
	EnterZone[(s)
	{
		if(saved_Shrooms = 0)
		{
			if(s = "shrooms")
			{
				GetPlayer().OpenMenu("fearfrst\\\\Mushroom_menu");
				saved_Shrooms = 1;
			}
		}
		if(s = "algae_pool")
		{
			GetPlayer().OpenMenu("fearfrst\\\\loot5_menu");
		}
		if( s = "Exit" )
		{
			LoadLevel("snowline");
			GetPlayer().SetCameraStart( 4021, 29425, -5504, 0, 18799, 0 );
		}
		if(s = "Check")
		{
			if(GetPlayer().QuestSolved(13)=true)
			{
				if((GetPlayer().QuestCompleted(19)=true) and (GetPlayer().QuestAssigned(13)=true))
				{
					Log("Quest 19 is true");
					Gob1 = GetEntity("gob1");
					Gob2 = GetEntity("gob2");
					Gob3 = GetEntity("gob3");
					ivg = GetEntity("ivgrizt");
					if(ivg != null)
					{
						ivg.ShowEntity(true);
						ivg.SetUsable(true);
						ivg.SetPassable(false);

					}
					if(Gob1!= null)
					{
						Gob1.SetAggressive(false);
					}
					if(Gob2!= null)
					{
						Gob2.SetAggressive(false);
					}
					if(Gob3!= null)
					{
						Gob3.SetAggressive(false);
					}
				}
				else
				{
					Log("Quest 19 is not true");
					ivg = GetEntity("ivgrizt");
					if(ivg != null)
					{
						ivg.ShowEntity(false);
						ivg.SetPassable(true);
						ivg.SetUsable(false);
					}
				}
			}
		}
		if( s = "to_ffarena" )
		{
			if(GetPlayer().FindInventory("skey4") != null)
			{
				LoadLevel("ffarena");
				GetPlayer().SetCameraStart( 6150, 7658, 768, 0, 32755, 0 );
			}
			else
			{
				GetPlayer().OpenMenu("NoSKey");
			}
		}
	}]
}