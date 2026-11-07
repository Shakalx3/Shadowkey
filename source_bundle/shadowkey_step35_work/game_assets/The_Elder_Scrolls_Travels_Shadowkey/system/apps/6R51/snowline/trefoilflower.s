{
	Init[ (s)
	{
		SetID("herb1");
		SetName(2389);
		SetIcon(211);
		SetUseText(2390);
		SetItemDescription(2389);
		SetCanDrop(false);
		SetMPUsable(true);
	} ]

	OnUse[ (s)
	{
		GetPlayer().PickupItem( self );
		MirrorDestroyObject( self );
	} ]
}