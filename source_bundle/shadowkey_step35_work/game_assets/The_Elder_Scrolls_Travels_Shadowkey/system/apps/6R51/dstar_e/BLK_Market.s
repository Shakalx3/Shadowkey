{
	Init[ (s)
	{
		SetUseText(3114);
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
		SetAttackNoise(2);
		SetDeathNoise(3);
		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(7);
		PlayAnimationOffset(7);

		SetInvulnerable(true);

		ClearProducts();
		AddProduct(662, "Shadow Band", 4444, 3, IPT_Armor);
		AddProduct(678, "Steel Pauldron", 111, 10, IPT_Armor);
		AddProduct(635, "Ebony Cuirass" ,850, 20, IPT_Armor);
		AddProduct(665, "Shadowing", 1405, 10, IPT_Armor);
		AddProduct(671, "Spire Thief Boots", 810, 10, IPT_Armor);
		AddProduct(682, "Twilight Gloves", 657, 10, IPT_Armor);
		AddProduct(638, "Glacial Helm", 5253, 3, IPT_Armor);
		AddProduct(621, "Chain Greaves", 1440, 9, IPT_Armor);
		AddProduct(676, "Steel Greaves", 1777, 10, IPT_Armor);
		AddProduct(637, "Ebony Shield", 1914, 10, IPT_Armor);
		AddProduct(654, "Orcish Shield", 156, 6, IPT_Armor);

		AddProduct(4016, "Daedric Weapon", 420, 1, IPT_Spell);
		AddProduct(4002, "Dead To Dust", 1100, 1, IPT_Spell);
		AddProduct(4035, "Death Howl", 5300, 1, IPT_Spell);
		AddProduct(4020, "Fear", 1600, 1, IPT_Spell);
		AddProduct(4023, "Harm Armor", 1100,1, IPT_Spell);
		AddProduct(4024, "Ignite Foe", 4200, 1, IPT_Spell);

		AddProduct(4719, "Vicar Herb", 30, 10, IPT_Consumable);
		AddProduct(806, "Skeleton Key", 2500, 1, IPT_Consumable);
		AddProduct(707, "Smack Water", 225, 6, IPT_Consumable);
		AddProduct(708, "Bitter Tea", 200, 2, IPT_Consumable);
		AddProduct(711, "Vermin Bomb", 500, 9, IPT_Consumable);
		AddProduct(4700, "Ahm Galath", 2000, 2, IPT_Consumable);
		AddProduct(4701, "Azra Root", 3200, 2, IPT_Consumable);
		AddProduct(4706, "Deathsnow Dust", 310, 8, IPT_Consumable);
		AddProduct(4707, "Earth Moss", 1100, 2, IPT_Consumable);
		AddProduct(4709, "Topaz Dust", 3200, 2, IPT_Consumable);
		AddProduct(4712, "Goblin Wax", 1340, 2, IPT_Consumable);
		AddProduct(4716, "Umbric Fur", 420, 6, IPT_Consumable);
		AddProduct(4718, "Lock Dust", 175, 4, IPT_Consumable);
		AddProduct(4722, "Zombie Dust", 170, 8, IPT_Consumable);
		AddProduct(4723, "Persa Flower", 680, 8, IPT_Consumable);
		AddProduct(4724, "Shadowbane", 1100, 3, IPT_Consumable);
		AddProduct(4726, "Skyrim Potion", 400, 20, IPT_Consumable);
		AddProduct(4731, "Gray Mushroom", 468, 3, IPT_Consumable);
		AddProduct(4732, "Red Mushroom", 448, 9, IPT_Consumable);
		AddProduct(4733, "Black Mushroom", 550, 9, IPT_Consumable);
		AddProduct(4735, "Scythe Crystals", 1200, 12, IPT_Consumable);
		AddProduct(4738, "Bounder Skin", 1100, 4, IPT_Consumable);
		AddProduct(4739, "Clawrunner Skin", 6200, 2, IPT_Consumable);
		AddProduct(4740, "Raider Chew", 2470, 2, IPT_Consumable);


		AddProduct(528, "Double Battle Axe", 13575, 1, IPT_Weapon);
		AddProduct(540, "Ebony War Axe", 6823, 1, IPT_Weapon);
		AddProduct(543, "Mahk Longsword", 2578, 2, IPT_Weapon);
		AddProduct(530, "Dwarven Crossbow", 70662, 1, IPT_Weapon);
		AddProduct(516, "Bandit Double-bow", 2609, 1, IPT_Weapon);
		AddProduct(521, "Daedric Dart", 374, 1, IPT_Weapon);
		AddProduct(557, "Silver Dagger", 55, 1, IPT_Weapon);
		AddProduct(560, "Silver Shortsword", 240, 1, IPT_Weapon);
		AddProduct(569, "Steel Shortsword", 377, 1, IPT_Weapon);

	}]

	OnUse[ (s)
	{
		GetPlayer().SetMerchant(self);
		OpenMenu("dstar_e\\\\BLK_Market_convo");
	}]
}
