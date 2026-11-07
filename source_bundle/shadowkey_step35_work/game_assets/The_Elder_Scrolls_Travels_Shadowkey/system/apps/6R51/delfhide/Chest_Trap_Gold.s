{
	quest_door[false]
	saved_bCanOpen[false]
	resistDisarm[0]
	saved_Open [0]
	Init[ (s)
	{
		SetUseText(456);
		SetMagicDamage(50);
		SetDormant(true);
	}]

	OnUse[ (s)
	{
		if (saved_Open = 0)
		{
			OpenMenu("delfhide\\\\Chest_Trap_convo");
		}
		else
		{
			GetPlayer().DoDamage(6);
			OpenMenu("dstar_e\\\\ChestPickFailed");
		}
	}]

}
