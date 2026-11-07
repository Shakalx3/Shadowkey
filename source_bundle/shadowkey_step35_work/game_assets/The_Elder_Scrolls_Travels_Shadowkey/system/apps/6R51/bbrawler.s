{
	Init[ (s)
	{
		//SetModel(202);
		SetSkin(6);
		SetAggressive(true);
		SetName(399);
		SetID("bbrawler");
		SetAttack(5);
		SetDefense(3);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(2);
		SetDamageMax(6);
		SetArmorValue(2);
		SetMaxHealth(30);
		SetWimpy(5);
		SetChaseRadius(18000);
		SetAttackNoise(3);
		SetDeathNoise(0);
		SetIsHitNoise(38);
		SetWalkAnimation(5);
                SetSwingAnimation(1);
                SetDeathAnimation(6);
                SetIdleAnimation(8);
		PlayAnimation(8);
		SetLoot(300, "Loot_Gold6-10", 1, 2 );

		AiDetect();

	}]



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






















}