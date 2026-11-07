{
	willpow[0]
	intelli[0]
	shadowg[0]

	Init[()
	{
		SetUsable(true);
		SetUseText(648);
	}]

	OnUse[(s)
	{
		who = GetID();
		if(willpow = 0)
		{
			if(who = "willpow")
			{
				Level.GetPlayer().OpenMenu("crypt2\\\\Willpower");
				willpow = 1;
			}
		}

		if(intelli = 0)
		{
			if(who = "intelli")
			{
				GetPlayer().OpenMenu("crypt2\\\\Intelligence");
				intelli = 1;
			}
		}

		if(shadowg = 0)
		{
			if(who = "shadowg")
			{
				GetPlayer().OpenMenu("crypt2\\\\Shadowgate");
				shadowg = 1;
			}
		}
	}]
}