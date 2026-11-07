{
	Init[ (s)
	{
		SetUseText(1925);
		SetName(3700);
		SetID("ghring");
		SetItemDescription(1930);
		MoveToEmptyQueue();
		SetCanDrop(false);
		SetMPUsable(true);
	} ]

	OnUse[ (s)
	{
		GetPlayer().PickupItem( self );
	} ]

}