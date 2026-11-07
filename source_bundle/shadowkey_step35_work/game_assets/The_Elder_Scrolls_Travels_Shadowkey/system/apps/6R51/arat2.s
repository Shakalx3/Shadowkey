{
	Init[ (s)
	{
		//SetModel(202);
		//SetSkin(0);
		SetAggressive(true);
		SetName(201);
		SetID("arat");
		SetAttack(3);
		SetDefense(0);
		SetSpellcast(0);
		SetMagicResistance(0);
		SetDamageMin(2);
		SetDamageMax(6);
		SetArmorValue(0);
		SetMaxHealth(2);
		SetWimpy(0);
		SetChaseRadius(1);

		SetAttackNoise(15);
		SetDeathNoise(16);
		SetIsHitNoise(17);

		SetWalkAnimation(1);
                SetSwingAnimation(2);
                SetDeathAnimation(3);
                SetIdleAnimation(0);
		PlayAnimation(0);

		AiDetect();
		SetMob(1);


	}]



	OnKilled [ (s)
	{
		//GetPlayer().StatModXP(40);
		if ( Random(1,12)=12)
		{
			//Ratseye = CreateItem("Ratseye");
			//DropItem( Ratseye );
			return;
		}
		else
		{
			if ( GetPlayer().QuestSolved(0))
			{
				return;
			}
			else
			{
				GetPlayer().AddMonsterKilled (203);
				if (GetPlayer().MonstersKilled(203) >= 15 )
				{
					//Need announcement of success
					if (not GetPlayer().QuestSolved(0))
					{
						GetPlayer().OpenMenu("rathurrah");
					}

					Trthgar = Level.GetEntity("trthgar");
					Trthgar.SetPosition( 29163, 7968, -4000 );
					// Trothgar.WalkTo( x, y );

					Door = Level.GetEntity("shpdoor");
					Door.SetPassable( true );

					GetPlayer().SetQuestSolved(0,true);
				}
			}
		}
	}]






















}