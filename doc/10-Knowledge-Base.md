# Icinga for Windows Knowledge Base

While using Icinga for Windows you might run into issues, permissions problems or different problems during usage. Our main goal is to catch all of those problems and print proper error messages to give ideas on what went went wrong exactly.

However, some problems might be more complex and require further detailed descriptions as an issue could be caused my multiple different events or possible solutions would be way too long to put into a plugin output for example.

For this reason you will find a list of Icinga knowledge base entries below. Entries are assigned a unique 6 digit number referenced by issue messages, lead by the abbreviation `IWKB`. Example `IWKB000001`.

| Knowledge Base Id                         | Short Message / Description |
| ---                                       | ---           |
| [IWKB000001](knowledgebase/IWKB000001.md) | The user you are running this command as does not have permission to access the requested Cim-Object. To fix this, please add the user the Agent is running with to the "Remote Management Users" groups and grant access to the WMI branch for the Class/Namespace mentioned above and add the permission "Remote enable". |
| [IWKB000002](knowledgebase/IWKB000002.md) | Plugin execution fails because arguments could not be validated and properly set. An example error could be `The "*" was not recognized as the name of a program, cmdlet, function, script file, or executable. Check the spelling of the name and that the path is correct (if included), and repeat the process.` |
| [IWKB000003](knowledgebase/IWKB000003.md) | The Icinga Agent service `icinga2` cannot be started/modified/added because it is marked for deletion. |
| [IWKB000004](knowledgebase/IWKB000004.md) | Use-Icinga : The 'Use-Icinga' command was found in the module 'icinga-powershell-framework', but the module could not be loaded. For more information, run 'Import-Module icinga-powershell-framework' |
| [IWKB000005](knowledgebase/IWKB000005.md) | powershell.exe : Failed to start service 'Icinga PowerShell Service (icingapowershell)'. |