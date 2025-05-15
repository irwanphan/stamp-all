; Inno Setup script for STAMP Dashboard

[Setup]
AppName=Stampede Dashboard
AppVersion=1.0
DefaultDirName={pf}\Stampede Pertamina
DefaultGroupName=Stampede Dashboard
OutputDir=dist
OutputBaseFilename=stampede_dashboard_installer
Compression=lzma
SolidCompression=yes
DisableWelcomePage=no

[Files]
Source: "build\windows\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs

[Icons]
Name: "{group}\STAMP Dashboard"; Filename: "{app}\stamp_dashboard.exe"
Name: "{group}\Uninstall STAMP Dashboard"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\stamp_dashboard.exe"; Description: "Launch application"; Flags: nowait postinstall skipifsilent
