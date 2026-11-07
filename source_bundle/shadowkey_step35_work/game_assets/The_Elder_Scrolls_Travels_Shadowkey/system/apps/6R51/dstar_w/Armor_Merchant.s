{
	Init[ (s)
	{
		SetUseText(1128);
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
		AddProduct(600, "Cloth Bracer", 2, 10, IPT_Armor);

		AddProduct(633, "Ebony Bracer", 3402, 10, IPT_Armor);

		AddProduct(603, "Bone Shirt", 100, 1, IPT_Armor);
		AddProduct(604, "Cuirbolli Cuirass", 69, 1, IPT_Armor);
		AddProduct(614, "Chain Coif", 1012, 1, IPT_Armor);
		AddProduct(621, "Chain Greaves", 1440, 1, IPT_Armor);
		AddProduct(624, "Daedric Gauntlet", 7875, 1, IPT_Armor);
		AddProduct(627, "Dragonscale Coif", 1378, 1, IPT_Armor);
		AddProduct(628, "Dragonstar Scale", 11377, 1, IPT_Armor);
		AddProduct(629, "Dragonstar Shield", 2500, 1, IPT_Armor);
		AddProduct(630, "Dragonstar Watch Helm", 1512, 1, IPT_Armor);
		AddProduct(631, "Dwarven Boots", 1000, 1, IPT_Armor);
		AddProduct(632, "Dwemer Helm", 1953, 1, IPT_Armor);
		AddProduct(639, "Glass Boots", 360, 1, IPT_Armor);
		AddProduct(648, "Imperial Newtscale Cuirass", 5136, 1, IPT_Armor);
		AddProduct(641, "Imperial Silver Cuirass", 6944, 1, IPT_Armor);
		AddProduct(642, "Iron Boots", 902, 1, IPT_Armor);
		AddProduct(601, "Iron Bracer", 400, 1, IPT_Armor);
		AddProduct(605, "Iron Cuirass", 1600, 1, IPT_Armor);
		AddProduct(643, "Iron Gauntlet", 1260, 1, IPT_Armor);
		AddProduct(644, "Iron Greaves", 1604, 1, IPT_Armor);
		AddProduct(646, "Iron Shield", 564, 1, IPT_Armor);
		AddProduct(608, "Leather Boots", 90, 1, IPT_Armor);
		AddProduct(602, "Leather Bracer",11, 1, IPT_Armor);
		AddProduct(647, "Leather Buckler", 25, 1, IPT_Armor);
		AddProduct(611, "Leather Cap", 12, 1, IPT_Armor);
		AddProduct(648, "Leather Gloves", 15, 1, IPT_Armor);
		AddProduct(609, "Nordic Fur Boots", 202, 1, IPT_Armor);
		AddProduct(612, "Nordic Fur Cap", 28, 1, IPT_Armor);
		AddProduct(616, "Nordic Fur Greaves", 40, 1, IPT_Armor);
		AddProduct(650, "Nordic Iron Cuirass", 2025, 1, IPT_Armor);
		AddProduct(652, "Nordic Trollbone Cuirass", 2177, 1, IPT_Armor);
		AddProduct(658, "Ra' Gada Guard Shield", 225, 1, IPT_Armor);
		AddProduct(613, "Ra' Gada Light Helm", 112, 1, IPT_Armor);
		AddProduct(661, "Ringmail", 2500, 1, IPT_Armor);
		AddProduct(664, "Shadowplate", 54444, 1, IPT_Armor);
		AddProduct(669, "Silver Shield", 976, 1, IPT_Armor);
		AddProduct(670, "Soft Leather Boots", 22, 1, IPT_Armor);
		AddProduct(610, "Steel Boots", 1000, 1, IPT_Armor);
		AddProduct(674, "Steel Cuirass", 6944, 1, IPT_Armor);
		AddProduct(675, "Steel Gauntlet", 1555, 1, IPT_Armor);
		AddProduct(676, "Steel Greaves", 1777, 1, IPT_Armor);
		AddProduct(678, "Steel Pauldron.", 1111, 1, IPT_Armor);
		AddProduct(679, "Steel Shield", 1600, 1, IPT_Armor);
		AddProduct(680, "Studded Leather Gloves", 62, 1, IPT_Armor);
		AddProduct(684, "Trollbone Buckler", 400, 1, IPT_Armor);
		AddProduct(683, "Wooden Buckler", 126, 1, IPT_Armor);
	} ]

	OnUse[ (s)
	{
		GetPlayer().SetMerchant(self);
		OpenMenu("dstar_w\\\\armor_convo");
	} ]
}
