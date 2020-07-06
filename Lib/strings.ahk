#Include Lib\Logging.ahk

IfNotExist, C:\AYE
{	
	Logging(1, "Creating folder...")
	FileCreateDir, C:\AYE
}
IfNotExist, C:\AYE\config.ini
{	
	Logging(1, "Creating config file...")
	IniWrite, false, C:\AYE\config.ini, settings, custominject
}


IniRead, language, C:\AYE\config.ini, settings, language

if (language = "ERROR")
{
	MsgBox, 68, AYE Loader, Если вы хотите использовать Русский язык, нажмите Да.`nIf you want to use English, click No.`n`nДанное сообщение появляется только при первом запуске.`nThis message appears only on the first launch.`n`nВы можете изменить язык в конфигурационном файле.`nYou can change the language in the configuration file. (C:\AYE\config.ini)
	IfMsgBox, Yes
		IniWrite, ru, C:\AYE\config.ini, settings, language
	IfMsgBox, No
		IniWrite, en, C:\AYE\config.ini, settings, language
}

IniRead, language, C:\AYE\config.ini, settings, language
; variable values, with the content of the GUI loader text
if (language = "en") 
{
    string_load := "Load"
    string_kill := "Kill CS:GO"
    string_config := "Config"
    string_about := "About"
    string_pid0 := "No csgo.exe process found. Run it?"
    string_nosteam := "Install steam, retard."
    string_success := "Successful injection!"
    string_warning_custom_dll := "We're not gonna help you if your fucking system is gonna blow the fucking wine off it's not our fault. `nGot it?"
    string_no_dll := "You didn't choose the DLL."
    string_kill_alert := "The Kill CS:GO button is designed to close the csgo.exe process`n if nothing is injected after playing with fatality.win. `nKill CS:GO?"
    string_killed := "CS:GO killed!"
}
if (language = "ru") 
{
    string_load := "Заинжектить"
    string_kill := "Закрыть CS:GO"
    string_config := "Настройки"
    string_about := "Инфо"
    string_pid0 := "Процесс csgo.exe не найден. Запустить?"
    string_nosteam := "Установи Steam, клоун."
    string_success := "Инжект прошел успешно"
    string_warning_custom_dll := "Мы не будем тебе помогать если у тебя нахуй система полетит винда нахуй слетит это не наша вина.`nПонял?"
    string_no_dll := "Ты не выбрал DLL."
    string_kill_alert := "Кнопка Закрыть CS:GO предназначена для закрытия процесса csgo.exe`, если после игры с fatality.win ничего не инжектится.`nУбить CS:GO?"
    string_killed := "CS:GO закрыта!"
}