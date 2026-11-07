{
        Init[ (s)
        {
                SetUseText(3406);
                SetUsable( false );
                SetName(3406);
                SetShortName(3406);
                SetItemDescription(3407);
                SetID("Pass");
                SetIcon( 218 );
		SetCanDrop(false);
        } ]

	OnUse[ (s)
	{
		GetPlayer().PickupItem( self );
	} ]
}
