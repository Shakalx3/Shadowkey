{
        Init[ (s)
        {
                SetUseText(1921);
                SetUsable( true );
                SetID("dskscrl");
                SetName(2599);
                SetIcon(218);
                SetItemDescription(3714);
                SetCanDrop(false);
        } ]

	OnUse[ (s)
	{
		GetPlayer().PickupItem( self );
	} ]
}