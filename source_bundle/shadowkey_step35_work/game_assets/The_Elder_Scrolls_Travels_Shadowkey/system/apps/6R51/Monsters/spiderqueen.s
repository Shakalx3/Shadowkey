{
	Init[ (s)
	{	
		//SetModel(202);
		SetSkin(0);
		SetAggressive(true);
		SetName(2050);
		SetID("spiderqueen");
		SetExpWorth(360);
		SetAttack(7);
		SetDefense(4);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(4);
		SetDamageMax(12);
		//SetSpecial (Blind)?
		SetArmorValue(2);
		SetMaxHealth(70);
		SetWimpy(5);
		SetChaseRadius(18000);
		SetAttackNoise(3); 	// Ratfury
		SetDeathNoise(3);	// Ratdies
		SetWalkAnimation(1);
                SetSwingAnimation(2);
                SetDeathAnimation(3);
                SetIdleAnimation(0);
		PlayAnimationOffset(0);
		SetSpider(true);
	
		AiDetect();	

	}]



	OnKilled [ (s)
	{ 
		//GetPlayer().StatModXP(360);
		if ( Random(1,12)=12)
		{
			//Ratseye = CreateItem("Gold");
			//DropItem( Gold );
			Loot = Level.CreateEntityScript( 300, "Loot_ShadowKey", GetPositionX(), GetPositionY(), GetPositionZ() );
			Loot.SetDestroy(true);
			return;
		}
		else
		{	
			return;
		}
			
		
	}]
				
			




















}