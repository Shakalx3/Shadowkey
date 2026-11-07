{
	Init[ (s)
	{
		SetName(3287);
		SetExpWorth(0);
		SetLevel(6);
		SetSkin(1);
		SetAggressive(false);
		SetWalkAnimation(5);
		SetSwingAnimation(3);
		SetDeathAnimation(6);
		SetIdleAnimation(7);
		SetAttack(1);
		SetDefense(1);
		SetSpellcast(0);
		SetMagicResistance(1);
		SetDamageMin(4);
		SetDamageMax(24);
		SetArmorValue(1);
		SetMaxHealth(30);
		SetWimpy(5);
		SetChaseRadius(10000);

		SetAttackNoise(3);
		SetDeathNoise(0);
		SetIsHitNoise(38);

		PlayAnimationOffset(7);
		SetUsable(true);
		SetInvulnerable(true);
		SetUseText(3116);
		SetLoot(300, "Loot_Gold25-35Healing", 1, 4 );
		SetAttachedWeapon(222);
		SetMob(1);
	} ]

	OnUse[()
		{
			GetPlayer().OpenMenu("Raiders\\\\DrunkRaider_convo");
			SetUsable(false);
		}]

}
