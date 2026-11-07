{
	quest_door[false]
	saved_bCanOpen[false]
	resistDisarm[0]
	saved_Open [0]
	
	Init[ (s)
	{
		SetUseText(456);
		SetName(456);
		Item = Level.CreateEntity( 801 );
		AddObject( Item );
		SetMPUsable(true);
	}]

	OnUse[ (s)
	{
		if (saved_Open = 0)
		{
			OpenMenu("delfhide\\\\Chest_Locket_convo");
		}
		else
		{
			GetLoot();
		}
	}]
	
	GetLoot[ (s)
	{
		OpenMenu("LootMenu");
	}]
	
	UnlockChest[ ()
	{
		//vajuras MP fix
		saved_Open = 1;
	}]

}
