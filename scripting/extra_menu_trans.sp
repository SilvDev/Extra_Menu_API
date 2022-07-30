/*
*	Extra Menu API - Test Translations
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



#define PLUGIN_VERSION 		"1.0"

/*======================================================================================
	Plugin Info:

*	Name	:	[ANY] Extra Menu API - Test Translations
*	Author	:	SilverShot
*	Descrp	:	Allows plugins to create menus with more than 1-7 selectable entries and more functionality.
*	Link	:	https://forums.alliedmods.net/showthread.php?t=338863
*	Plugins	:	https://sourcemod.net/plugins.php?exact=exact&sortby=title&search=1&author=Silvers

========================================================================================
	Change Log:

1.0 (30-Jul-2022)
	- Initial release.

======================================================================================*/


#include <sourcemod>
#include <extra_menu>

#pragma semicolon 1
#pragma newdecls required


int g_iMenuID;
int g_iMenuID2;



// ====================================================================================================
//					PLUGIN INFO
// ====================================================================================================
public Plugin myinfo =
{
	name = "[ANY] Extra Menu API - Test Translations",
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
	RegAdminCmd("sm_menutrans", CmdMenuTest, ADMFLAG_ROOT);
}

public void OnLibraryAdded(const char[] name)
{
	if( strcmp(name, "extra_menu") == 0 )
	{
		// Create a new menu
		int menu_id = ExtraMenu_Create(false, "extra_menu_trans.phrases"); // Test translations

		// Add the entries
		ExtraMenu_AddEntry(menu_id, "EXTRA_MENU_OPTIONS",		MENU_ENTRY);
		ExtraMenu_AddEntry(menu_id, "EXTRA_MENU_SELECT",		MENU_ENTRY);
		ExtraMenu_AddEntry(menu_id, " ",						MENU_ENTRY); // Space to add blank entry
		ExtraMenu_AddEntry(menu_id, "EXTRA_MENU_OPT_1",			MENU_SELECT_ONOFF);
		ExtraMenu_AddEntry(menu_id, "EXTRA_MENU_OPT_2",			MENU_SELECT_ONOFF);
		ExtraMenu_AddEntry(menu_id, "EXTRA_MENU_TESTER",		MENU_SELECT_LIST);
		ExtraMenu_AddOptions(menu_id, "EXTRA_MENU_TEST");		// Various selectable options
		ExtraMenu_AddEntry(menu_id, "EXTRA_MENU_NEW_MENU",		MENU_SELECT_ONLY);

		ExtraMenu_AddEntry(menu_id, " ",						MENU_ENTRY); // Space to add blank entry

		// Store your menu ID to use later
		g_iMenuID = menu_id;



		// Create a new second menu
		menu_id = ExtraMenu_Create(true); // Test back button

		// Add the entries
		ExtraMenu_AddEntry(menu_id, "SECOND MENU OPTIONS:",						MENU_ENTRY);
		ExtraMenu_AddEntry(menu_id, "Use W/S to move row and A/D to select",	MENU_ENTRY);
		ExtraMenu_AddEntry(menu_id, " ",										MENU_ENTRY); // Space to add blank entry
		ExtraMenu_AddEntry(menu_id, "1. New Test: _OPT_",						MENU_SELECT_ONOFF);
		ExtraMenu_AddEntry(menu_id, " ",										MENU_ENTRY); // Space to add blank entry
		ExtraMenu_AddEntry(menu_id, "Press 1. to return to the previous menu",	MENU_ENTRY);

		ExtraMenu_AddEntry(menu_id, " ",						MENU_ENTRY); // Space to add blank entry

		// Store your menu ID to use later
		g_iMenuID2 = menu_id;
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
			case 0: PrintToChat(client, "Pressed 1.");
			case 1: PrintToChat(client, "Pressed 2.");
			case 2: PrintToChat(client, "Pressed 2.");
			case 3: ExtraMenu_Display(client, g_iMenuID2, MENU_TIME_FOREVER);
		}
	}

	if( menu_id == g_iMenuID2 )
	{
		PrintToChatAll("SELECTED %N Option: %d Value: %d", client, option, value);

		switch( option )
		{
			case -2: ExtraMenu_Display(client, g_iMenuID, MENU_TIME_FOREVER);
			case 0: PrintToChat(client, "Second Menu: Pressed 1.");
		}
	}
}