{
	quest_door[false]
	saved_bCanOpen[false]
	resistDisarm[5]
	saved_Open [0]
	Init[ (s)
	{
		SetUseText(3361);

	}]

	OnUse[ (s)
	{
		if (saved_Open = 0)
		{
			if (quest_door = false)
			{
				OpenMenu("dstar_e\\\\UsePickChest");
			}
		}
	}]
	OpenChest[ ()
	{
		OpenMenu("dstar_e\\\\Chest_LootC");
		SetUsable(false);
	}]

	MagicDamage[()
	{
		GetPlayer().DoDamage(30);
		OpenMenu("dstar_e\\\\ChestPickFailed");
	}]
}
