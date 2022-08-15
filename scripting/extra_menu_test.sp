/*
*	Extra Menu API - Test Plugin
*	Copyright (C) 2022 Silvers
*
*	This program is free software: you can redistribute it and/or modify
*	it under the terms of the GNU General Public License as published by
*	the Free Software Foundation, either version 3 of the License, or
*	(at your option) any later version.
*
*	This program is distributed in the hope that it will be useful,
*	but WITHOUT ANY WARRANTY; without even the implied warranty of
*	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*	GNU General Public License for more details.
*
*	You should have received a copy of the GNU General Public License
*	along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/



#define PLUGIN_VERSION 		"1.2"

/*======================================================================================
	Plugin Info:

*	Name	:	[ANY] Extra Menu API - Test Plugin
*	Author	:	SilverShot
*	Descrp	:	Allows plugins to create menus with more than 1-7 selectable entries and more functionality.
*	Link	:	https://forums.alliedmods.net/showthread.php?t=338863
*	Plugins	:	https://sourcemod.net/plugins.php?exact=exact&sortby=title&search=1&author=Silvers

========================================================================================
	Change Log:

1.2 (15-Aug-2022)
	- Added a "meter" options demonstration.

1.0 (30-Jul-2022)
	- Initial release.

======================================================================================*/


#include <sourcemod>
#include <extra_menu>

#pragma semicolon 1
#pragma newdecls required


int g_iMenuID;



// ====================================================================================================
//					PLUGIN INFO
// ====================================================================================================
public Plugin myinfo =
{
	name = "[ANY] Extra Menu API - Test Plugin",
	author = "SilverShot",
	description = "Allows plugins to create menus with more than 1-7 selectable entries and more functionality.",
	version = PLUGIN_VERSION,
	url = "https://forums.alliedmods.net/showthread.php?t=338863"
}



// ====================================================================================================
//					MAIN FUNCTIONS
// ====================================================================================================
public void OnPluginStart()
{
	RegAdminCmd("sm_menutest", CmdMenuTest, ADMFLAG_ROOT);
}

public void OnLibraryAdded(const char[] name)
{
	if( strcmp(name, "extra_menu") == 0 )
	{
		// Create a new menu
		int menu_id = ExtraMenu_Create();

		// Add the entries
		ExtraMenu_AddEntry(menu_id, "VARIOUS OPTIONS:",							MENU_ENTRY);
		ExtraMenu_AddEntry(menu_id, "Use W/S to move row and A/D to select",	MENU_ENTRY);
		ExtraMenu_AddEntry(menu_id, " ",										MENU_ENTRY); // Space to add blank entry
		ExtraMenu_AddEntry(menu_id, "1. God Mode: _OPT_",						MENU_SELECT_ONOFF);
		ExtraMenu_AddEntry(menu_id, "2. No Clip: _OPT_",						MENU_SELECT_ONOFF);
		ExtraMenu_AddEntry(menu_id, "3. Beam Ring: _OPT_",						MENU_SELECT_ONOFF);
		ExtraMenu_AddEntry(menu_id, "4. Player Speed: _OPT_",					MENU_SELECT_ADD, false, 250, 10, 100, 300);
		ExtraMenu_AddEntry(menu_id, " ",										MENU_ENTRY);
		ExtraMenu_AddEntry(menu_id, "VARIABLE OPTIONS:",						MENU_ENTRY);

		ExtraMenu_AddEntry(menu_id, "5. Difficulty: _OPT_",						MENU_SELECT_LIST);
		ExtraMenu_AddOptions(menu_id, "Easy|Normal|Hard|Expert");				// Various selectable options

		ExtraMenu_AddEntry(menu_id, "6. Test Opts: _OPT_",						MENU_SELECT_LIST);
		ExtraMenu_AddOptions(menu_id, "Tester");								// Various selectable options

		ExtraMenu_AddEntry(menu_id, " ",										MENU_ENTRY);
		ExtraMenu_AddEntry(menu_id, "INSTANT CMDS:",							MENU_ENTRY);
		ExtraMenu_AddEntry(menu_id, "7. Slay Self",								MENU_SELECT_ONLY);
		ExtraMenu_AddEntry(menu_id, "8. Default On: _OPT_",						MENU_SELECT_ONOFF, false, 1);
		ExtraMenu_AddEntry(menu_id, "9. Close After Use",						MENU_SELECT_ONLY, true);
		ExtraMenu_AddEntry(menu_id, " ",										MENU_ENTRY); // Space to add blank entry
		ExtraMenu_AddEntry(menu_id, "10. Meter: _OPT_",							MENU_SELECT_LIST);
		ExtraMenu_AddOptions(menu_id, "□□□□□□□□□□|■□□□□□□□□□|■■□□□□□□□□|■■■□□□□□□□|■■■■□□□□□□|■■■■■□□□□□|■■■■■■□□□□|■■■■■■■□□□|■■■■■■■■□□|■■■■■■■■■□|■■■■■■■■■■");	// Various selectable options
		ExtraMenu_AddEntry(menu_id, " ",										MENU_ENTRY); // Space to add blank entry

		ExtraMenu_NewPage(menu_id); // New Page

		ExtraMenu_AddEntry(menu_id, "SECOND PAGE OPTIONS:",						MENU_ENTRY);
		ExtraMenu_AddEntry(menu_id, "Use W/S to move row and A/D to select",	MENU_ENTRY);
		ExtraMenu_AddEntry(menu_id, " ",										MENU_ENTRY); // Space to add blank entry
		ExtraMenu_AddEntry(menu_id, "1. Test1: _OPT_",							MENU_SELECT_ONOFF);
		ExtraMenu_AddEntry(menu_id, "2. Test2: _OPT_",							MENU_SELECT_ONOFF);
		ExtraMenu_AddEntry(menu_id, "3. Test3: _OPT_",							MENU_SELECT_ONOFF);
		ExtraMenu_AddEntry(menu_id, " ",										MENU_ENTRY); // Space to add blank entry

		// Store your menu ID to use later
		g_iMenuID = menu_id;
	}
}

public void OnLibraryRemoved(const char[] name)
{
	if( strcmp(name, "extra_menu") == 0 )
	{
		OnPluginEnd();
	}
}

// Always clean up the menu when finished
public void OnPluginEnd()
{
	ExtraMenu_Delete(g_iMenuID);
}

// Display menu
Action CmdMenuTest(int client, int args)
{
	ExtraMenu_Display(client, g_iMenuID, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

// Menu selection handling
public void ExtraMenu_OnSelect(int client, int menu_id, int option, int value)
{
	if( menu_id == g_iMenuID )
	{
		PrintToChatAll("SELECTED %N Option: %d Value: %d", client, option, value);

		switch( option )
		{
			case 0: ClientCommand(client, "sm_godmode @me");
			case 1: ClientCommand(client, "sm_noclip @me");
			case 2: ClientCommand(client, "sm_beacon @me");
			case 3: ReplyToCommand(client, "Speed changed to %d", value);
			case 4: ReplyToCommand(client, "Difficulty to %d", value);
			case 5: ReplyToCommand(client, "Tester to %d", value);
			case 6: FakeClientCommand(client, "sm_slay @me");
			case 7: ReplyToCommand(client, "Default value changed to %d", value);
			case 8: ReplyToCommand(client, "Close after use %d", value);
			case 9, 10, 11: ReplyToCommand(client, "Second page option %d", option - 5);
		}
	}
}