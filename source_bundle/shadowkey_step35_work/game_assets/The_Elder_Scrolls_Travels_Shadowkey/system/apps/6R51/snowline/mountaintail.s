{
	Init[ (s)
	{
		SetID("herb4");
		SetName(2304);
		SetIcon(211);
		SetUseText(2305);
		SetItemDescription(2304);
		SetCanDrop(false);
		SetMPUsable(true);
	} ]

	OnUse[ (s)
	{
		GetPlayer().PickupItem( self );
		MirrorDestroyObject( self );
	} ]
}