{
	Init[ (s)
	{
		SetUseText(1451);
		SetName(1452);
		SetID("olpack");
		SetItemDescription(1453);
		MoveToEmptyQueue();
		SetIcon(218);
		SetCanDrop(false);
	} ]

	OnUse[ (s)
	{
		GetPlayer().EquipItem( 0, self );
	} ]

}