{
	Init[ (s)
	{
		SetID("herb5");
		SetName(2287);
		SetIcon(211);
		SetUseText(2288);
		SetItemDescription(2287);
		SetCanDrop(false);
		SetMPUsable(true);
	} ]

	OnUse[ (s)
	{
		GetPlayer().PickupItem( self );
		MirrorDestroyObject( self );
	} ]
}