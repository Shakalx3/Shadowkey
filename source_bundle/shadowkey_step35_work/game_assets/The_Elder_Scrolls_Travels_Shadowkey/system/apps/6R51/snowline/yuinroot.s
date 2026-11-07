{
	Init[ (s)
	{
		SetID("herb2");
		SetName(2395);
		SetIcon(211);
		SetUseText(2396);
		SetItemDescription(2395);
		SetCanDrop(false);
		SetMPUsable(true);
	} ]

	OnUse[ (s)
	{
		GetPlayer().PickupItem( self );
		MirrorDestroyObject( self );
	} ]
}