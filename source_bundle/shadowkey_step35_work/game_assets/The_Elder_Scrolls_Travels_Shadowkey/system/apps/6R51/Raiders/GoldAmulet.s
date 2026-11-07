{
        Init[ (s)
        {
                SetUseText(2192);
                SetUsable( true );
                SetName(2193);
                SetShortName(2194);
                SetID("goldam");
                SetIcon( 218 );
                SetItemDescription(3576);
                SetCanDrop(false);
        } ]

	OnUse[ (s)
	{
		GetPlayer().PickupItem( self );
	} ]
}