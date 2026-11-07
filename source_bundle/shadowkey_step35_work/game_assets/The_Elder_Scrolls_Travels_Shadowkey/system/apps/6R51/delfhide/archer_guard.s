{
	Init[ (s)
	{
		//SetModel(202);
		SetUseText(720);
		SetSkin(0);
		SetName(720);
		SetID("guard");
		SetExpWorth(150);
		SetAttack(5);
		SetDefense(5);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(2);
		SetDamageMax(8);
		SetArmorValue(2);
		SetMaxHealth(30);
		SetWimpy(5);
		SetChaseRadius(7000);

		SetAttackNoise(1);
		SetDeathNoise(0);
		SetIsHitNoise(38);

		SetWalkAnimation(5);
                SetSwingAnimation(2);
                SetDeathAnimation(6);
                SetIdleAnimation(8);
		PlayAnimation(8);
		SetAttachedWeapon(225);
		SetAggressive(false);
		SetLoot(300, "Loot_DoubleBow", 1, 6 );
		SetMob(4);
		AiSleep();

	} ]

	OnUse[ (s)
	{
		OpenMenu("delfhide\\\\DH_Menu7");
	} ]


	OnDetect[ (s)
	{

		OpenMenu("delfhide\\\\DH_Menu7");
		AiSleep();
	} ]

}