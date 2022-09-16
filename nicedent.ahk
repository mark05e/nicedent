;。°。°。(*´￫ܫ￩｀*)。°。°   。°。°。(*´￫ܫ￩｀*)。°。°  。°。°。(*´￫ܫ￩｀*)。°。°  。°。°。(*´￫ܫ￩｀*)。°。°
; nicedent - NICE inContact Studio - Snippet Editor Hotkeys
; https://github.com/mark05e/nicedent
;。°。°。(*´￫ܫ￩｀*)。°。°   。°。°。(*´￫ܫ￩｀*)。°。°  。°。°。(*´￫ܫ￩｀*)。°。°  。°。°。(*´￫ܫ￩｀*)。°。°

SetTitleMatchMode,2
#Include obj2str.ahk

; CoordMode, MouseMove, Window
; CoordMode, Pixel, Window
LogEnable := false

Global AppVersion := "0.1"
Global AppName := "Nicedent"
Global AppName := AppName . " " . AppVersion

; Tray Menu
menu_item_2 := "About this app"
Menu, Tray, Add  ; Creates a separator line.
Menu, Tray, Add, %AppName%, showAboutWindow
Menu, Tray, Disable, %AppName%
Menu, Tray, Tip, %AppName%
Menu, Tray, Add, %menu_item_2%, showAboutWindow
Menu, Tray, default, %menu_item_2%
Menu, Tray, Click, 1
I_Icon := "like.ico" ; https://www.flaticon.com/free-icons/like
IfExist, %I_Icon%
Menu, Tray, Icon, %I_Icon%


WriteLog("------------APP START------------")
;===========================================
; Hotkeys
;===========================================
#if isSnippetWindowActive()

; ctrl + /
; ctrl + k
^/::
^k::
  findAndClickPixel("comment")
  return

; ctrl + shift + /
; ctrl + shift + k  
^+/::
^+k::
  findAndClickPixel("uncomment")
  return

; ctrl + enter
^enter::
  findAndClickPixel("checksyntax")
  return
  
F5::
  findAndClickPixel("startexecution")
  return
  
F6::
  activateControlVarTree()
  return
  
^F6::
  activateControlVarTree()
  findAndClickPixel("startexecution")
  return
  

#IfWinActive
^+\:: Reload


;===========================================

showAboutWindow(){
  msgContent := AppName . "`n`n"
  someBar := "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n"
  usageText = 
    (
; USAGE
    
; Comment selection   -> ctrl + / OR ctrl + k

; UnComment selection -> ctrl + shift + / OR ctrl + shift + k

; Check Syntax        -> ctrl + enter

; Start Execution     -> F5

; Show Variable Tree     -> F6

; Show Variable Tree & Start Execution -> ctrl + F6

    )
  contactInfo := "by mark05E"
  msgContent := msgContent . someBar . usageText . someBar . "`n`n" . contactInfo
  MsgBox, 64, %AppName% - About this app, %msgContent%, 15
}

activateControlVarTree(){
  ControlFocus, WindowsForms10.SysTabControl32.app.0.a0f91b_r8_ad13,
  Send {Right}
  Return
}

findAndClickPixel(item) {
  color_Uncomment = 0xbf0b0b
  color_Comment = 0x0b79bf
  color_CheckSyntax = 0x5b9353
  color_StartExecution = 0x4ab018 ; green play
  ; WinGetTitle, Title, A

  switch item {
    case "comment":
      q3 := getSearchRange("q3")
      PixelSearch, OutputVarX, OutputVarY, q3.x1, q3.y1, q3.x2, q3.y2, color_Comment, 3, Fast RGB
      if (ErrorLevel=0) {
        SetControlDelay -1
        ControlClick, x%OutputVarX% y%OutputVarY%
      }
      Return
      
    case "uncomment":
      q3 := getSearchRange("q3")
      PixelSearch, OutputVarX, OutputVarY, q3.x1, q3.y1, q3.x2, q3.y2, color_Uncomment, 3, Fast RGB
      if (ErrorLevel=0) {
        SetControlDelay -1
        ControlClick, x%OutputVarX% y%OutputVarY%
      }
      Return
      
    case "checksyntax":
      q3 := getSearchRange("q3")
      PixelSearch, OutputVarX, OutputVarY, q3.x1, q3.y1, q3.x2, q3.y2, color_CheckSyntax, 3, Fast RGB
      if (ErrorLevel=0) {
        SetControlDelay -1
        ControlClick, x%OutputVarX% y%OutputVarY%
      }
      Return
      
    case "startexecution":
      q3 := getSearchRange("q2")
      PixelSearch, OutputVarX, OutputVarY, q3.x1, q3.y1, q3.x2, q3.y2, color_StartExecution, 3, Fast RGB
      if (ErrorLevel=0) {
        SetControlDelay -1
        ControlClick, x%OutputVarX% y%OutputVarY%
      } else { 
        Msgbox "Boom!" 
      }
      Return
      
  }
  ; Log Data
  ; Can't seem to execute code below
  logdata := {}
  logdata["OutputVarX"] := OutputVarX
  logdata["OutputVarY"] := OutputVarX
  if (Title != "") {
    logdata["Title"] := Title
  }
  logdata["ErrorLevel"] := ErrorLevel
  logdata["Item"] := item
  WriteLog("findAndClickPixel: " . Obj2Str(logdata))
}

getSearchRange(q) {
  size := getSnippetWindowSize()
  w_width  := size.w
  w_height  := size.h
  w_x := size.x // top left
  w_y := size.y // top left
  
  WinGetTitle, Title, A

  switch q {
    case "q2": 
      startX := w_width / 2
      startY := 0
      endX := w_width
      endY := w_height / 2

      result := {}
      result["x1"]   := startX
      result["y1"]   := startY
      result["x2"]   := endX
      result["y2"]   := endY
      result["q"]    := "q2"
      
      result["title"]:= Title
      WriteLog("getSearchRange: " . Obj2Str(result))
      return result
      
    case "q3":
      startX := 0
      startY := w_height / 2
      endX := w_width / 2
      endY := w_height

      result := {}
      result["x1"]   := startX
      result["y1"]   := startY
      result["x2"]   := endX
      result["y2"]   := endY
      result["q"]    := "q3"
      
      result["title"]:= Title
      WriteLog("getSearchRange: " . Obj2Str(result))
      return result
      
    default:
      return 0
  }
}

isSnippetWindowActive() {
  if WinActive("Snippet") or WinActive("- Snippet Properties") {
    return 1
  }
}

getSnippetWindowSize() {
  WinGetActiveStats, Title, Width, Height, X, Y
  ; MsgBox, The active window "%Title%" is %Width% wide`, %Height% tall`, and positioned at %X%`,%Y%.
  result := Object("w",Width, "h",Height, "x",X, "y",y, "Title",Title)
  WriteLog("getSnippetWindowSize: " . Obj2Str(result))
  return result
}

WriteLog(text) {
  if (LogEnable) {
    FileAppend, % A_Now ": " text "`n", logfile.txt ; can provide a full path to write to another directory
  }
}
