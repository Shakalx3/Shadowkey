{
        Init[ (s)
        {
                SetUseText(858);
                SetUsable( true );
                SetName(859);
                SetShortName(859);
		SetID("locket");
		SetIcon( 218 );
		SetItemDescription(4014);
		SetCanDrop(false);
        } ]

	OnUse[ (s)
	{
		GetPlayer().PickupItem( self );
	} ]
}
