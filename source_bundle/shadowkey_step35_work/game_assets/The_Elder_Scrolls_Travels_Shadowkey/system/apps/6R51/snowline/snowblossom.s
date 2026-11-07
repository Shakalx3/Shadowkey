{
	Init[ (s)
	{
		SetID("herb3");
		SetName(2364);
		SetUseText(2365);
		SetIcon(211);
		SetItemDescription(2364);
		SetCanDrop(false);
		SetMPUsable(true);
	} ]

	OnUse[ (s)
	{
		GetPlayer().PickupItem( self );
		MirrorDestroyObject( self );
	} ]
}