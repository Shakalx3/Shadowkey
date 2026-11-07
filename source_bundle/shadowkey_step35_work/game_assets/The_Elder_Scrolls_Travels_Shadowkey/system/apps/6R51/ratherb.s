{
	Init[ (s)
	{
		//SetModel(103);
		SetSkin(1);
		SetAggressive(true);
		SetName(201);
		SetID("arat");
		SetAttack(3);
		SetDefense(4);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(2);
		SetDamageMax(8);
		SetArmorValue(0);
		SetMaxHealth(16);
		SetWimpy(4);
		SetChaseRadius(14000);
		SetAttackNoise(15);
		SetDeathNoise(16);
		SetIsHitNoise(17);
		SetWalkAnimation(1);
                SetSwingAnimation(2);
                SetDeathAnimation(3);
                SetIdleAnimation(0);
                SetLoot( 300, "Loot_ratseye" );

                SetMob(3, 1);
		DetectOnKilled(true);
	}]

	OnKilled [ (s)
	{
		GetPlayer().StatModXP(40);
		
		if (Level.IsMultiplayer() = true)
		{	
				if ( (not IsMultiplayerClient()) and (GetPlayer().IsMenuActive() = false))
				{
					Level.Log("host show ratmenu");
					GetPlayer().OpenMenu("herbhurrah");
				}
				else
				{
					if (IsMultiplayerClient() = true)
					{
						Level.Log("Client show ratmenu");
						GetPlayer().OpenMenu("herbhurrah");
					}				
				}			
		}
		else
		{
			GetPlayer().OpenMenu("herbhurrah");
		}

		//Herbs = Level.CreateEntity( 58 );
		//Herbs.SetModel( 28 );  // bag.bin
		//Herbs.SetPosition( 21357, 3763, -4000);
		GetPlayer().SetQuestSolved(1,true);
		//Delay(2, 0);

		if ( GetPlayer().QuestSolved(0))
		{
			return;
		}
		else
		{
			GetPlayer().AddMonsterKilled (203);
			if (GetPlayer().MonstersKilled(203) >= 8 )
			{
				//Need announcement of success
				if (not GetPlayer().QuestSolved(0))
				{
					// if multiplayerdeath is false
					if( s = false )
					{
						Delay (4, 1);
					}
				}

				Trthgar = Level.GetEntity("trthgar");
				Trthgar.SetPosition( 29056, 7552, -2316 );
				Trthgar.SetRotationTurn( -26414 );
				// Trothgar.WalkTo( x, y );

				Door = Level.GetEntity("shpdoor");
				Door.SetPassable( true );

				GetPlayer().SetQuestSolved(0,true);
			}
		}
	}]

	DelayReached[(id)
	{
		if(id = 1)
		{
			if (Level.IsMultiplayer() = true)
			{
				if ( (not IsMultiplayerClient()) and (GetPlayer().IsMenuActive() = false))
				{
					Level.Log("host show ratmenu");
					GetPlayer().OpenMenu("rathurrah");
				}
				else
				{
					if (IsMultiplayerClient() = true)
					{
						Level.Log("Client show ratmenu");
						GetPlayer().OpenMenu("rathurrah");
					}				
				}
			}
			else
			{
				Level.Log("SP show ratmenu");
				GetPlayer().OpenMenu("rathurrah");
			}
		}
	}]
}