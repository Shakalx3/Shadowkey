{
	Init[()
	{
		SetName(3601);
		SetID("papers2");
		SetUsable(true);
		SetShortName(3601);
		SetUseText(3602);
		SetIcon(218);
		SetItemDescription(3937);
		SetCanDrop(false);
	}]
	OnUse[()
	{
		GetPlayer().PickupItem( self );
	}]
}