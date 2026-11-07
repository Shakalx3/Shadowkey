{
	Init[ (s)
	{
		//SetModel(202);
		SetSkin(4);
		SetAggressive(false);
		SetName(459);
		SetID("makor");
		SetExpWorth(280);
		SetAttack(3);
		SetDefense(10);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(3);
		SetDamageMax(10);
		SetArmorValue(1);
		SetMaxHealth(44);
		SetWimpy(0);
		SetChaseRadius(18000);
		SetAttackNoise(3);
		SetDeathNoise(0);
		SetIsHitNoise(38);
		SetWalkAnimation(5);
                SetSwingAnimation(1);
                SetDeathAnimation(6);
                SetIdleAnimation(8);
		PlayAnimation(8);

		SetAttachedWeapon(224);

		AiDetect();

		SetUseText(459);
		SetUsable(true);
	}]



	OnKilled [ (s)
	{
		//Loot = Level.CreateEntityScript( 300, "Loot_Gold", GetPositionX(), GetPositionY(), GetPositionZ() );
		//Loot.SetDestroy(true);
		return;
	} ]

	OnUse[ (s)
	{
		OpenMenu("delfhide\\\\Makor_Convo");
	} ]
}