{
	Init[()
	{
		SetName(3262);
		SetID("skey1");
		SetUsable(true);
		SetUseText(3262);
		SetIcon(218);
		SetItemDescription(3262);
		SetCanDrop(false);
		SetMPUsable(true);
	}]
	OnUse[()
	{
		GetPlayer().PickupItem( self );
		DestroyObjectMirror(self);
	}]
}