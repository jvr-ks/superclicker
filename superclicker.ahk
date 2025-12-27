/*
 *********************************************************************************
 * 
 * superclicker.ahk
 * 
 * 
 * Copyright (c) 2024 jvr.de. All rights reserved.
 *
 *
 *********************************************************************************
*/
/*
 *********************************************************************************
 * 
 * GNU GENERAL PUBLIC LICENSE
 * 
 * A copy is included in the file "license.txt"
 *
  *********************************************************************************
*/

#Requires AutoHotkey v2
#SingleInstance Force

#Include Lib\codeToText.ahk

#UseHook 1

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
appVersion := "0.018"

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
fontsize := iniReadSave("fontsize", "config", "10")
fontname := iniReadSave("fontname", "config", "Segoe UI")
fontweight := iniReadSave("fontweight", "config", "400")
randomizer := iniReadSave("randomizer", "config", 0)
randomizerDeltaX := iniReadSave("randomizerDeltaX", "config", 0)
randomizerDeltaY := iniReadSave("randomizerDeltaY", "config", 0)
mouseSpeedFoward := iniReadSave("mouseSpeedFoward", "config", 50)
mouseSpeedBack := iniReadSave("mouseSpeedBack", "config", 80)

modeDescription := ["Click on current position", "Click on first position", "Click on first position,`n`nstop if mouse moved"]

setHotkeys()

showQuickHelp()

return

;------------------------------- showQuickHelp -------------------------------
showQuickHelp(*){
  global quickHelpVisible, clickSpeed
  local s
  
  if (!A_IsPaused){
    s := "*** SuperClicker QuickHelp ***`n`n"
    s .= "Please press:`n`n"
    s .= codeToText(superclickerRemoveHotkey) " to remove SuperClicker from memory,`n`n"
    s .= codeToText(superclickerHotkey) " (or right-mouse button) toggle run/stop,`n`n"
    s .= "(Additional [Ctrl] enables a beep, hold down [Shiftl] to suppress clicks),`n`n"
    s .= codeToText("F2") " to measure the time between two clicks (to set the timedelay),`n`n" 
    s .= codeToText(superclickerModeHotkey) . " to toggle click mode,`n`n"
    s .= codeToText(superclickerSpeedIncreaseHotkey) " to increase speed,`n`n"
    s .= codeToText(superclickerSpeedDecreaseHotkey) " to decrease speed,`n`n"
    s .= "Timedelay between clicks is: " format("{1:.2f}", clickSpeed/1000) ",`n`n"
    s .= codeToText("F1") " show/hide Quickhelp.`n`n"
    s .= codeToText(superclickerRemoveHotkey) " to remove SuperClicker from memory,`n"
    
    showHintColored(s, 0)
    Pause
  } else {
    Pause 0
    hintColored.destroy
  }
}
;------------------------------ toogleClickLoop ------------------------------
toogleClickLoop(p1 := 0){
  global running, xClickPos, yClickPos, mode, clickSpeed, beepoff
  
  Pause 0
  
  if (GetKeyState("Ctrl")){
    beepoff := 0
  } else {
    beepoff := 1
  }
  
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
  global hintColored, fontsize, fontweight, fontname
  local fontOption
  
  fontOption := "C" fg " S" fontsize " W" fontweight " Q5"
  
  if (IsSet(hintColored))
    hintColored.destroy
  
  hintColored := Gui("+0x80000000")
  hintColored.SetFont(fontOption, fontname)
  hintColored.BackColor := bg
  hintColored.add("Text", , s)
  hintColored.Opt("-Caption")
  hintColored.Opt("+ToolWindow")
  hintColored.Opt("+AlwaysOnTop")
  hintColored.Show("center autosize")
  
  if (n > 0){
    sleep(n)
    hintColored.Destroy()
  }
}
;------------------------------- clickPosition -------------------------------
clickPosition(){ 
  global 
  local xActuPos, yActuPos, xRandPos, yRandPos

  if (mode = 1){
    if (!GetKeyState("Shift", "P") && !GetKeyState("CapsLock", "T")) {
      MouseGetPos &xActuPos, &yActuPos
      ;Click
      if (randomizer){
        xRandPos := xActuPos + Random(-randomizerDeltaX, randomizerDeltaX)
        yRandPos := yActuPos + Random(-randomizerDeltaY, randomizerDeltaY)
        MouseMove xRandPos, yRandPos, mouseSpeedFoward
        Click
        settimer MouseMoveBack.Bind(xActuPos, yActuPos), -2000
      } else {
        Click
      }
      if (!beepoff)
        SoundBeep
    } else {
      showHintColored("Click is suppressed ...", 1000)
    }
  }
  
  if (mode = 2){
    MouseGetPos &xActuPos, &yActuPos
    if (!GetKeyState("Shift", "P")) {
      Click(xClickPos, yClickPos)
      if (!beepoff)
        SoundBeep
    } else {
      showHintColored("Click is suppressed ...", 1000)
    }
    MouseMove xActuPos, yActuPos
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
      if (!beepoff)
        SoundBeep
      } else {
        showHintColored("Click is suppressed ...", 1000)
      }
    }
  }
}
;------------------------------- MouseMoveBack -------------------------------
MouseMoveBack(p1, p2, *){
  global
  
  MouseMove p1, p2, mouseSpeedBack
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
  Hotkey("*" superclickerHotkey, toogleClickLoop, "On T1")
  Hotkey(superclickerRemoveHotkey, exit, "On T1")
  Hotkey(superclickerModeHotkey, toogleModes, "On T1")
  
  Hotkey(superclickerSpeedIncreaseHotkey, speedIncrease, "On T1")
  Hotkey(superclickerSpeedDecreaseHotkey, speedDecrease, "On T1")
  
  Hotkey("*RBUTTON", toogleClickLoop, "On T1")
  
  Hotkey("F2", timeMeasurement, "On T1")
}
;------------------------------ timeMeasurement ------------------------------
timeMeasurement(*){
  global running, clickSpeed
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

;----------------------------------- Exit -----------------------------------
exit(p1 := 0){
  global
  
  SetTimer(clickLoop, 0)
  
  showHintColored("Thank you for using SuperClicker,`n`nremoving the app from memory,`n`nhave a nice day!", 4000)

  ExitApp
}
;----------------------------------------------------------------------------}


