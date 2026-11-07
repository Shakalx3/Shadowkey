{

	Init[ (s)
	{	
		
				
		ClearMenu();
		AddStaticItem("A thousand thanks" );
		AddStaticItem("would not repay you" );
		AddStaticItem("for rescuing me " );
		AddStaticItem("from those brutes");
		AddStaticItem( "-----" );
		AddMenuItem( "More.", "MoreResponse" );
				}

			}
		}
	} ]
		
	
	MoreResponse [ (s)
	{
		
		ClearMenu();
		AddStaticItem("But far worse lurks");
		AddStaticItem("in shadows than "); 
		AddStaticItem("bandits and rats,");
		AddStaticItem("and soon ...");
		AddMenuItem("More", "Trinket2");
		
	} ]

	Trinket2[ (s)
	{
		ClearMenu();
		AddStaticItem("My pardon, I ");
		AddStaticItem("forget myself. I am ");
		AddStaticItem("Skelos Undriel,  ");
		AddStaticItem("Shadowmage.");
		AddStaticItem("-----");
		AddMenuItem("More", "Azraspeak");
	} ]

	Azraspeak[ (s)
	{
		ClearMenu();
		AddStaticItem("I should like ");
		AddStaticItem("to speak with you ");
		AddStaticItem("again, back in ");
		AddStaticItem("Azra's Crossing.");
		AddStaticItem("-----");
		AddMenuItem("Exit", "MenuQuit");
	} ]

	MenuQuit[ (s)
	{
		Quit();
	} ]
}