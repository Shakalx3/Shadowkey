{
	Init[ (s)
	{	
		//SetModel(202);
		//SetSkin(0);
		SetAggressive(true);
		SetName("Assault Rat");
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
		return;
	}]
				
			




















}