{
	Init[()
	{
		SetName(1337);
		SetAggressive(true);
	}]
	OnKilled[()
	{
		Loot = Level.CreateEntity( 911, GetPositionX(), GetPositionY(), GetPositionZ() );
		Loot.SetDestroy(true);
	}]
}