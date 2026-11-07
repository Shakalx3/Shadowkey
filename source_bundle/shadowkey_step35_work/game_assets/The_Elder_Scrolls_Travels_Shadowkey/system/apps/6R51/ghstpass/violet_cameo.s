{
	Init[ (s)
	{
		SetUseText(1472);
		SetName(1473);
		SetItemDescription(1474);
		//MoveToEmptyQueue();
		SetCanDrop(false);
		SetMPUsable(true);
	} ]

	OnUse[ (s)
	{
		GetPlayer().PickupItem( self );
	} ]

}