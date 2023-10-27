#Requires AutoHotkey v2
#SingleInstance Force

;----------------------------------------------------------------------------
; superclicker.ahk
;----------------------------------------------------------------------------

CoordMode("Mouse", "Screen")

wrkDir := A_ScriptDir . "\"

;-------------------------------- read cmdline param --------------------------------
hasParams := A_Args.Length

if (hasParams != 0){
  Loop hasParams
  {
    if((A_Args[A_index] == 0))
      ExitApp(0)
      
    if(A_Args[A_index] == "remove")
      exitApp

  }
}

appName := "Superclicker"
appnameLower := "superclicker"
extension := ".exe"
appVersion := "0.003"

title := appName . " " . appVersion 

configFile := appnameLower . " .ini"

xClickPos := 0
yClickPos := 0
clickSpeed := 1000
running := 0
superclickerHotkey := "F10"
superclickerRemoveHotkey := "F12"
superclickerSpeedIncreaseHotkey := "+F11"
superclickerSpeedDecreaseHotkey := "^F11"
superclickerModeHotkey := "!F11"
mode := 1
maxmode := 3

clickSpeed := iniReadSave("clickSpeed", "config", 1000)

modeDescription := ["Click on current position", "Click on first position", "Click on first position,`n`nstop if mouse moved"]

s := "SuperClicker is ready to start,`n"
s .= "(Milliseconds delay between clicks: " . clickSpeed . ")`n`n`n"
s .= "press:`n`n"
s .= superclickerHotkey " to start/stop (or right-mousebutton),`n`n"
s .= superclickerModeHotkey " to toggle click mode,`n`n"
s .= superclickerSpeedIncreaseHotkey " to increase speed,`n`n"
s .= superclickerSpeedDecreaseHotkey " to decrease speed,`n`n"
s .= superclickerRemoveHotkey " to remove from memory,`n`n`n"
s .= "Mouseclick to continue ...`n`n"



showHintColored(s, 0, fg := "cFFFFFF", bg := "a900ff")
KeyWait "LButton", "DT20"
hintColored.Hide()

setHotkeys()

return

;------------------------------ toogleClickLoop ------------------------------
toogleClickLoop(p1 := 0){
  global running, xClickPos, yClickPos, mode
  
  if (running){
    running := 0
    showHintColored("Clickoperations stopped!")
  } else {
    running := 1
    MouseGetPos &xClickPos, &yClickPos
    showHintColored("Clickoperations startet!`n`n(Mode is: " modeDescription[mode] ")")
    clickLoop()
  }

  return 
}
;--------------------------------- clickLoop ---------------------------------
clickLoop(){
  global running, clickSpeed
  local delay

  if (running){
    clickPosition()
    delay := -1 * clickSpeed
    SetTimer(clickLoop, delay)
  }

  return 
}
;------------------------------- speedIncrease -------------------------------
speedIncrease(p1 := 0){
  global clickSpeed

  clickSpeed := clickSpeed - 100
  clickSpeed := Max(clickSpeed, 200)
  IniWrite(clickSpeed, configFile, "config", "clickSpeed")
  
  ; showHintColored("Speed increased, new speed is: " Format("{:0.2f}", clickSpeed) " milliseconds delay between clicks", 1000)
  showHintColored("Speed increased, new speed is: " . clickSpeed . " milliseconds delay between clicks", 1000)

  return 
}
;------------------------------- speedDecrease -------------------------------
speedDecrease(p1 := 0){
  global clickSpeed

  clickSpeed := clickSpeed + 100
  IniWrite(clickSpeed, configFile, "config", "clickSpeed")
  
  showHintColored("Speed decreased, new speed is: " . clickSpeed . " milliseconds delay between clicks", 1000)
  
  return 
}
;------------------------------ showHintColored ------------------------------
showHintColored(s := "", n := 3000, fg := "cFFFFFF", bg := "a900ff"){
  global hintColored
  local t
  
  hintColored := Gui("+0x80000000")
  hintColored.SetFont("c" . fg)
  hintColored.BackColor := bg
  hintColored.add("Text", , s)
  hintColored.Opt("-Caption")
  hintColored.Opt("+ToolWindow")
  hintColored.Opt("+AlwaysOnTop")
  hintColored.Show("center")
  
  if (n != 0){
    Sleep(n)
    hintColored.Hide()
  }
  
  return
}
;------------------------------- clickPosition -------------------------------
clickPosition(){ 
  global xClickPos, yClickPos, mode, running

    if (mode = 1){
      Click
    }
    
    if (mode = 2){
      MouseGetPos &xActuPos, &yActuPos
      Click(xClickPos, yClickPos)
      MouseMove xActuPos, yActuPos
    }
    
    if (mode = 3){
      MouseGetPos &xActuPos, &yActuPos
      if (xActuPos != xClickPos || yActuPos != yClickPos){
        SetTimer(clickLoop, 0)
        running := 0
        showHintColored("Stopped (due to mousemove)!", 2000)
      } else {
        Click(xClickPos, yClickPos)
      }
    }
    
  return 
}
;-------------------------------- iniReadSave --------------------------------
iniReadSave(name, section, defaultValue){
  global configFile

  r := IniRead(configFile, section, name, defaultValue)
  if (r == "" || r == "ERROR")
    r := defaultValue
    
  if (r == "#empty!")
    r := ""
    
  return r
}
;-------------------------------- setHotkeys --------------------------------
setHotkeys(){
  global superclickerHotkey, superclickerRemoveHotkey
  global superclickerSpeedIncreaseHotkey, superclickerSpeedDecreaseHotkey
  global superclickerModeHotkey

  Hotkey(superclickerHotkey, toogleClickLoop,"On T1")
  Hotkey(superclickerRemoveHotkey, exit,"On T1")
  Hotkey(superclickerModeHotkey, toogleModes,"On T1")
  
  Hotkey(superclickerSpeedIncreaseHotkey, speedIncrease,"On T1")
  Hotkey(superclickerSpeedDecreaseHotkey, speedDecrease,"On T1")
  
  Hotkey("RBUTTON", toogleClickLoop,"On T1")

  return
}

;-------------------------------- toogleModes --------------------------------
toogleModes(p1 := 0){
  global running, mode, maxmode, modeDescription, superclickerHotkey
  
  SetTimer(clickLoop, 0)
  running := 0
  mode += 1
  if (mode > maxmode)
    mode := 1
  
  showHintColored("Mode changed to:`n`n" modeDescription[mode] "!`n`nPress " superclickerHotkey " to start!", 2000)
  
  return 
}
;----------------------------------- Exit -----------------------------------
exit(p1 := 0){
  
  SetTimer(clickLoop, 0)
  
  showHintColored("Thank you for using SuperClicker,`n`nremoving app from memory,`n`nhave a nice day!", 4000)

  ExitApp
}
;----------------------------------------------------------------------------}


