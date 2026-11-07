{
	Chest01 [0]
	Init[ (s)
	{
		SetUseText(2280);
	} ]

	OnUse[ (s)
	{

		if( Chest01 = 0)
		{
		OpenMenu("Shadowkey1Menu");
		Chest01 = 1;
		}
		return;
		
	} ]
}