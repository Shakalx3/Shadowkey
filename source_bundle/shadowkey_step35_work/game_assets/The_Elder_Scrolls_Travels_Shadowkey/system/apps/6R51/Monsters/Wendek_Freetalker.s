{
	Init[ (s)
	{
		SetName(2149);
		SetSkin(5);
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

		SetWalkAnimation(0);
		SetSwingAnimation(0);
		SetDeathAnimation(0);
		SetIdleAnimation(0);
		PlayAnimationOffset(0);

		SetInvulnerable( true );
		SetUsable(true);
		SetUseText(2149);

		ClearProducts();
		AddProduct(533, "Dwaven Battle Axe", 6199, 2, IPT_Weapon);
		AddProduct(531, "Dwarven Shortsword", 806, 4, IPT_Weapon);
		AddProduct(538, "Ebony Shortsword", 3675, 2, IPT_Weapon);
		AddProduct(541, "Iron Battle Axe", 4572, 2, IPT_Weapon);
		AddProduct(542, "Iron Claymore", 1511, 2, IPT_Weapon);
		AddProduct(510, "Iron Dagger", 38, 4, IPT_Weapon);
		AddProduct(506, "Iron Longsword", 953, 2, IPT_Weapon);
		AddProduct(512, "Iron Shortsword", 143, 2, IPT_Weapon);
		AddProduct(503, "Iron Warhammer", 2578, 2, IPT_Weapon);
		AddProduct(549, "Ra'Gada Warhammer", 8207, 2, IPT_Weapon);
		AddProduct(557, "Silver Dagger", 55, 4, IPT_Weapon);
		AddProduct(560, "Silver Shortsword", 240, 2, IPT_Weapon);
		AddProduct(564, "Steel Club", 78, 2, IPT_Weapon);
		AddProduct(515, "Steel Crossbow", 16415, 2, IPT_Weapon);
		AddProduct(567, "Steel Longsword", 1304, 2, IPT_Weapon);
		AddProduct(568, "Steel Mace", 568, 2, IPT_Weapon);
		AddProduct(570, "Steel Staff", 55, 2, IPT_Weapon);

		AddProduct(603, "Bone S.", 100, 6, IPT_Armor);
		AddProduct(600, "Cloth Br.", 2, 2, IPT_Armor);
		AddProduct(604, "Cuirbolli C.R.", 69, 12, IPT_Armor);
		AddProduct(627, "Dragonscale Coif", 1378, 2, IPT_Armor);
		AddProduct(631, "Dwarven Boots", 1000, 2, IPT_Armor);
		AddProduct(640, "Imperial Newtscalse Cuirass", 336, 2, IPT_Armor);
		AddProduct(641, "Imperial Silver Cuirass", 434, 2, IPT_Armor);
		AddProduct(601, "Iron Br.", 400, 6, IPT_Armor);
		AddProduct(605, "Iron C.R.", 1600, 5, IPT_Armor);
		AddProduct(643, "Iron G.", 1260, 2, IPT_Armor);
		AddProduct(644, "Iron Greaves", 1604, 2, IPT_Armor);
		AddProduct(646, "Iron shield", 197, 2, IPT_Armor);
		AddProduct(602, "Leather Br.",11, 6, IPT_Armor);
		AddProduct(611, "Leather Cap", 12, 2, IPT_Armor);
		AddProduct(615, "Leather G.", 15, 2, IPT_Armor);
		AddProduct(648, "Leather G.", 15, 2, IPT_Armor);
		AddProduct(606, "Leather S", 44, 5, IPT_Armor);
		AddProduct(616, "Nordic F.G.", 40, 2, IPT_Armor);
		AddProduct(658, "Ra'Gada G.S.", 225, 2, IPT_Armor);
		AddProduct(613, "Ra'Gada L.H.", 112, 2, IPT_Armor);
		AddProduct(607, "Reinforced Linen", 10, 2, IPT_Armor);
		AddProduct(661, "Ringmail", 156, 2, IPT_Armor);
		AddProduct(674, "Steel Cuirass", 434, 2, IPT_Armor);
		AddProduct(675, "Steel G.", 1555, 2, IPT_Armor);
		AddProduct(678, "Steel Pauldron", 1111, 2, IPT_Armor);
		AddProduct(680, "Studded L.G.", 62, 2, IPT_Armor);

		///////AddProduct(4905, "Heal Wound 10", 280, 2, IPT_Spell);
		///////AddProduct(4904, "Frenzy 10", 412, 2, IPT_Spell);
		///////AddProduct(4902, "Blaze 5", 144, 3, IPT_Spell);
		///////AddProduct(4903, "Doomhammer 10", 1145, 2, IPT_Spell);

		AddProduct(700, "Bread", 4, 8, IPT_Consumable);
		AddProduct(4710, "Ghostflame", 85, 2, IPT_Consumable);
		AddProduct(702, "Healing", 18, 20, IPT_Consumable);
		AddProduct(703, "Magicka", 20, 20, IPT_Consumable);
		AddProduct(4720, "Mountain Jerky", 220, 3, IPT_Consumable);
		AddProduct(701, "Muffin", 2, 12, IPT_Consumable);
		AddProduct(704, "Rat I", 725, 2, IPT_Consumable);
		AddProduct(704, "Ratseye", 725, 2, IPT_Consumable);
		AddProduct(4727, "Smile Potion", 180, 1, IPT_Consumable);
		AddProduct(705, "Spider Heart", 860, 2, IPT_Consumable);
		AddProduct(709, "Toad Muffin", 20, 8, IPT_Consumable);
		AddProduct(710, "Warrior Bread", 25, 8, IPT_Consumable);
		AddProduct(4722, "Zombie Dust", 170, 2, IPT_Consumable);
	} ]

	OnUse[ (s)
	{
		GetPlayer().SetMerchant(self);
		if(GetPlayer().QuestCompleted(17) = true)
		{
			ReducePrices(20);
		}

		OpenMenu("snowline\\\\wendekconvo");
	} ]
}
