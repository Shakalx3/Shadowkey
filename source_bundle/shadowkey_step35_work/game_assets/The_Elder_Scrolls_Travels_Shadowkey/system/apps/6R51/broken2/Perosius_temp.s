{
	saved_aggro[0]

	Init[()
	{
		SetName(507);
		SetExpWorth(2100);
		SetLevel(22);

		SetAttack(80);
		SetDefense(125);
		SetSpellcast(0);
		SetMagicResistance(80);
		SetDamageMin(40);
		SetDamageMax(45);
		SetArmorValue(1);
		SetMaxHealth(275);
		SetWimpy(5);
		SetChaseRadius(30000);
		SetAttackNoise(3);
		SetDeathNoise(0);
		SetIsHitNoise(38);
		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(8);
		PlayAnimationOffset(0);
		SetSkin(3);
		SetLoot( 300, "broken2\\\\loot_key" );
		AiDetect();

		if (saved_aggro = 0)
		{
			SetAggressive(false);
			SetInvulnerable(true);
			SetUsable(true);
			SetUseText(3080);
		}

		//Item = Level.CreateEntity( 4035 );
		//Item.SetLevel(5);
		//AddSpell( Item );
		//SetMeleeRoll(85);
		SetBoss(true);

	}]

	OnDetect[()
	{
		saved_aggro=1;
		GetPlayer().OpenMenu("broken2\\\\perosius_temp_convo");
		SetAggressive(true);
		SetUsable(false);
		SetInvulnerable(false);
		AiAttack();
	}]
}
