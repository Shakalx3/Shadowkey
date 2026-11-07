{
        Init[ (s)
        {
                SetUseText(1921);
                SetUsable( true );
                SetID("dwnscrl");
                SetName(2597);
                SetIcon(218);
                SetItemDescription(3713);
                SetCanDrop(false);
        } ]

	OnUse[ (s)
	{
		GetPlayer().PickupItem( self );
	} ]
}