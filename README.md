# SuperClicker
  
Simple App (Windows 10+ only) to make repeated mouse-clicks at a distinct position.  
  
**This is not rocket science!**  
Based on [Autohotkey 2](https://www.autohotkey.com).  
  
#### Status  
**Beta, under construction!**  
Hotkeys changed ...  
  
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
**\[F11]** or **\[RBUTTON]**| toggle start/stop click-operations |  \*1)
**\[SHIFT] + \[F11]** | increase click speed |  
**\[CTRL] + \[F11]** | decrease click speed |  
**\[ALT] + \[F11]** | toggle thru the modes |  
**\[F12]** | remove app from memory |  
  
\*1) Click-position depends on the selected mode  
RBUTTON = right mouse-button
  
Mode | Action    
------------ | -------------  
1 | The start position is saved an then always used (to change the position toggle start/stop)  
2 | Use the actual mouse-cursor position  
3 | Use the saved position, but stop operation, if the mouse is moved away from it  

If "Capslock"-key is activated a beep is played on each click.  
(May be disabled by setting Configfile "superclicker.ini" section [config] -> beepoff=1)
  
#### License: MIT  
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sub license, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:  
  
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.  
  
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.  
  
Copyright (c) 2023 J. v. Roos  
  
<a name="virusscan"></a>  


##### Virusscan at Virustotal 
[Virusscan at Virustotal, superclicker.exe 64bit-exe, Check here](https://www.virustotal.com/gui/url/6f91ac280f107ef1efcde38bff16027ea752fe03a818916352ec8747b670148c/detection/u-6f91ac280f107ef1efcde38bff16027ea752fe03a818916352ec8747b670148c-1698434419
)  
