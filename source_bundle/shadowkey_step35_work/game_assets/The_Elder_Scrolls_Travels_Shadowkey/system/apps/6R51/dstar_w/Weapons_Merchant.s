{
	Init[ (s)
	{
		SetUseText(1236);
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
		AddProduct(525, "Daedric Mace", 953, 1, IPT_Weapon);
		AddProduct(533, "Dwarven Battle Axe", 6199, 1, IPT_Weapon);
		AddProduct(531, "Dwarven Shortsword", 806, 1, IPT_Weapon);
		AddProduct(532, "Dwarven War Axe", 1511, 1, IPT_Weapon);
		AddProduct(537, "Ebony Mace", 4106, 1, IPT_Weapon);
		AddProduct(538, "Ebony Shortsword", 3675, 1, IPT_Weapon);
		AddProduct(541, "Iron Battle Axe", 4572, 1, IPT_Weapon);
		AddProduct(504, "Iron Broadsword", 303, 1, IPT_Weapon);
	AddProduct(542, "Iron Claymore", 1511, 1, IPT_Weapon);
		AddProduct(502, "Iron Club", 38, 1, IPT_Weapon);
		AddProduct(506, "Iron Longsword", 953, 1, IPT_Weapon);
		AddProduct(503, "Iron Mace", 2578, 1, IPT_Weapon);
		AddProduct(546, "Ra' Gada Battle Axe", 3278, 1, IPT_Weapon);
		AddProduct(548, "Ra' Gada Longbow", 10150, 1, IPT_Weapon);
		AddProduct(549, "Ra' Gada Warhammer", 8207, 1, IPT_Weapon);
		AddProduct(554, "Shadow Whisper", 1304, 1, IPT_Weapon);
		AddProduct(556, "Silver Claymore", 2272, 1, IPT_Weapon);
		AddProduct(557, "Silver Dagger", 55, 1, IPT_Weapon);
		AddProduct(558, "Silver Dart", 76, 1, IPT_Weapon);
		AddProduct(559, "Silver Longsword", 1511, 1, IPT_Weapon);
		AddProduct(560, "Silver Shortsword", 240, 1, IPT_Weapon);
		AddProduct(561, "Silver Staff", 107, 1, IPT_Weapon);
		AddProduct(562, "Spire Thief Bludgeon", 5617, 1, IPT_Weapon);
		AddProduct(505, "Steel Broadsword", 463, 1, IPT_Weapon);
		AddProduct(564, "Steel Club", 78, 1, IPT_Weapon);
		AddProduct(565, "Steel Crossbow", 16415, 1, IPT_Weapon);
		AddProduct(511, "Steel Dagger", 78, 1, IPT_Weapon);
		AddProduct(572, "Steel Flail", 4106, 1, IPT_Weapon);
		AddProduct(567, "Steel Longsword", 1304, 1, IPT_Weapon);
		AddProduct(570, "Steel Mace", 55, 1, IPT_Weapon);
		AddProduct(568, "Steel Mace", 377, 1, IPT_Weapon);
		AddProduct(569, "Steel Shortsword", 377, 1, IPT_Weapon);
		AddProduct(509, "Steel Throwing Knife", 17, 1, IPT_Weapon);
		AddProduct(571, "Steel War Axe", 806, 1, IPT_Weapon);
	} ]

	OnUse[ (s)
	{
		GetPlayer().SetMerchant(self);
		OpenMenu("dstar_w\\\\weapon_convo");
	} ]
}