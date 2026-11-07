{
	saved_Speed[0]

	Init[()
	{
		SetUseText(565);
		SetUsable(true);
	}]

	OnUse[(who)
	{
		SetUsable(false);
		GetPlayer().DoDamage(Random(4,9));
		if(saved_Speed = 0)
		{
			OpenMenu("crypt1\\\\speed");
			saved_Speed = 1;
		}
	}]
}