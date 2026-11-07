{
	comboBox

	Init[ (s)
	{
		ClearMenu();
		AddTitle(4016);

		comboBox=AddComboBox(15, 30);
		comboBox.SetWidth(140);
		comboBox.SetNumericalMode(true);
		comboBox.AddOption(25);

		if (GetPlayer().GetGold() > 50)
		{
			comboBox.AddOption(50);
		}

		if (GetPlayer().GetGold() > 100)
		{
			comboBox.AddOption(100);
		}

		if (GetPlayer().GetGold() > 500)
		{
			comboBox.AddOption(500);
		}

		if (GetPlayer().GetGold() > 1000)
		{
			comboBox.AddOption(1000);
		}

		if (GetPlayer().GetGold() > 5000)
		{
			comboBox.AddOption(5000);
		}

		if (GetPlayer().GetGold() > 10000)
		{
			comboBox.AddOption(10000);
		}

		if (GetPlayer().GetGold() > 25000)
		{
			comboBox.AddOption(25000);
		}

		if (GetPlayer().GetGold() > 50000)
		{
			comboBox.AddOption(50000);
		}

		comboBox.SetOnEnterCallback("OnDropGold");

		funtext=AddFloatingTextJustify(4077, 0, 195, false,32767);
		funtext.SetFontNum(1);
		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	} ]

	OnDropGold[ ()
	{

		index = comboBox.GetSelection();
		if (index = 0)
		{
			GetPlayer().DropGold(25);
		}
		if (index = 1)
		{
			GetPlayer().DropGold(50);
		}
		if (index = 2)
		{
			GetPlayer().DropGold(100);
		}
		if (index = 3)
		{
			GetPlayer().DropGold(500);
		}
		if (index = 4)
		{
			GetPlayer().DropGold(1000);
		}

		if (index = 5)
		{
			GetPlayer().DropGold(5000);
		}
		if (index = 6)
		{
			GetPlayer().DropGold(10000);
		}

		if (index = 7)
		{
			GetPlayer().DropGold(25000);
		}

		if (index = 8)
		{
			GetPlayer().DropGold(50000);
		}

		Quit();
		DisplayCharacterManager();
	}]

	DropGoldMenuBack[ ()
	{
		Quit();
		DisplayCharacterManager();
	}]

}