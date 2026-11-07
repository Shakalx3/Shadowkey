{
	Init[()
	{
		SetUseText(746);
		SetUsable(true);
		SetName(2118);
		SetExpWorth(320);
		SetLevel(7);
		SetSkin(1);
		SetAggressive(false);
		SetAttack(5);
		SetDefense(4);
		SetSpellcast(0);
		SetMagicResistance(6);
		SetDamageMin(3);
		SetDamageMax(16);
		SetArmorValue(2);
		SetMaxHealth(45);
		SetWimpy(5);
		SetChaseRadius(18000);
		SetAttackNoise(3);
		SetDeathNoise(0);
		SetIsHitNoise(38);
		SetWalkAnimation(1);
		SetSwingAnimation(2);
		SetDeathAnimation(3);
		SetIdleAnimation(0);
		PlayAnimationOffset(0);
		SetMob(1);
	}]
	OnUse[()
	{
		OpenMenu("fearfrst\\\\Sergeant_Convo2");
	}]

	OnHit[ ()
	{
		SetAggressive(true);
		SetUsable(false);
		AM = GetPlayer().FindInventory("siswill");
		if( AM != null )
		{
			SetLoot( 300, "Raiders\\\\Loot_Gold_125_185" );
		}
		else
		{
			SetLoot( 300, "fearfrst\\\\Loot_Sisithik" );
		}
	}]
}