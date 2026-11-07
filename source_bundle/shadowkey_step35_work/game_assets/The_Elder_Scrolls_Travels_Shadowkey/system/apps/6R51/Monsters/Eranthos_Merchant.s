{
	Init[ (s)
	{
		SetUseText(3285);
		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(7);
		PlayAnimationOffset(7);
		SetInvulnerable( true );

		// Learning Scrolls
		ClearProducts();
		AddProduct(4009, "Absorb", 2900, 2, IPT_Spell);
		AddProduct(50, "Blaze", 320, 2, IPT_Spell);
		AddProduct(4010, "Blind",1600, 2, IPT_Spell);
		//AddProduct(4012, "Blood Spirit", 2680, 2, IPT_Spell);
		AddProduct(4013, "Body To Mind", 800, 2, IPT_Spell);
		AddProduct(4002, "Dead To Dust", 1100, 2, IPT_Spell);
		AddProduct(4017, "Doom  Hammer", 5200, 2, IPT_Spell);
		AddProduct(4019, "Energize", 250, 2, IPT_Spell);
		AddProduct(4020, "Fear", 1600, 2, IPT_Spell);
		AddProduct(4021, "Feeble Blade", 1890, 2, IPT_Spell);
		AddProduct(4022, "Frenzy", 2340, 2, IPT_Spell);
		AddProduct(4023, "Harm Armor", 1100, 1, IPT_Spell);
		AddProduct(51, "Heal Wound", 450, 2, IPT_Spell);
		AddProduct(4025, "Paralyze", 2300, 2, IPT_Spell);
		AddProduct(4011, "Raise Strength", 1100, 2, IPT_Spell);
		AddProduct(4026, "Remove Enchantment", 1600, 2, IPT_Spell);
		AddProduct(4027, "Righteousness", 4200, 1, IPT_Spell);
		AddProduct(4028, "Sanctutary", 710, 1, IPT_Spell);
		AddProduct(4029, "Shield", 1300, 1, IPT_Spell);
		AddProduct(4008, "Weakness", 1340,1, IPT_Spell);

		// Use Scrolls Temp
		//AddProduct(609, "Heal Wound10 [Temp]!!!", 280, 5, IPT_Spell);
		//AddProduct(670, "Frenzy [Temp]!!!", 412, 7, IPT_Spell);
		//AddProduct(610, "Healwound15 [Temp]!!!", 808, 5, IPT_Spell);

	} ]

	OnUse[ (s)
	{
		GetPlayer().SetMerchant(self);
		OpenMenu("dstar_w\\\\Eranthos_convo");
	} ]
}
