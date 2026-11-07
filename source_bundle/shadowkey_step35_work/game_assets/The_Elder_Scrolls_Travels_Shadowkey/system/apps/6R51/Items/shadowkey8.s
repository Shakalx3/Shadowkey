{
	Init[()
	{
		SetName(3271);
		SetID("skey8");
		SetUsable(true);
		SetUseText(3272);
		SetIcon(218);
		SetItemDescription(3271);
		SetCanDrop(false);
	}]
	OnUse[()
	{
		GetPlayer().EquipItem( 0, self );
	}]
}