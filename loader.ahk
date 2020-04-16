#include includes\InjectDll.ahk
#SingleInstance force
Gui, Font, s9
Gui, Add, Button, x120 y80 w110 h30 +Center gLoad, Inject!
Gui, Add, Progress, x50 y50 w240 h20 -smooth +Center vPbar
Gui, Add, Text, x110 y10 w130 h20 +Center, OTC Loader by m4x3r1337
Gui, Show, w350 h150, OTC Loader
GuiControl,, Pbar, 0
return
GuiClose:
ExitApp
Load:
IfNotExist, %A_Temp%\cheat.dll
{
	UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/cheat.dll, %A_Temp%\cheat.dll
	GuiControl,, Pbar, 50
}
IfNotExist, %A_Temp%\addon.dll
{
	UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/addon.dll, %A_Temp%\addon.dll
	GuiControl,, Pbar, 100
}
Process, Exist, csgo.exe
PID = %ErrorLevel%
if (PID == 0) {
	MsgBox, Запустите CS:GO
}
else {
	addon = %A_Temp%\addon.dll
	Inject_Dll(PID, addon)
	Sleep 700
	cheat = %A_Temp%\cheat.dll
	Inject_Dll(PID, cheat)
	MsgBox, Successful injection!
	ExitApp
}