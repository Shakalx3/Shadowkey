{
	Init[ (s)
	{
		//SetModel(202);
		//SetSkin(0);
		SetAggressive(true);
		SetName(2030);
		SetID("arat");
		SetExpWorth(40);
		SetAttack(3);
		SetDefense(4);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(3);
		SetDamageMax(6);
		SetArmorValue(2);
		SetMaxHealth(12);
		SetWimpy(2);
		SetChaseRadius(18000);
		SetAttackNoise(15);
		SetDeathNoise(16);
		SetIsHitNoise(17);
		SetWalkAnimation(1);
                SetSwingAnimation(2);
                SetDeathAnimation(3);
                SetIdleAnimation(0);
		PlayAnimationOffset(0);

		SetScale( Random( 206, 306 ) );

		AiDetect();

		SetLoot( 300, "Loot_ratseye", 1, 8 );

		SetMob(4);

	}]



	OnKilled [ (s)
	{
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
					if( s = false )
					{
						Delay (2, 0);
					}
				}

				Trthgar = Level.GetEntity("trthgar");
				Trthgar.SetPositionMirror( 29056, 7552, -2316 );
				Trthgar.SetRotationTurn( -26414 );
				// Trothgar.WalkTo( x, y );

				//Door = Level.GetEntity("shpdoor");
				//Door.SetPassable( true );

				GetPlayer().SetQuestSolved(0,true);
			}
		}
	}]

	DelayReached[(id)
	{
		if(id = 0)
		{
			GetPlayer().OpenMenu("rathurrah");
		}
	}]
}






















}