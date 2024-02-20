;----------------------------------------------------------------------------
; superclicker.ahk
;----------------------------------------------------------------------------
#Requires AutoHotkey v2
#SingleInstance Force

#UseHook 1

CoordMode("Mouse", "Screen")

wrkDir := A_ScriptDir . "\"

hintColored := 0

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
appVersion := "0.015"

title := appName . " " . appVersion 

configFile := appnameLower . ".ini"

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
beepoff := 0

quickHelpVisible := 0

clickSpeed := iniReadSave("clickSpeed", "config", 1000)
beepoff := iniReadSave("beepoff", "config", 0)

modeDescription := ["Click on current position", "Click on first position", "Click on first position,`n`nstop if mouse moved"]

setHotkeys()

showQuickHelp()

return

;------------------------------- showQuickHelp -------------------------------
showQuickHelp(*){
  global quickHelpVisible, clickSpeed
  local s
  
  if (!A_IsPaused){
    s := "*** SuperClicker QuickHelp " codeToText("F1") " ***`n`n"
    s .= "Please press:`n`n"
    s .= codeToText(superclickerHotkey) " or right-mouse button toggle run/stop,`n`n"
    s .= codeToText(superclickerRemoveHotkey) " to remove SuperClicker from memory!`n`n"
    
    s .= codeToText("F2") " to measure the time between two clicks (to set the timedelay),`n`n" 
    
    s .= codeToText(superclickerModeHotkey) . " to toggle click mode,`n`n"
    s .= codeToText(superclickerSpeedIncreaseHotkey) " to increase speed,`n`n"
    s .= codeToText(superclickerSpeedDecreaseHotkey) " to decrease speed,`n`n"

    s .= "Press " codeToText("F1") " to close Quickhelp ...`n"
    
    showHintColored(s, 0)
    Pause
  } else {
    Pause 0
    hintColored.destroy
  }
}
;------------------------------ toogleClickLoop ------------------------------
toogleClickLoop(p1 := 0){
  global running, xClickPos, yClickPos, mode, clickSpeed
  
  Pause 0
  clickSpeed := iniReadSave("clickSpeed", "config", 1000)
  
  if (running){
    running := 0
    SetTimer(clickLoop, 0)
    showHintColored("Auto-Clickoperation stopped!")
  } else {
    running := 1
    MouseGetPos &xClickPos, &yClickPos
    hintColored.destroy
    SetTimer(clickLoop, -100)
    showHintColored("Auto-Clickoperation startet!`n`n(Mode is: " modeDescription[mode] ")`n`nTimedelay between clicks is: " format("{1:.2f}", clickSpeed/1000), 5000)
  }
}
;--------------------------------- clickLoop ---------------------------------
clickLoop(){
  global running, clickSpeed
  local delay

  if (running){
    clickPosition()
    delay := -1 * clickSpeed
    SetTimer(clickLoop, delay)
  } else {
    SetTimer(clickLoop, 0)
  }
}
;------------------------------- speedIncrease -------------------------------
speedIncrease(p1 := 0){
  global clickSpeed

  Pause 0
  
  clickSpeed := clickSpeed - 500
  clickSpeed := Max(clickSpeed, 500)
  IniWrite(clickSpeed, configFile, "config", "clickSpeed")
  hintColored.destroy
  showHintColored(format("{1:.2f}", clickSpeed/1000) . " seconds delay between clicks (Speed increased!)", 1000)
}
;------------------------------- speedDecrease -------------------------------
speedDecrease(p1 := 0){
  global clickSpeed
  
  Pause 0

  clickSpeed := clickSpeed + 500
  IniWrite(clickSpeed, configFile, "config", "clickSpeed")
  hintColored.destroy
  showHintColored(format("{1:.2f}", clickSpeed/1000) . " seconds timedelay between clicks (Speed decreased!)", 1000)
}
;------------------------------ showHintColored ------------------------------
showHintColored(s := "", n := 3000, fg := "cFFFFFF", bg := "a900ff"){
  global hintColored
  local t
  
  if (hintColored != 0)
    hintColored.destroy
  hintColored := Gui("+0x80000000")
  hintColored.SetFont("c" . fg)
  hintColored.BackColor := bg
  hintColored.add("Text", , s)
  hintColored.Opt("-Caption")
  hintColored.Opt("+ToolWindow")
  hintColored.Opt("+AlwaysOnTop")
  hintColored.Show("center")
  
  if (n > 0){
    sleep(n)
    hintColored.Destroy()
  }
}
;------------------------------- clickPosition -------------------------------
clickPosition(){ 
  global xClickPos, yClickPos, mode, running, beepoff
  local xActuPos, yActuPos

  if (mode = 1){
    if (!GetKeyState("Shift", "P") && !GetKeyState("CapsLock", "T")) {
      Click
    } else {
      showHintColored("Clicks are supressed ...", 1000)
    }
    if (!beepoff)
      SoundBeep
  }
  
  if (mode = 2){
    MouseGetPos &xActuPos, &yActuPos
    if (!GetKeyState("Shift", "P")) {
      Click(xClickPos, yClickPos)
    } else {
      showHintColored("Clicks are supressed ...", 1000)
    }
    MouseMove xActuPos, yActuPos
    if (!beepoff)
      SoundBeep
  }
  
  if (mode = 3){
    MouseGetPos &xActuPos, &yActuPos
    if (xActuPos != xClickPos || yActuPos != yClickPos){
      SetTimer(clickLoop, 0)
      running := 0
      showHintColored("Stopped (due to mousemove)!", 2000)
    } else {
      if (!GetKeyState("Shift", "P")) {
        Click(xClickPos, yClickPos)
      } else {
        showHintColored("Clicks are supressed ...", 1000)
      }
      if (!beepoff)
        SoundBeep
    }
  }
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

  Hotkey("F1", showQuickHelp, "On T2")
  Hotkey(superclickerHotkey, toogleClickLoop, "On T1")
  Hotkey(superclickerRemoveHotkey, exit, "On T1")
  Hotkey(superclickerModeHotkey, toogleModes, "On T1")
  
  Hotkey(superclickerSpeedIncreaseHotkey, speedIncrease, "On T1")
  Hotkey(superclickerSpeedDecreaseHotkey, speedDecrease, "On T1")
  
  Hotkey("RBUTTON", toogleClickLoop, "On T1")
  
  Hotkey("F2", timeMeasurement, "On T1")
}
;------------------------------ timeMeasurement ------------------------------
timeMeasurement(*){
  global running
  local s, start, now, msg

  s := "Time measurement started, position mouse within 5 seconds,`n`n"
  s .= "an automatic start-click will occur!`n`n`n"
  s .= "*** Manually click to finish the measurement intervall! ***`n"
  
  showHintColored(s, 5000)
  
  running := 0
  start := getTimeMillis()
  clickPosition()
  soundBeep
  
  ; RButton ?
  KeyWait "LButton", "DT20"
  now := getTimeMillis()
  
  clickSpeed  := round(now - start)
  
  IniWrite(clickSpeed, configFile, "config", "clickSpeed")
  
  msg := "*** Well done! ***`n`nTimedelay is set to "
  msg .= format("{1:.2f}", clickSpeed/1000) " seconds`n`n"
  msg .= "Mode is: " mode "`n`n"
  msg .= "Click-right to start the click-action!"
  
  showHintColored(msg, 8000)
}
;------------------------------- getTimeMillis -------------------------------
getTimeMillis(){
  DllCall("QueryPerformanceFrequency", "Int64*", &freq := 0)
  DllCall("QueryPerformanceCounter", "Int64*", &now := 0)

  theTimeMillis := now / freq * 1000

  return theTimeMillis
}
;-------------------------------- toogleModes --------------------------------
toogleModes(p1 := 0){
  global running, mode, maxmode, modeDescription, superclickerHotkey
  
  Pause 0
  
  SetTimer(clickLoop, 0)
  running := 0
  mode += 1
  if (mode > maxmode)
    mode := 1
  
  showHintColored("Mode changed to:`n`n" modeDescription[mode] "!`n`nPress " superclickerHotkey " to start!", 2000)
}
;------------------------------- hotkeyToText -------------------------------
hotkeyFirstToText(s) {
  
  h := subStr(s, 1, 1)
  tail := subStr(s, 2)
  
  ret := hkToDescription(h) . " + " . tail
  
  return ret
}
;------------------------------ hkToDescription ------------------------------
hkToDescription(c) {
  s := ""
  
  switch c
  {
    case "^":
      s := "[CTRL]"
    case "!":
      s := "[ALT]"
    case "#":
      s := "[WIN]"
    case "+":
      s := "[SHIFT]"
    case ">":
      s := "Right"
    case "<":
      s := "Left"
    case "$":
      s := "[Alt] + [Tab]"
    default:
      s := "[" . c . "]"
  }
  
  return s
}
;-------------------------------- codeToText --------------------------------
codeToText(toParse) {
  local theTextOut
  
  theTextOut := ""

  c := 0x00A1 ; using unused characters as "special strings" placeholders
  toParse := RegExReplace(toParse, "i)F12",Chr(c),&rest,1,1)
  c += 1
  toParse := RegExReplace(toParse, "i)F11",Chr(c),&rest,1,1)
  c += 1
  toParse := RegExReplace(toParse, "i)F10",Chr(c),&rest,1,1)
  c += 1
  toParse := RegExReplace(toParse, "i)F9",Chr(c),&rest,1,1)
  c += 1
  toParse := RegExReplace(toParse, "i)F8",Chr(c),&rest,1,1)
  c += 1
  toParse := RegExReplace(toParse, "i)F7",Chr(c),&rest,1,1)
  c += 1
  toParse := RegExReplace(toParse, "i)F6",Chr(c),&rest,1,1)
  c += 1
  toParse := RegExReplace(toParse, "i)F5",Chr(c),&rest,1,1)
  c += 1
  toParse := RegExReplace(toParse, "i)F4",Chr(c),&rest,1,1)
  c += 1
  toParse := RegExReplace(toParse, "i)F3",Chr(c),&rest,1,1)
  c += 1
  toParse := RegExReplace(toParse, "i)F2",Chr(c),&rest,1,1)
  c += 1
  toParse := RegExReplace(toParse, "i)F1",Chr(c),&rest,1,1)
  c += 1
  toParse := RegExReplace(toParse, "i)Home",Chr(c),&rest,1,1) ; 0x00AD
  c += 1
  toParse := RegExReplace(toParse, "i)End",Chr(c),&rest,1,1)
  c += 1
  toParse := RegExReplace(toParse, "i)PgUp",Chr(c),&rest,1,1)
  c += 1
  toParse := RegExReplace(toParse, "i)PgDn",Chr(c),&rest,1,1) ; 0x00B0
  c += 1
  toParse := RegExReplace(toParse, "i)Pause",Chr(c),&rest,1,1)
  c += 1
  toParse := RegExReplace(toParse, "i)CapsLock",Chr(c),&rest,1,1)
  c += 1
  toParse := RegExReplace(toParse, "i)Up",Chr(c),&rest,1,1)
  c += 1
  toParse := RegExReplace(toParse, "i)Down",Chr(c),&rest,1,1)
  c += 1
  toParse := RegExReplace(toParse, "i)Left",Chr(c),&rest,1,1)
  c += 1
  toParse := RegExReplace(toParse, "i)Right",Chr(c),&rest,1,1)
  c += 1
  toParse := RegExReplace(toParse, "i)Pause",Chr(c),&rest,1,1) ; 0x00B7

  openBracket := "["
  closeBracket := "]"
  
  Loop Parse, toParse, "", "`n`r"
  {
    switch A_LoopField
    {
      case "+": 
        theTextOut .= openBracket . "SHIFT" . closeBracket . " + "
        
      case "^": 
        theTextOut .= openBracket . "CTRL" . closeBracket . " + "
        
      case "!": 
        theTextOut .= openBracket . "ALT" . closeBracket . " + "
        
      case "#": 
        theTextOut .= openBracket . "WIN" . closeBracket . " + "
        
      case " ": 
        theTextOut .= " "
      
      case Chr(0x00A1): 
        theTextOut .= openBracket . "F12" . closeBracket . " + "
        
      case Chr(0x00A2): 
        theTextOut .= openBracket . "F11" . closeBracket . " + "
        
      case Chr(0x00A3): 
        theTextOut .= openBracket . "F10" . closeBracket . " + "
        
      case Chr(0x00A4): 
        theTextOut .= openBracket . "F9" . closeBracket . " + "

      case Chr(0x00A5): 
        theTextOut .= openBracket . "F8" . closeBracket . " + " 

      case Chr(0x00A6): 
        theTextOut .= openBracket . "F7" . closeBracket . " + " 

      case Chr(0x00A7): 
        theTextOut .= openBracket . "F6" . closeBracket . " + "        
        
      case Chr(0x00A8): 
        theTextOut .= openBracket . "F5" . closeBracket . " + "    
        
      case Chr(0x00A9): 
        theTextOut .= openBracket . "F4" . closeBracket . " + "  
        
      case Chr(0x00AA): 
        theTextOut .= openBracket . "F3" . closeBracket . " + "        
        
      case Chr(0x00AB): 
        theTextOut .= openBracket . "F2" . closeBracket . " + "        
        
      case Chr(0x00AC): 
        theTextOut .= openBracket . "F1" . closeBracket . " + "
        
      case Chr(0x00AC): 
        theTextOut .= openBracket . "F1" . closeBracket . " + "

      case Chr(0x00AD): 
        theTextOut .= openBracket . "Home" . closeBracket . " + "

      case Chr(0x00AE): 
        theTextOut .= openBracket . "End" . closeBracket . " + "

      case Chr(0x00AF): 
        theTextOut .= openBracket . "PgUp" . closeBracket . " + "

      case Chr(0x00B0): 
        theTextOut .= openBracket . "PgDn" . closeBracket . " + "

      case Chr(0x00B1): 
        theTextOut .= openBracket . "Pause" . closeBracket . " + "

      case Chr(0x00B2): 
        theTextOut .= openBracket . "CapsLock" . closeBracket . " + "

      case Chr(0x00B3): 
        theTextOut .= openBracket . "Up" . closeBracket . " + "

      case Chr(0x00B4): 
        theTextOut .= openBracket . "Down" . closeBracket . " + "

      case Chr(0x00B5): 
        theTextOut .= openBracket . "Left" . closeBracket . " + "

      case Chr(0x00B6): 
        theTextOut .= openBracket . "Right" . closeBracket . " + "
        
      case Chr(0x00B7): 
        theTextOut .= openBracket . "Pause" . closeBracket . " + "

      default:
        theTextOut .= openBracket . "" . A_LoopField . "" . closeBracket
    }
  }
  ; StringCaseSense, Off
  if (SubStr(theTextOut, -3, 3) == " + ")
    theTextOut := SubStr(theTextOut, 1, -3)
  
  return theTextOut
}
;----------------------------------- Exit -----------------------------------
exit(p1 := 0){
  
  SetTimer(clickLoop, 0)
  
  showHintColored("Thank you for using SuperClicker,`n`nremoving the app from memory,`n`nhave a nice day!", 4000)

  ExitApp
}
;----------------------------------------------------------------------------}


