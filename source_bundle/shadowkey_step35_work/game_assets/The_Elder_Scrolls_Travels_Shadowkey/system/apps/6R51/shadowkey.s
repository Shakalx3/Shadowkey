{
	Init[ (s)
	{
		SetUseText(2280);
		SetUsable(true);
		SetName(1703);
	} ]

	OnUse[ (s)
	{
		GetPlayer().PickupItem( self );		
	} ]
}