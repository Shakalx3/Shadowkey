{
	Init[ (s)
	{
		SetName(3260);
		SetUsable(true);
		SetUseText(3261);
		SetIcon(218);
	} ]

	OnUse[()
	{
		GetPlayer().OpenMenu("dstar_w\\\\Crushscroll_convo");
	}]
}
