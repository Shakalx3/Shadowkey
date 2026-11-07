{
	Init[ (s)
	{
		//SetModel(202);
		SetSkin(0);
		SetAggressive(true);
		SetName(2042);
		SetID("spider");
		SetExpWorth(120);
		SetAttack(4);
		SetDefense(4);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(3);
		SetDamageMax(10);
		//SetSpecial (Weakness)?
		SetArmorValue(1);
		SetMaxHealth(44);
		SetWimpy(0);
		SetChaseRadius(18000);
		SetAttackNoise(3); 	// Ratfury
		SetDeathNoise(3);	// Ratdies
		SetWalkAnimation(1);
                SetSwingAnimation(2);
                SetDeathAnimation(3);
                SetIdleAnimation(0);
		PlayAnimationOffset(0);
		AiDetect();
		SetLoot( 300, "Loot_spiderheart", 1, 10 );
		SetSpider(true);

		SetMob(3);
	}]

}