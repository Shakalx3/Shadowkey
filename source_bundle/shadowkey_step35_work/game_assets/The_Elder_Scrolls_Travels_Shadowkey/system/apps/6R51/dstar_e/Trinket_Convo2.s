{
	Init[()
	{
		if(GetPlayer().QuestAssigned(40)=false)
		{
			ClearMenu();
			AddStaticItem(1096);
			AddStaticItem(179, false);
			AddMenuItem(1097, "MenuQuit");
		}
		else
		{
			ClearMenu();
			AddStaticItem(1098);
			AddStaticItem(1099);
			AddStaticItem(179, false);
			AddMenuItem(1100, "Hello");
		}
	}]

	Hello[()
	{
		ClearMenu();
		AddStaticItem(1101);
		AddStaticItem(179, false);
		AddMenuItem(1102, "MenuQuit");
		AddMenuItem(1103, "Noise");
	}]

	Noise[()
	{
		ClearMenu();
		AddStaticItem(1104);
		AddStaticItem(1105);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreNoise");
	}]

	MoreNoise[()
	{
		ClearMenu();
		AddStaticItem(1106);
		AddStaticItem(1107);
		AddStaticItem(179, false);
		AddMenuItem(1108, "Insane");
		AddMenuItem(1109, "Free");
	}]

	Insane[()
	{
		ClearMenu();
		AddStaticItem(1110);
		AddStaticItem(1111);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreInsane");
	}]

	MoreInsane[()
	{
		ClearMenu();
		AddStaticItem(1112);
		AddStaticItem(179, false);
		AddMenuItem(182, "Free");
	}]

	Free[()
	{
		ClearMenu();
		AddStaticItem(1113);
		AddStaticItem(1114);
		AddStaticItem(179, false);
		AddMenuItem(1115, "IcyStare");
		AddMenuItem(1116, "Done");
	}]

	IcyStare[()
	{
		ClearMenu();
		AddStaticItem(1117);
		AddStaticItem(1118);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreStare");
	}]

	MoreStare[()
	{
		ClearMenu();
		AddStaticItem(1119);
		AddStaticItem(1120);
		AddStaticItem(179, false);
		AddMenuItem(182, "Smile");
	}]

	Smile[()
	{
		ClearMenu();
		AddStaticItem(1121);
		AddStaticItem(1122);
		AddStaticItem(179, false);
		AddMenuItem(182, "Destiny");
	}]

	Destiny[()
	{
		ClearMenu();
		AddStaticItem(1123);
		AddStaticItem(1124);
		AddStaticItem(179, false);
		AddMenuItem(386, "Done");
	}]

	Done[()
	{
		ClearMenu();
		Door = Level.GetEntity("trindor");
		Door.OpenDoor("Open Door");
		Trinket = Level.GetEntity("trinket");
		Trinket.DestroyObjectMirror(Trinket);
		GetPlayer().SetQuestSolved(40);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}