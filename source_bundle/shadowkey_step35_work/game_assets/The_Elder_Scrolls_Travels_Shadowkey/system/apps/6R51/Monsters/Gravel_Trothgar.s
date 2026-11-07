{
	Init[ (s)
	{
		SetUseText(2063);
		SetExpWorth(0);
		SetLevel(0);
		SetSkin(0);

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
		SetAttackNoise(3);
		SetDeathNoise(4);
		SetIsHitNoise(5);
		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(7);
		PlayAnimationOffset(7);

		SetInvulnerable( true );

		ClearProducts();
		AddProduct(500, "Bludgeon", 55, 5, IPT_Weapon);
		AddProduct(501, "Club", 15, 6, IPT_Weapon);
		AddProduct(507, "Glass TK", 30, 1, IPT_Weapon);
		AddProduct(504, "Iron BS", 303, 10, IPT_Weapon);
		AddProduct(502, "Iron Club", 38, 9, IPT_Weapon);
		AddProduct(510, "Iron Dag", 38, 3, IPT_Weapon);
		AddProduct(506, "Iron LS", 953, 16, IPT_Weapon);
		AddProduct(512, "Iron SS", 143, 8, IPT_Weapon);
		AddProduct(508, "Iron TK", 9, 1, IPT_Weapon);
		AddProduct(503, "Iron WH", 2578, 32, IPT_Weapon);
		AddProduct(505, "Steel BS", 463, 9, IPT_Weapon);
		AddProduct(511, "Steel Dag", 78, 3, IPT_Weapon);
		AddProduct(509, "Steel TK", 17, 1, IPT_Weapon);

		AddProduct(603, "Bone S.", 100, 6, IPT_Armor);
		AddProduct(614, "Chain C.", 1012, 3, IPT_Armor);
		AddProduct(600, "Cloth Br.", 2, 1, IPT_Armor);
		AddProduct(604, "Cuirbolli C.R.", 69, 12, IPT_Armor);
		AddProduct(601, "Iron Br.", 400, 6, IPT_Armor);
		AddProduct(605, "Iron C.R.", 1600, 5, IPT_Armor);
		AddProduct(608, "Leather B.", 90, 6, IPT_Armor);
		AddProduct(602, "Leather Br.",11, 6, IPT_Armor);
		AddProduct(611, "Leather Cap", 12, 2, IPT_Armor);
		AddProduct(615, "Leather G.", 17, 7, IPT_Armor);
		AddProduct(606, "Leather S", 44, 5, IPT_Armor);
		AddProduct(609, "Nordic F.B.", 202, 7, IPT_Armor);
		AddProduct(612, "Nordic F.C.", 28, 2, IPT_Armor);
		AddProduct(616, "Nordic F.G.", 40, 5, IPT_Armor);
		AddProduct(613, "Ra'Gada L.H.", 112, 2, IPT_Armor);
		AddProduct(607, "Reinforced L.", 11, 5, IPT_Armor);
		AddProduct(610, "Steel Boots", 1000, 18, IPT_Armor);

		AddProduct(700, "Bread", 4, 8, IPT_Consumable);
		AddProduct(702, "Healing", 18, 20, IPT_Consumable);
		AddProduct(703, "Magicka", 20, 20, IPT_Consumable);
		AddProduct(701, "Muffin", 2, 12, IPT_Consumable);
	} ]

	OnUse[ (s)
	{
		GetPlayer().SetMerchant(self);
		OpenMenu("trothgarconvo");
	} ]
}
