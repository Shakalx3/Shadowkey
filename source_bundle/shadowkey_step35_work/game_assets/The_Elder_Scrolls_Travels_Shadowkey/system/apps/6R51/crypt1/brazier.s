{
	saved_Strength[0]
	saved_Agility[0]
	saved_Speed[0]
	saved_Endurance[0]

	Init[()
	{
		SetUseText(564);
		SetUsable(true);
	}]

	OnUse[(who)
	{
		SetUsable(false);
		GetPlayer().DoDamage(Random(4,9));
		pot = GetID();
		switch(pot)
		{
			if(saved_Strength = 0)
			case "br_str"
			{
				OpenMenu("crypt1\\\\strength");
				saved_Strength = 1;
			}
			if(saved_Agility = 0)
			case "br_agi"
			{
				OpenMenu("crypt1\\\\agility");
				saved_Agility = 1;
			}
			if(saved_Speed = 0)
			case "br_spd"
			{
				OpenMenu("crypt1\\\\speed");
				saved_Speed = 1;
			}
			if(saved_Endurance = 0)
			case "br_end"
			{
				OpenMenu("crypt1\\\\endurance");
				saved_Endurance = 1;
			}
		}
	}]
}