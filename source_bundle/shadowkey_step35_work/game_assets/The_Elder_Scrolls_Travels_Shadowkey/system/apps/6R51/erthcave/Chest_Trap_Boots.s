{
	quest_door[false]
	saved_bCanOpen[false]
	resistDisarm[10]
	saved_Open [0]
	Init[ (s)
	{
		SetUseText(456);
		SetName(456);
		Item = Level.CreateEntity( 636 );
		AddObject( Item );
	}]

	OnUse[ (s)
	{
		if (saved_Open = 0)
		{
			OpenMenu("erthcave\\\\Chest_Boots_convo");
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
