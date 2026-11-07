{
	Init[ (s)
	{	
		//SetModel(202);
		//SetSkin(0);
		SetAggressive(true);
		SetName("Assault Rat");
		SetID("arat");
		SetExpWorth(40);
		SetAttack(3);
		SetDefense(4);
		SetSpellcast(0);
		SetMagicResistance(0);
		SetDamageMin(2);
		SetDamageMax(8);
		SetArmorValue(1);
		SetMaxHealth(2);
		SetWimpy(0);
		SetChaseRadius(18000);
		SetAttackNoise(0); 	// Ratfury
		SetDeathNoise(1);	// Ratdies
		SetWalkAnimation(1);
                SetSwingAnimation(2);
                SetDeathAnimation(3);
                SetIdleAnimation(0);
		PlayAnimation(0);
	
		AiDetect();			
			

	}]



	OnKilled [ (s)
	{ 
		if ( Random(1,12)=12)
		{
			Loot = Level.CreateEntityScript( 300, "Loot_ratseye", GetPositionX(), GetPositionY(), GetPositionZ() );
			Loot.SetDestroy( true );

			return;
		}
	}]
				
			




















}