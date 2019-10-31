<#
.Synopsis
   Icinga PowerShell Module - Powerfull PowerShell Framework for monitoring Windows Systems
.DESCRIPTION
   More Information on https://github.com/LordHepipud/icinga-module-windows
.EXAMPLE
   Install-Icinga
 .NOTES
    
#>

function Use-Icinga()
{
    param(
        [switch]$LibOnly = $FALSE,
        [switch]$Daemon  = $FALSE
    );

    # This function will allow us to load this entire module including possible
    # actions, making it available within our shell environment
    # First load our custom modules
    Import-IcingaLib '\' -Init -Custom;
    Import-IcingaLib '\' -Init;

    if ($LibOnly -eq $FALSE) {
        $global:IcingaThreads       = [hashtable]::Synchronized(@{});
        $global:IcingaThreadContent = [hashtable]::Synchronized(@{});
        $global:IcingaThreadPool    = [hashtable]::Synchronized(@{});
        $global:IcingaDaemonData    = [hashtable]::Synchronized(
            @{
                'IcingaThreads'            = $global:IcingaThreads;
                'IcingaThreadContent'      = $global:IcingaThreadContent;
                'IcingaThreadPool'         = $global:IcingaThreadPool;
                'FrameworkRunningAsDaemon' = $Daemon;
            }
        );
    }
}

function Import-IcingaLib()
{
    param(
        [Parameter(
            Position=0, 
            Mandatory=$true, 
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)
        ]
        [String]$Lib,
        # The Force Reload will remove the module in case it's loaded and reload it to track
        # possible development changes without having to create new PowerShell environments
        [Switch]$ForceReload,
        [switch]$Init,
        [switch]$Custom
    );

    # This is just to only allow a global loading of the module. Import-IcingaLib is ignored on every other
    # location. It is just there to give a basic idea within commands, of which functions are used
    if ($Init -eq $FALSE) {
        return;
    }

    if ($Custom) {
        [string]$directory  = Join-Path -Path $PSScriptRoot -ChildPath 'custom\';
    } else {
        [string]$directory  = Join-Path -Path $PSScriptRoot -ChildPath 'lib\';
    }
    [string]$module     = Join-Path -Path $directory -ChildPath $Lib;
    [string]$moduleName = '';

    $ListOfLoadedModules = Get-Module | Select-Object Name;

    # Load modules from directory
    if ((Test-Path $module -PathType Container)) {

        Get-ChildItem -Path $module -Recurse -Filter *.psm1 |
        ForEach-Object {
            [string]$modulePath = $_.FullName;
            $moduleName = $_.Name.Replace('.psm1', '');

            if ($ListOfLoadedModules -like "*$moduleName*") {
                if ($ForceReload) {
                    Remove-Module -Name $moduleName
                    Import-Module ([string]::Format('{0}', $modulePath)) -Global; 
                }
            } else {
                Import-Module ([string]::Format('{0}', $modulePath)) -Global; 
            }
        }
    } else {
        $module = $module.Replace('.psm1', ''); # Cut possible .psm1 ending
        $moduleName = $module.Split('\')[-1]; # Get the last element

        if ($ForceReload) {
            if ($ListOfLoadedModules -Like "*$moduleName*") {
                Remove-Module -Name $moduleName;
            }
        }

        Import-Module ([string]::Format('{0}.psm1', $module)) -Global;
    }
}

function Publish-IcingaModuleManifests()
{
    param(
        [string]$Module
    );

    [string]$ManifestDir = Join-Path -Path $PSScriptRoot -ChildPath 'manifests';
    [string]$ModuleFile  = [string]::Format('{0}.psd1', $Module);
    [string]$PSDFile     = Join-Path -Path $ManifestDir -ChildPath $ModuleFile;

    if (Test-Path $PSDFile) {
        return;
    }

    New-ModuleManifest -path $PSDFile -ModuleVersion 1.0 -Author $env:USERNAME -CompanyName 'Icinga GmbH' -Copyright '(c) 2019 Icinga GmbH. All rights reserved.' -PowerShellVersion 4.0;
    $Content    = Get-Content $PSDFile;
    $NewContent = @();

    foreach ($line in $Content) {
        if ([string]::IsNullOrEmpty($line)) {
            continue;
        }

        if ($line[0] -eq '#') {
            continue;
        }

        if ($line.Contains('#')) {
            $line = $line.Substring(0, $line.IndexOf('#'));
        }

        $tmpLine = $line;
        while ($tmpLine.Contains(' ')) {
            $tmpLine = $tmpLine.Replace(' ', '');
        }
        if ([string]::IsNullOrEmpty($tmpLine)) {
            continue;
        }

        $NewContent += $line;
    }

    Set-Content -Path $PSDFile -Value $NewContent;
}

function Get-IcingaPluginDir()
{
    return (Join-Path -Path $PSScriptRoot -ChildPath 'lib\plugins\');
}

function Get-IcingaCustomPluginDir()
{
    return (Join-Path -Path $PSScriptRoot -ChildPath 'custom\plugins\');
}

function Get-IcingaCacheDir()
{
    return (Join-Path -Path $PSScriptRoot -ChildPath 'cache');
}

function Get-IcingaPowerShellConfigDir()
{
    return (Join-Path -Path $PSScriptRoot -ChildPath 'config');
}

function Get-IcingaPowerShellModuleFile()
{
    return (Join-Path -Path $PSScriptRoot -ChildPath 'icinga-module-windows.psm1');
}
