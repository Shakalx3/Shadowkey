{
	staff [0]
	susten [0]
	wrath [0]
	
	Init[()
	{
		SetUsable(true);
		SetUseText(649);	
	}]
	
	OnUse[(s)
	{
		who = GetID();
		if (who = "staff")
		{	
			if (staff = 0)
			{
				OpenMenu("crypt2\\\\Loot3");
			}
			else
			{
				OpenMenu("crypt2\\\\\NoLoot");		
			}	
		}
		if (who = "susten")
		{
			if (susten = 0)
			{
				OpenMenu("crypt2\\\\Loot2");
			}
			else
			{
				OpenMenu("crypt2\\\\\NoLoot");	
			}	
		}
		if (who = "wrath")
		{
			if (wrath = 0)
			{
				OpenMenu("crypt2\\\\Loot4");
			}
			else
			{
				OpenMenu("crypt2\\\\\NoLoot");	
			}	
		}	
	}]	
}