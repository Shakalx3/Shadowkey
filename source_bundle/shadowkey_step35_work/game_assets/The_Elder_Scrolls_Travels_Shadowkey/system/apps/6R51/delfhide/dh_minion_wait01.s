{
	talked01[0]

	Init[ (s)
	{

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
		SetAttackNoise(5);
		SetDeathNoise(6);
		SetWalkAnimation(5);
                SetSwingAnimation(1);
                SetDeathAnimation(6);
                SetIdleAnimation(8);
		PlayAnimationOffset(8);

		SetAggressive(false);
		AiDetect();

	} ]

	OnUse[ (s)
	{
		OpenMenu("Talker");
	} ]

	OnKilled [ (s)
	{

		if ( Random(1,12)=12)
		{

			return;
		}
		else
		{
			return;
		}


	}]

}