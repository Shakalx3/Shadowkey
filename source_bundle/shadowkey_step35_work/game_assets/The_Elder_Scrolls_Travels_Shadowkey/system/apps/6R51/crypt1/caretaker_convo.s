{
	Init[ ()
	{
		ClearMenu();
		if(GetPlayer().QuestAssigned(49)=false)
		{
			ClearMenu();
			AddStaticItem(566);
			AddStaticItem(179, false);
			AddMenuItem(567, "ShadowMaster");
		}
		else
		{
			if(GetPlayer().QuestSolved(49)=false)
			{
				ClearMenu();
				AddStaticItem(568);
				AddStaticItem(179, false);
				AddMenuItem(569, "MenuQuit");
				AddMenuItem(2988, "TellMe");
			}
			else
			{
				ClearMenu();
				AddStaticItem(570);
				AddStaticItem(179, false);
				AddMenuItem(182, "More");
			}
		}
	}]

	MenuQuit[()
	{
		Quit();
	}]

	More[()
	{
		ClearMenu();
		AddStaticItem(571);
		AddStaticItem(572);
		AddStaticItem(179, false);
		AddMenuItem(182, "End");
	}]

	End[()
	{
		ClearMenu();
		AddStaticItem(573);
		AddStaticItem(574);
		AddStaticItem(179, false);
		AddMenuItem(386, "Destroy");
		GetPlayer().AddExperience(2700);
		GetPlayer().SetQuestCompleted(49);
	}]

	Destroy[()
	{
		Ctaker = Level.GetEntity("ctaker");
		Ctaker.DestroyObjectMirror(Ctaker);
		Quit();
	}]

	ShadowMaster[()
	{
		ClearMenu();
		AddStaticItem(575);
		AddStaticItem(179, false);
		AddMenuItem(576, "ShadowMaster2");
	}]

	ShadowMaster2[()
	{
		ClearMenu();
		AddStaticItem(577);
		AddStaticItem(179, false);
		AddMenuItem(578, "MenuQuit");
		AddMenuItem(579, "TellMe");
	}]

	Braziers[()
	{
		ClearMenu();
		AddStaticItem(580);
		AddStaticItem(179, false);
		AddMenuItem(581, "TellMe");
		AddMenuItem(582, "GetGoing");
	}]

	ShadowGate[()
	{
		ClearMenu();
		AddStaticItem(583);
		AddStaticItem(179, false);
		AddMenuItem(182, "ShadowGate2");
	}]

	ShadowGate2[()
	{
		ClearMenu();
		AddStaticItem(584);
		AddStaticItem(179, false);
		AddMenuItem(182, "ShadowGate3");
	}]

	ShadowGate3[()
	{
		ClearMenu();
		AddStaticItem(585);
		AddStaticItem(179, false);
		AddMenuItem(586, "TellMe");
		AddMenuItem(582, "GetGoing");
	}]

	StarTeeth[()
	{
		ClearMenu();
		AddStaticItem(587);
		AddStaticItem(179, false);
		AddMenuItem(182, "StarTeeth2");
	}]

	StarTeeth2[()
	{
		ClearMenu();
		AddStaticItem(588);
		AddStaticItem(179, false);
		AddMenuItem(182, "StarTeeth3");
	}]

	StarTeeth3[()
	{
		ClearMenu();
		AddStaticItem(589);
		AddStaticItem(179, false);
		AddMenuItem(581, "TellMe");
		AddMenuItem(582, "GetGoing");
	}]

	GetGoing[()
	{
		ClearMenu();
		AddStaticItem(590);
		AddStaticItem(179, false);
		AddMenuItem(591, "MenuQuit");
	}]

	TellMe[()
	{
		ClearMenu();
		AddStaticItem(592);
		AddStaticItem(179, false);
		AddMenuItem(593, "Braziers");
		AddMenuItem(594, "ShadowGate");
		AddMenuItem(595, "StarTeeth");

		if(GetPlayer().QuestAssigned(49)=false)
		{
			GetPlayer().SetQuestAssigned(49);
		}
	}]

}