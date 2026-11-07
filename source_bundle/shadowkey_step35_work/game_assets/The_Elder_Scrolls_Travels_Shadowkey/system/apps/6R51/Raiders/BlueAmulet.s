{
        Init[ (s)
        {
                SetUseText(2162);
                SetUsable( true );
                SetName(2163);
                SetShortName(2164);
                SetID("blueam");
                SetItemDescription(3575);
                SetIcon( 218 );
                SetCanDrop(false);
        } ]

	OnUse[ (s)
	{
		GetPlayer().PickupItem( self );
	} ]
}