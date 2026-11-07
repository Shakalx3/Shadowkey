{
	Init[()
	{
		SetName(3265);
		SetID("skey2");
		SetUsable(true);
		SetUseText(3265);
		SetIcon(218);
		SetItemDescription(3265);
		SetCanDrop(false);
	}]
	OnUse[()
	{
		GetPlayer().EquipItem( 0, self );
	}]
	
	UnlockWard[ ()
	{
		Level.UnlockZone("ward_lock"); //hack for erthcave.s
	}]
}