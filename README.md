# SuperClicker
  
Simple App (Windows 10+ only) to make repeated mouse-clicks at a distinct position.  
  
**This is not rocket science!**  
Based on [Autohotkey 2](https://www.autohotkey.com).  
  
#### Status  
**Beta, under construction, but usable!**  
    
#### Download  
Download via "updater.exe":  
Windows, 64bit: [updater.exe](https://github.com/jvr-ks/superclicker/raw/main/updater.exe) 

#### Start  
"superclicker.exe"  
  
#### Startparameter  
"remove" to remove "superclicker.exe" from memory.  

#### Hotkeys defined
Hotkey | Action | Remarks  
------------ | ------------- | -------------  
**\[F12]** | remove app from memory | 
**\[F10]** or **\[RBUTTON]**| toggle start/stop click-operations |  \*1)
**\[SHIFT] + \[F11]** | increase click speed (decrease timedelay) |  
**\[CTRL] + \[F11]** | decrease click speed  (increase timedelay) |  
**\[ALT] + \[F11]** | toggle thru the modes |  
**\[F1]** | show QuickHelp |  
**\[F2]** | measure the time between two clicks and set the timedelay |  
  
\*1)
* Click-position depends on the selected mode  
* RBUTTON means the right-mouse button
  
Mode | Action  
------------ | -------------  
1 | Use the actual mouse-cursor position  
2 | The start position is saved an then always used (to change the position toggle start/stop)  
3 | Use the saved position, but stop operation, if the mouse is moved away from it  
  
Holddown the "Shift"-key or activate Capslock to temporary disable any click-operation.   
  
If beepoff is not set (Configfile "superclicker.ini" section [config] -&gt; beepoff=0)  
a beep is played on each click (Any change needs a restart of the app).  
  
  
#### License: GPL   
 -&gt; file license.txt
  
Copyright (c) 2023/24 J. v. Roos  
  
<a name="virusscan"></a>  


##### Virusscan at Virustotal 
[Virusscan at Virustotal, superclicker.exe 64bit-exe, Check here](https://www.virustotal.com/gui/url/6f91ac280f107ef1efcde38bff16027ea752fe03a818916352ec8747b670148c/detection/u-6f91ac280f107ef1efcde38bff16027ea752fe03a818916352ec8747b670148c-1766865630
)  
