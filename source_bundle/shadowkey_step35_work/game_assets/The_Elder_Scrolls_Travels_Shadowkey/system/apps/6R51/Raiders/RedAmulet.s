{
        Init[ (s)
        {
                SetUseText(2212);
                SetUsable( true );
                SetName(2213);
                SetShortName(2214);
                SetID("redam");
                SetItemDescription(3574);
                SetIcon( 218 );
                SetCanDrop(false);
        } ]

	OnUse[ (s)
	{
		GetPlayer().PickupItem( self );
	} ]
}