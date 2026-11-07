{	
	talked01[0]

	Init[ (s)
	{	
		//SetModel(202);
		SetUseText(816);
		SetSkin(6);
		SetName(399);
		SetID("minyn02");
		SetExpWorth(120);
		SetAttack(5);
		SetDefense(5);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(2);
		SetDamageMax(8);
		SetArmorValue(2);
		SetMaxHealth(30);
		SetWimpy(5);
		SetChaseRadius(28000);
		SetAttackNoise(5); 	// Ratfury
		SetDeathNoise(6);	// Ratdies
		SetWalkAnimation(5);
                SetSwingAnimation(1);
                SetDeathAnimation(6);
                SetIdleAnimation(8);
		PlayAnimation(8);

		// Try to detect the player, but do not attack.
		// Instead, if a non-aggressive NPC detects the player, 
		// OnDetect will be called!	
		SetAggressive(false);
		AiDetect();

	} ]

	OnUse[ (s)
	{
		//OpenMenu("Acolyte Menlin");
		OpenMenu("Talker");
	} ]

	OnKilled [ (s)
	{ 
		//GetPlayer().StatModXP(68);
		if ( Random(1,12)=12)
		{
			//Ratseye = CreateItem("Gold");
			//DropItem( Gold );
			return;
		}
		else
		{	
			return;
		}
			
		
	}]
							

	OnDetect[ (s)
	{
		// The player must be within my chase radius. 
		// Talk to him, then kill him.
		return;
		
		
	} ]

	
		
	






}