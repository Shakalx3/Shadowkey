{
	Init[ (s)
	{
		SetName(750);
		SetExpWorth(100);
		SetLevel(8);
		SetAggressive(false);
		SetAttack(7);
		SetDefense(5);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(1);
		SetDamageMax(9);
		SetArmorValue(2);
		SetWimpy(0);
		SetChaseRadius(18000);
		SetAttackNoise(3);
		SetDeathNoise(0);
		SetIsHitNoise(38);
		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(8);
		PlayAnimationOffset(8);
		SetSkin(1);
		SetUseText(2043);
		SetUsable(true);

		SetMob(1, 2);

	} ]

	OnUse[ (s)
	{
		GetPlayer().OpenMenu("delfhide\\\\Chef_convo");
	} ]
	OnHit[ ()
	{

		AM = GetPlayer().FindInventory("cellkey");
		if( AM != null )
		{
			SetAttachedWeapon( 222 );
			SetUsable(false);
			return;
		}
		else
		{
			SetAttachedWeapon( 222 );
			SetUsable(false);
			SetLoot( 300, "delfhide\\\\Loot_DropedKey" );
		}
	}]

}
