{
	Init[()
	{
		SetUseText(3308);
		SetUsable(true);
		SetSkin(7);
		SetInvulnerable(true);
		SetAggressive(false);

		ClearProducts();
		AddProduct(618, "Bandit Gloves", 62, 1, IPT_Armor);
		AddProduct(619, "Bonemold Boots", 562, 1, IPT_Armor);
		AddProduct(620, "Bonemold Greaves", 160, 1, IPT_Armor);
		AddProduct(625, "Daedric Pauldron", 5625, 1, IPT_Armor);
		AddProduct(628, "Dragonstar Scale", 11377, 1, IPT_Armor);
		AddProduct(632, "Dwemer Helm", 1953, 1, IPT_Armor);
		AddProduct(635, "Ebony Cuirass", 13611, 1, IPT_Armor);
		AddProduct(636, "Ebony Leather Boots", 302, 1, IPT_Armor);
		AddProduct(638, "Glacial Helm", 5253, 1, IPT_Armor);
		AddProduct(642, "Iron Boots", 902, 1, IPT_Armor);
		AddProduct(645, "Iron Helmet", 1128, 2, IPT_Armor);
		AddProduct(608, "Leather Boots", 90, 1, IPT_Armor);
		AddProduct(602, "Leather Bracer", 11, 1, IPT_Armor);
		AddProduct(616, "Nordic Fur Greaves", 40, 1, IPT_Armor);
		AddProduct(650, "Nordic Iron Cuirass", 2025, 1, IPT_Armor);
		AddProduct(613, "Ra'Gada Light Helm", 112, 1, IPT_Armor);
		AddProduct(660, "Ra'Gada Shade Boots", 9000, 1, IPT_Armor);
		AddProduct(661, "Ringmail", 2500, 1, IPT_Armor);
		AddProduct(667, "Silver Bracer", 1736, 1, IPT_Armor);
		AddProduct(610, "Steel Boots", 1000, 1, IPT_Armor);
		AddProduct(674, "Steel Cuirass", 6944, 1, IPT_Armor);
		AddProduct(675, "Steel Gauntlet", 1555, 1, IPT_Armor);
		AddProduct(677, "Steel Helm", 1250, 1, IPT_Armor);

		AddProduct(516, "Bandit Double-bow", 2609, 1, IPT_Weapon);
		AddProduct(521, "Daedric Dart", 374, 1, IPT_Weapon);
		AddProduct(530, "Dwarven Crossbow", 70662, 1, IPT_Weapon);
		AddProduct(532, "Dwarven War Axe", 5625, 1, IPT_Weapon);
		AddProduct(512, "Iron Shortsword", 143, 1, IPT_Weapon);
		AddProduct(547, "Ra' Gada Cleaver", 463, 1, IPT_Weapon);
		AddProduct(557, "Silver Dagger", 55, 1, IPT_Weapon);
		AddProduct(560, "Silver Shortsword", 240, 1, IPT_Weapon);
		AddProduct(505, "Steel Broadsword", 463, 1, IPT_Weapon);
		AddProduct(569, "Steel Shortsword", 377, 1, IPT_Weapon);
		AddProduct(571, "Steel War Axe", 806, 1, IPT_Weapon);

		AddProduct(4703, "Blueglacier Flower", 830, 2, IPT_Consumable);
		AddProduct(4704, "Blueglacier Moss", 550, 2, IPT_Consumable);
		AddProduct(4705, "Cure Blindness Balm", 140, 2, IPT_Consumable);
		AddProduct(4736, "Horrid Tongue", 890, 2, IPT_Consumable);
		AddProduct(4734, "Mana Ice", 170, 2, IPT_Consumable);
		AddProduct(4735, "Scythe Crystals", 1200, 2, IPT_Consumable);
		AddProduct(707, "Smack Water", 225, 1, IPT_Consumable);
		AddProduct(4730, "Sunlight Water", 380, 6, IPT_Consumable);
		AddProduct(4729, "Thunder Herb", 310, 4, IPT_Consumable);
	}]
	OnUse[()
	{
		GetPlayer().SetMerchant(self);
		if(GetPlayer().QuestCompleted(17) = true)
		{
			ReducePrices(20);
		}		
		GetPlayer().OpenMenu("stouttp\\\\EgrienStoutConvo");
	}]
}