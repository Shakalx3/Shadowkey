{
	Init[ (s)
	{
		SetUseText(1143);
		SetExpWorth(0);
		SetLevel(0);
		SetAggressive(false);
		SetAttack(0);
		SetDefense(0);
		SetSpellcast(0);
		SetMagicResistance(0);
		SetDamageMin(0);
		SetDamageMax(0);
		SetArmorValue(0);
		SetMaxHealth(0);
		SetWimpy(0);
		SetChaseRadius(18000);

		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(7);
		PlayAnimationOffset(7);

		SetInvulnerable( true );

		ClearProducts();
		AddProduct(4703, "Blueglacier Flower", 830, 6, IPT_Consumable);
		AddProduct(4704, "Blueglacier Moss", 550, 6, IPT_Consumable);
		AddProduct(700, "Bread", 4, 127, IPT_Consumable);
		AddProduct(4705, "Cure Blindness Balm", 140, 4, IPT_Consumable);
		AddProduct(4706, "Deathsnow Dust", 310, 2, IPT_Consumable);
		AddProduct(4708, "Fox Herb", 900, 3, IPT_Consumable);
		AddProduct(4710, "Ghostflame", 85, 7, IPT_Consumable);
		AddProduct(702, "Heal", 18, 127, IPT_Consumable);
		AddProduct(4736, "Horrid Tongue", 890, 2, IPT_Consumable);
		AddProduct(4714, "Ice Grape", 535, 5, IPT_Consumable);
		AddProduct(4717, "Jade Dust", 620, 5, IPT_Consumable);
		AddProduct(703, "Magicka", 20, 127, IPT_Consumable);
		AddProduct(4734, "Mana Ice", 170, 4, IPT_Consumable);
		AddProduct(4720, "Mountain Jerky", 220, 9, IPT_Consumable);
		AddProduct(701, "Muffin", 2, 127, IPT_Consumable);
		AddProduct(712, "Ra' Gada Warpaint", 190, 8, IPT_Consumable);
		AddProduct(704, "Ratseye", 725, 5, IPT_Consumable);
		AddProduct(4726, "Skyrim Restorative", 400, 4, IPT_Consumable);
		AddProduct(4727, "Smile Potion", 180, 1, IPT_Consumable);
		AddProduct(4728, "Snowray Powder", 4700, 12, IPT_Consumable);
		AddProduct(705, "Spiderheart", 860, 5, IPT_Consumable);
		AddProduct(4730, "Sunlight Water", 380, 6, IPT_Consumable);
		AddProduct(4729, "Thunder Herb", 310, 12, IPT_Consumable);
		AddProduct(709, "Toad Muffin", 20, 127, IPT_Consumable);
		AddProduct(4711, "Tremble Weed", 188, 6, IPT_Consumable);
		AddProduct(4719, "Vicar Herb", 45, 9, IPT_Consumable);
		AddProduct(710, "Warrior Bread", 25, 127, IPT_Consumable);
		AddProduct(4721, "Warrior's Strength", 220, 5, IPT_Consumable);
	} ]

	OnUse[ (s)
	{
		GetPlayer().SetMerchant(self);
		OpenMenu("dstar_w\\\\consume_convo");
	} ]
}
