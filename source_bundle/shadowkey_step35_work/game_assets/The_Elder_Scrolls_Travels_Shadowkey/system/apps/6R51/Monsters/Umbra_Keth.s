{
	AlreadyDelaying [0]
	saved_PlayerWarning[0]

	Init[ (s)
	{
		SetName(2145);
		SetSkin(0);
		SetID("Umbra");
		SetExpWorth(4000);
		SetLevel(25);
		SetAggressive(true);

		SetAttack(200);
		SetDefense(200);
		SetSpellcast(0);
		SetMagicResistance(150);
		SetDamageMin(70);
		SetDamageMax(90);
		SetArmorValue(35);
		SetMaxHealth(600);

		SetWimpy(0);
		SetChaseRadius(50000);
		SetAttackNoise(12);
		SetDeathNoise(31);
		SetIsHitNoise(14);
		SetWalkAnimation(1);
		SetSwingAnimation(2);
		SetDeathAnimation(3);
		SetIdleAnimation(0);
		PlayAnimationOffset(0);
		SetBoss(true);
		//AiDetect();

		//Item = Level.CreateEntity( 4017 ); //doom hammer
		//Item.SetLevel(10);
		//AddSpell( Item, 75 );
		//Item = Level.CreateEntity( 4025 ); //paralyze
		//Item.SetLevel(10);
		//AddSpell( Item, 100 );
                //
		//SetMeleeRoll(80);
	} ]

	//OnDetect[(s)
	//{
	//	GetPlayer().OpenMenu("crypt2\\\\LureUmbra");
	//	//Delay (4, 4);
	//	AiSleep();
	//}]

	OnDecay[()
	{
		//Delay (4, 0);
		GetPlayer().saved_EndGame = 1;
		Level.LightRect(16, 29, 20, 33, 64);
		PlaySound(83);
	}]

	GetDelay[()
	{
		Delay (12, 3);
	}]

	Scale[()
	{
		SetScale(512);
	}]
	
	ClientFightUmbra[ ()
	{
		Level.Log("Umbra_Keth ClientFightUmbra()");
		Scale();
		Level.saved_Umbra = 1;
		Level.saved_Keth = 1;
		Level.saved_DeathMatch = 1;		
		GetPlayer().AddEffect(Permanent, Defense, Increment, 0, 7);
		GetPlayer().AddEffect(Permanent, ArmorValue, Increment, 0, 7);		
	}]

	OnHit[()
	{
		if(Level.saved_Umbra = 0)
		{
			if(GetHealth() < 375)
			{
				if( not AlreadyDelaying )
				{
					Level.Log("I am killing myself and setting a delay");

					ShowEntity( false );
					SetPassable( true );
					SetDead( true );

					GetPlayer().OpenMenu("cryptsh3\\\\umbra_disappear");
					Delay (Random(8, 12), 1);
					AlreadyDelaying = 1;
					SetCanTeleport(false);
					ReplicateTeleport(false); //network replication
				}
			}
		}
		else
		{
			return;
		}
	}]

	DelayReached[(id)
	{
		//Level.Log("Reached");
		//if(id = 0)
		//{
		//	GetPlayer().OpenMenu("cryptsh3\\\\umbra_defeat_menu");
		//}

		if(id = 1)
		{
			if( (GetPlayer().saved_GoAway = 0) and (FindPathNode("UmbraKeth") = true) )
			{
					Level.Log("My delay has been reached");
					AlreadyDelaying = 0;
					ShowEntity( true );
					SetPassable( false );
					SetDead( false );
					SetMaxHealth( 225 );
					SetHealth( 225 );
					SetCanTeleport(true);
					ReplicateTeleport(true); //network replication
					//SetPosition(GetPlayer().GetPositionX() + 75, GetPlayer().GetPositionY() + 75, GetPlayer().GetPositionZ());
			}
			else
			{
				Delay (Random(2, 5), 1);
				SetCanTeleport(false);
				return;
			}
		}

		if(id = 3)
		{
			GetPlayer().saved_GoAway = 0;
		}

		//if(id = 4)
		//{
		//	if(saved_PlayerWarning = 0)
		//	{
		//		GetPlayer().OpenMenu("crypt2\\\\LureUmbra");
		//		saved_PlayerWarning = 1;
		//	}
		//	else
		//	{
		//		return;
		//	}
		//}
	}]

	//BringMeBack[()
	//{
	//	Level.Log("My delay has been reached");
	//	AlreadyDelaying = 0;
	//	ShowEntity( true );
	//	SetPassable( false );
	//	SetDead( false );
	//	SetMaxHealth( 225 );
	//	SetHealth( 225 );
	//	SetPosition(GetPlayer().GetPositionX() + 75, GetPlayer().GetPositionY() + 75, GetPlayer().GetPositionZ());
	//}]
}
