#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=WinLayout.ico
#AutoIt3Wrapper_outfile=WinLayout.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Fileversion=1.0.0.4
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <IE.au3>

Opt("TrayMenuMode", 1) ; Default tray menu items (Script Paused/Exit) will not be shown.

TrayTip("WinLayout", "Loading ...", 0, 1)
Sleep(1000)
TrayTip("", "", 0)

Local Const $conAreaInfoX = 0
Local Const $conAreaInfoY = 1
Local Const $conAreaInfoWidth = 2
Local Const $conAreaInfoHeight = 3

Local Const $conAlignmentHorizontalLeft = 0
Local Const $conAlignmentHorizontalCentre = 1
Local Const $conAlignmentHorizontalRight = 2

Local Const $conAlignmentVerticalTop = 0
Local Const $conAlignmentVerticalCentre = 1
Local Const $conAlignmentVerticalBottom = 2

Local Const $conScreenResolutionWidth = 0
Local Const $conScreenResolutionHeight = 1
Local Const $conScreenResolutionShortName = 2
Local Const $conScreenResolutionLongName = 3

Local $ScreenResolution[8][4] = [ _
                                  [640, 480, "VGA", "Video Graphics Array"], _
                                  [800, 600, "SVGA", "Super Video Graphics Array"], _
                                  [1024, 768, "XGA", "Extended Graphics Array"], _
                                  [1280, 1024, "SXGA", "Super Extended Graphics"], _
                                  [1366, 768, "WXGA", "Wide Extended Graphics"], _
                                  [1600, 1200, "UXGA", "Ultra Extended Graphics"], _
                                  [1680, 1050, "WSXGA", "Wide Super Extended Graphics"], _
                                  [1920, 1200, "WUXGA", "Wide Ultra Extended Graphics"] _
                                ]

Local $ActiveWindowHandle = -1
Local $LastHotKey = ""
Local $ActionToPerform = ""

HotKeySet("#p", "ActiveWindowShowPositionAndSize")

HotKeySet("#1", "ActiveWindowMoveToBottomLeft")
HotKeySet("#2", "ActiveWindowMoveToBottom")
HotKeySet("#3", "ActiveWindowMoveToBottomRight")
HotKeySet("#4", "ActiveWindowMoveToLeft")
HotKeySet("#5", "ActiveWindowMoveToCentre")
HotKeySet("#6", "ActiveWindowMoveToRight")
HotKeySet("#7", "ActiveWindowMoveToTopLeft")
HotKeySet("#8", "ActiveWindowMoveToTop")
HotKeySet("#9", "ActiveWindowMoveToTopRight")
HotKeySet("#{NUMPAD1}", "ActiveWindowMoveToBottomLeft")
HotKeySet("#{NUMPAD2}", "ActiveWindowMoveToBottom")
HotKeySet("#{NUMPAD3}", "ActiveWindowMoveToBottomRight")
HotKeySet("#{NUMPAD4}", "ActiveWindowMoveToLeft")
HotKeySet("#{NUMPAD5}", "ActiveWindowMoveToCentre")
HotKeySet("#{NUMPAD6}", "ActiveWindowMoveToRight")
HotKeySet("#{NUMPAD7}", "ActiveWindowMoveToTopLeft")
HotKeySet("#{NUMPAD8}", "ActiveWindowMoveToTop")
HotKeySet("#{NUMPAD9}", "ActiveWindowMoveToTopRight")

HotKeySet("#!1", "ActiveWindowMoveAndResizeToBottomLeft")
HotKeySet("#!2", "ActiveWindowMoveAndResizeToBottom")
HotKeySet("#!3", "ActiveWindowMoveAndResizeToBottomRight")
HotKeySet("#!4", "ActiveWindowMoveAndResizeToLeft")
HotKeySet("#!5", "ActiveWindowMoveAndResizeToCentre")
HotKeySet("#!6", "ActiveWindowMoveAndResizeToRight")
HotKeySet("#!7", "ActiveWindowMoveAndResizeToTopLeft")
HotKeySet("#!8", "ActiveWindowMoveAndResizeToTop")
HotKeySet("#!9", "ActiveWindowMoveAndResizeToTopRight")
HotKeySet("#!{NUMPAD1}", "ActiveWindowMoveAndResizeToBottomLeft")
HotKeySet("#!{NUMPAD2}", "ActiveWindowMoveAndResizeToBottom")
HotKeySet("#!{NUMPAD3}", "ActiveWindowMoveAndResizeToBottomRight")
HotKeySet("#!{NUMPAD4}", "ActiveWindowMoveAndResizeToLeft")
HotKeySet("#!{NUMPAD5}", "ActiveWindowMoveAndResizeToCentre")
HotKeySet("#!{NUMPAD6}", "ActiveWindowMoveAndResizeToRight")
HotKeySet("#!{NUMPAD7}", "ActiveWindowMoveAndResizeToTopLeft")
HotKeySet("#!{NUMPAD8}", "ActiveWindowMoveAndResizeToTop")
HotKeySet("#!{NUMPAD9}", "ActiveWindowMoveAndResizeToTopRight")

HotKeySet("^#1", "ActiveWindowSnapToBottomLeft")
HotKeySet("^#2", "ActiveWindowSnapToBottom")
HotKeySet("^#3", "ActiveWindowSnapToBottomRight")
HotKeySet("^#4", "ActiveWindowSnapToLeft")
HotKeySet("^#5", "ActiveWindowSnapToCentre")
HotKeySet("^#6", "ActiveWindowSnapToRight")
HotKeySet("^#7", "ActiveWindowSnapToTopLeft")
HotKeySet("^#8", "ActiveWindowSnapToTop")
HotKeySet("^#9", "ActiveWindowSnapToTopRight")
HotKeySet("^#{NUMPAD1}", "ActiveWindowSnapToBottomLeft")
HotKeySet("^#{NUMPAD2}", "ActiveWindowSnapToBottom")
HotKeySet("^#{NUMPAD3}", "ActiveWindowSnapToBottomRight")
HotKeySet("^#{NUMPAD4}", "ActiveWindowSnapToLeft")
HotKeySet("^#{NUMPAD5}", "ActiveWindowSnapToCentre")
HotKeySet("^#{NUMPAD6}", "ActiveWindowSnapToRight")
HotKeySet("^#{NUMPAD7}", "ActiveWindowSnapToTopLeft")
HotKeySet("^#{NUMPAD8}", "ActiveWindowSnapToTop")
HotKeySet("^#{NUMPAD9}", "ActiveWindowSnapToTopRight")

HotKeySet("#-", "ActiveWindowDecreaseSize")
HotKeySet("#=", "ActiveWindowIncreaseSize")
HotKeySet("#{NUMPADSUB}", "ActiveWindowDecreaseSize")
HotKeySet("#{NUMPADADD}", "ActiveWindowIncreaseSize")

HotKeySet("#{LEFT}", "ActiveWindowMoveLeftOnePixel")
HotKeySet("#{RIGHT}", "ActiveWindowMoveRightOnePixel")
HotKeySet("#{UP}", "ActiveWindowMoveUpOnePixel")
HotKeySet("#{DOWN}", "ActiveWindowMoveDownOnePixel")
HotKeySet("#!{LEFT}", "ActiveWindowIncreaseWidthByOnePixelAndMoveLeftOnePixel")
HotKeySet("#!{RIGHT}", "ActiveWindowIncreaseWidthByOnePixel")
HotKeySet("#!{UP}", "ActiveWindowIncreaseHeightByOnePixelAndMoveUpOnePixel")
HotKeySet("#!{DOWN}", "ActiveWindowIncreaseHeightByOnePixel")
HotKeySet("^#{LEFT}", "ActiveWindowDecreaseWidthByOnePixel")
HotKeySet("^#{RIGHT}", "ActiveWindowDecreaseWidthByOnePixelAndMoveRightOnePixel")
HotKeySet("^#{UP}", "ActiveWindowDecreaseHeightByOnePixel")
HotKeySet("^#{DOWN}", "ActiveWindowDecreaseHeightByOnePixelAndMoveDownOnePixel")

Local $ShortcutsFormTrayItem = TrayCreateItem("Shortcuts...")
Local $AboutTrayItem = TrayCreateItem("About...")
TrayCreateItem("")
Local $DonateTrayItem = TrayCreateItem("Donate...")
TrayCreateItem("")
Local $ExitTrayItem = TrayCreateItem("Exit")

TraySetState()

While 1
	$TrayMessage = TrayGetMsg()
	Select
		Case $TrayMessage = 0
			ContinueLoop
		Case $TrayMessage = $ShortcutsFormTrayItem
			ShortcutsFormShow()
			
		Case $TrayMessage = $AboutTrayItem
			AboutFormShow()

		Case $TrayMessage = $DonateTrayItem
			DonateFormShow()

		Case $TrayMessage = $ExitTrayItem
			ExitLoop

	EndSelect
WEnd

Exit

Func ShortcutsFormShow()
	$ShortcutsForm = GUICreate("WinLayout - Shortcuts", 490, 600)
	$ShortcutsEditList = GUICtrlCreateEdit("", 10, 10, 470, 540, $ES_READONLY)
	GUICtrlSetData($ShortcutsEditList, StringFormat("WIN + P = Show active window position and size\r\n" & _
                                                    "WIN + 1 or WIN + NUMPAD1 = Move active window to bottom left\r\n" & _
                                                    "WIN + 2 or WIN + NUMPAD2 = Move active window to bottom\r\n" & _
                                                    "WIN + 3 or WIN + NUMPAD3 = Move active window to bottom right\r\n" & _
                                                    "WIN + 4 or WIN + NUMPAD4 = Move active window to left\r\n" & _
                                                    "WIN + 5 or WIN + NUMPAD5 = Move active window to centre\r\n" & _
                                                    "WIN + 6 or WIN + NUMPAD6 = Move active window to right\r\n" & _
                                                    "WIN + 7 or WIN + NUMPAD7 = Move active window to top left\r\n" & _
                                                    "WIN + 8 or WIN + NUMPAD8 = Move active window to top\r\n" & _
                                                    "WIN + 9 or WIN + NUMPAD9 = Move active window to top right\r\n" & _
                                                    "WIN + ALT + 1 or WIN + ALT + NUMPAD1 = Move active window to bottom left and resize it\r\n" & _
                                                    "WIN + ALT + 2 or WIN + ALT + NUMPAD2 = Move active window to bottom and resize it\r\n" & _
                                                    "WIN + ALT + 3 or WIN + ALT + NUMPAD3 = Move active window to bottom right and resize it\r\n" & _
                                                    "WIN + ALT + 4 or WIN + ALT + NUMPAD4 = Move active window to left and resize it\r\n" & _
                                                    "WIN + ALT + 5 or WIN + ALT + NUMPAD5 = Move active window to centre and resize it\r\n" & _
                                                    "WIN + ALT + 6 or WIN + ALT + NUMPAD6 = Move active window to right and resize it\r\n" & _
                                                    "WIN + ALT + 7 or WIN + ALT + NUMPAD7 = Move active window to top left and resize it\r\n" & _
                                                    "WIN + ALT + 8 or WIN + ALT + NUMPAD8 = Move active window to top and resize it\r\n" & _
                                                    "WIN + ALT + 9 or WIN + ALT + NUMPAD9 = Move active window to top right and resize it\r\n" & _
                                                    "CTRL + WIN + 1 or CTRL + WIN + NUMPAD1 = Snap active window to bottom left\r\n" & _
                                                    "CTRL + WIN + 2 or CTRL + WIN + NUMPAD2 = Snap active window to bottom\r\n" & _
                                                    "CTRL + WIN + 3 or CTRL + WIN + NUMPAD3 = Snap active window to bottom right\r\n" & _
                                                    "CTRL + WIN + 4 or CTRL + WIN + NUMPAD4 = Snap active window to left\r\n" & _
                                                    "CTRL + WIN + 5 or CTRL + WIN + NUMPAD5 = Snap active window to centre\r\n" & _
                                                    "CTRL + WIN + 6 or CTRL + WIN + NUMPAD6 = Snap active window to right\r\n" & _
                                                    "CTRL + WIN + 7 or CTRL + WIN + NUMPAD7 = Snap active window to top left\r\n" & _
                                                    "CTRL + WIN + 8 or CTRL + WIN + NUMPAD8 = Snap active window to top\r\n" & _
                                                    "CTRL + WIN + 9 or CTRL + WIN + NUMPAD9 = Snap active window to top right\r\n" & _
                                                    "WIN + HIFEN or WIN + NUMPAD- = Decrease active window size\r\n" & _
                                                    "WIN + EQUAL or WIN + NUMPAD+ = Increase active window size\r\n" & _
                                                    "WIN + LEFT = Move active window left one pixel\r\n" & _
                                                    "WIN + RIGHT = Move active window right one pixel\r\n" & _
                                                    "WIN + UP = Move active window up one pixel\r\n" & _
                                                    "WIN + DOWN = Move active window down one pixel\r\n" & _
                                                    "WIN + ALT + LEFT = Increase active window width by one pixel and move it left one pixel\r\n" & _
                                                    "WIN + ALT + RIGHT = Increase active window width by one pixel\r\n" & _
                                                    "WIN + ALT + UP = Increase active window height by one pixel and move it up one pixel\r\n" & _
                                                    "WIN + ALT + DOWN = Increase active window height by one pixel\r\n" & _
                                                    "CTRL + WIN + LEFT = Decrease active window width by one pixel\r\n" & _
                                                    "CTRL + WIN + RIGHT = Decrease active window width by one pixel and move it right one pixel\r\n" & _
                                                    "CTRL + WIN + UP = Decrease active window height by one pixel\r\n" & _
                                                    "CTRL + WIN + DOWN = Decrease active window height by one pixel and move it down one pixel\r\n" _
							         			   ) _
				  )
	$CloseButton = GUICtrlCreateButton("&Close", 390, 560, 89, 33, 0)
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $CloseButton
				ExitLoop
		EndSwitch
	WEnd

	GUIDelete($ShortcutsForm)
EndFunc

Func AboutFormShow()
	$AboutForm = GUICreate("WinLayout - About", 324, 234, 303, 219)
	$GroupBox1 = GUICtrlCreateGroup("", 8, 8, 305, 185)
	$LogoImage = GUICtrlCreatePic("", 16, 24, 105, 97, BitOR($SS_NOTIFY,$WS_GROUP, $WS_CLIPSIBLINGS))
	$ProgramNameLabel = GUICtrlCreateLabel("WinLayout v1", 10, 24, 300, 100, BitOR($ES_CENTER, $WS_GROUP))
	$Message = GUICtrlCreateEdit("", 10, 90, 300, 100, BitOR($ES_CENTER, $ES_READONLY), 0)
	GUICtrlSetData($Message, StringFormat("Written by:\r\nLuciano Evaristo Guerche\r\nhttp://friendfeed.com/guerchele\r\n\r\nUsing:\r\nAutoIt v3\r\nhttp://www.autoitscript.com/autoit3/"))
	$Button1 = GUICtrlCreateButton("&OK", 128, 200, 75, 25)
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $Button1
				ExitLoop	
		EndSwitch
	WEnd

	GUIDelete($AboutForm)
EndFunc

Func DonateFormShow()
	$AboutForm = GUICreate("WinLayout - Donate", 324, 234, 303, 219)
	$GroupBox1 = GUICtrlCreateGroup("", 8, 8, 305, 185)
	$LogoImage = GUICtrlCreatePic("", 16, 24, 105, 97, BitOR($SS_NOTIFY,$WS_GROUP, $WS_CLIPSIBLINGS))
	$Message = GUICtrlCreateEdit("", 10, 20, 300, 100, BitOR($ES_CENTER, $ES_READONLY), 0)
	GUICtrlSetData($Message, StringFormat("Clicking 'Donate' button will open Internet Explorer and automatically redirect you to Paypal website to proceed with donation\r\n\r\nIf Internet Explorer is not installed, click 'Copy URL to clipboard' button, then go to your web browser and paste the URL address"))
	$Button1 = GUICtrlCreateButton("&Donate", 15, 130, 290, 25)
	$Button2 = GUICtrlCreateButton("&Copy URL to clipboard", 15, 160, 290, 25)
	$Button3 = GUICtrlCreateButton("&OK", 128, 200, 75, 25)
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $Button1
				$oIE = _IECreate("https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=guercheLE%40gmail%2ecom&item_name=WinLayout&no_shipping=0&tax=0&currency_code=USD&lc=BR&bn=PP%2dDonationsBF&charset=UTF%2d8")
			Case $Button2
				ClipPut("https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=guercheLE%40gmail%2ecom&item_name=WinLayout&no_shipping=0&tax=0&currency_code=USD&lc=BR&bn=PP%2dDonationsBF&charset=UTF%2d8")
				MsgBox(0, "WinLayout - Donate", "Donation URL copied to clipboard")
			Case $Button3
				ExitLoop
		EndSwitch
	WEnd

	GUIDelete($AboutForm)
EndFunc

Func AvailableAreaInfo()
	Local $DesktopAreaInfo = WinGetPos("Program Manager")
	Local $TaskbarAreaInfo = WinGetPos("[CLASS:Shell_TrayWnd]")
	Local $AvailableAreaInfo[4]

	If $TaskbarAreaInfo[$conAreaInfoX] <= 0 Then
		If $TaskbarAreaInfo[$conAreaInfoY] <= 0 Then
			If $TaskbarAreaInfo[$conAreaInfoWidth] > $TaskbarAreaInfo[$conAreaInfoHeight] Then ;Taskbar on top side
				$AvailableAreaInfo[$conAreaInfoX] = $DesktopAreaInfo[$conAreaInfoX]
				$AvailableAreaInfo[$conAreaInfoY] = $DesktopAreaInfo[$conAreaInfoY] + ($TaskbarAreaInfo[$conAreaInfoHeight] + $TaskbarAreaInfo[$conAreaInfoY])
				$AvailableAreaInfo[$conAreaInfoWidth] = $DesktopAreaInfo[$conAreaInfoWidth]
				$AvailableAreaInfo[$conAreaInfoHeight] = $DesktopAreaInfo[$conAreaInfoHeight] - ($TaskbarAreaInfo[$conAreaInfoHeight] + $TaskbarAreaInfo[$conAreaInfoY])
			Else ;Taskbar on left side
				$AvailableAreaInfo[$conAreaInfoX] = $DesktopAreaInfo[$conAreaInfoX] + ($TaskbarAreaInfo[$conAreaInfoWidth] + $TaskbarAreaInfo[$conAreaInfoX])
				$AvailableAreaInfo[$conAreaInfoY] = $DesktopAreaInfo[$conAreaInfoY]
				$AvailableAreaInfo[$conAreaInfoWidth] = $DesktopAreaInfo[$conAreaInfoWidth] - ($TaskbarAreaInfo[$conAreaInfoWidth] + $TaskbarAreaInfo[$conAreaInfoX])
				$AvailableAreaInfo[$conAreaInfoHeight] = $DesktopAreaInfo[$conAreaInfoHeight]
			EndIf
		Else ;Taskbar on bottom side
			$AvailableAreaInfo[$conAreaInfoX] = $DesktopAreaInfo[$conAreaInfoX]
			$AvailableAreaInfo[$conAreaInfoY] = 0
			$AvailableAreaInfo[$conAreaInfoWidth] = $DesktopAreaInfo[$conAreaInfoWidth]
			$AvailableAreaInfo[$conAreaInfoHeight] = $TaskbarAreaInfo[$conAreaInfoY]
		EndIf
	Else ;Taskbar on right side
		$AvailableAreaInfo[$conAreaInfoX] = 0
		$AvailableAreaInfo[$conAreaInfoY] = 0
		$AvailableAreaInfo[$conAreaInfoWidth] = $TaskbarAreaInfo[$conAreaInfoX]
		$AvailableAreaInfo[$conAreaInfoHeight] = $DesktopAreaInfo[$conAreaInfoHeight]
	EndIf

	Return $AvailableAreaInfo
EndFunc

Func ActiveWindowShowPositionAndSize()
	ShowPositionAndSizeOnTooltip(WinGetPos("[ACTIVE]"))
	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowMoveToBottomLeft()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalLeft, $NewActiveWindowAreaInfo)
	ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalBottom, $NewActiveWindowAreaInfo)
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowMoveToBottom()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalCentre, $NewActiveWindowAreaInfo)
	ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalBottom, $NewActiveWindowAreaInfo)
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowMoveToBottomRight()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalRight, $NewActiveWindowAreaInfo)
	ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalBottom, $NewActiveWindowAreaInfo)
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowMoveToLeft()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalLeft, $NewActiveWindowAreaInfo)
	ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalCentre, $NewActiveWindowAreaInfo)
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowMoveToCentre()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalCentre, $NewActiveWindowAreaInfo)
	ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalCentre, $NewActiveWindowAreaInfo)
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowMoveToRight()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalRight, $NewActiveWindowAreaInfo)
	ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalCentre, $NewActiveWindowAreaInfo)
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowMoveToTopLeft()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalLeft, $NewActiveWindowAreaInfo)
	ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalTop, $NewActiveWindowAreaInfo)
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowMoveToTop()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalCentre, $NewActiveWindowAreaInfo)
	ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalTop, $NewActiveWindowAreaInfo)
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowMoveToTopRight()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalRight, $NewActiveWindowAreaInfo)
	ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalTop, $NewActiveWindowAreaInfo)
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowMoveAndResizeToBottomLeft()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	If $ActiveWindowHandle <> WinGetHandle("[ACTIVE]") Or ($LastHotKey <> "#!1" And $LastHotKey <> "#!{NUMPAD1}") Then
		$ActionToPerform = 1
	EndIf

	Switch $ActionToPerform
		Case 1 ;move & resize (2 x 2 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 2, 2, 1, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalLeft, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalBottom, $NewActiveWindowAreaInfo)
		Case 2 ;move & resize (3 x 2 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 3, 2, 1, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalLeft, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalBottom, $NewActiveWindowAreaInfo)
		Case 3 ;move & resize (3 x 3 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 3, 3, 1, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalLeft, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalBottom, $NewActiveWindowAreaInfo)
	EndSwitch

	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
	$ActionToPerform = Mod($ActionToPerform, 3) + 1
EndFunc

Func ActiveWindowMoveAndResizeToBottom()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	If $ActiveWindowHandle <> WinGetHandle("[ACTIVE]") Or ($LastHotKey <> "#!2" And $LastHotKey <> "#!{NUMPAD2}") Then
		$ActionToPerform = 1
	EndIf

	Switch $ActionToPerform
		Case 1 ;move & resize (2 x 2 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 2, 2, 2, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalCentre, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalBottom, $NewActiveWindowAreaInfo)
		Case 2 ;move & resize (3 x 2 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 3, 2, 1, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalCentre, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalBottom, $NewActiveWindowAreaInfo)
		Case 3 ;move & resize (3 x 3 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 3, 3, 1, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalCentre, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalBottom, $NewActiveWindowAreaInfo)
	EndSwitch

	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
	$ActionToPerform = Mod($ActionToPerform, 3) + 1
EndFunc

Func ActiveWindowMoveAndResizeToBottomRight()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	If $ActiveWindowHandle <> WinGetHandle("[ACTIVE]") Or ($LastHotKey <> "#!3" And $LastHotKey <> "#!{NUMPAD3}") Then
		$ActionToPerform = 1
	EndIf

	Switch $ActionToPerform
		Case 1 ;move & resize (2 x 2 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 2, 2, 1, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalRight, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalBottom, $NewActiveWindowAreaInfo)
		Case 2 ;move & resize (3 x 2 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 3, 2, 1, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalRight, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalBottom, $NewActiveWindowAreaInfo)
		Case 3 ;move & resize (3 x 3 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 3, 3, 1, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalRight, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalBottom, $NewActiveWindowAreaInfo)
	EndSwitch

	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
	$ActionToPerform = Mod($ActionToPerform, 3) + 1
EndFunc

Func ActiveWindowMoveAndResizeToLeft()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	If $ActiveWindowHandle <> WinGetHandle("[ACTIVE]") Or ($LastHotKey <> "#!4" And $LastHotKey <> "#!{NUMPAD4}") Then
		$ActionToPerform = 1
	EndIf

	Switch $ActionToPerform
		Case 1 ;move & resize (2 x 2 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 2, 2, 1, 2, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalLeft, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalCentre, $NewActiveWindowAreaInfo)
		Case 2 ;move & resize (3 x 2 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 3, 2, 1, 2, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalLeft, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalCentre, $NewActiveWindowAreaInfo)
		Case 3 ;move & resize (3 x 3 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 3, 3, 1, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalLeft, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalCentre, $NewActiveWindowAreaInfo)
	EndSwitch

	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
	$ActionToPerform = Mod($ActionToPerform, 3) + 1
EndFunc

Func ActiveWindowMoveAndResizeToCentre()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	If $ActiveWindowHandle <> WinGetHandle("[ACTIVE]") Or ($LastHotKey <> "#!5" And $LastHotKey <> "#!{NUMPAD5}") Then
		$ActionToPerform = 1
	EndIf

	Switch $ActionToPerform
		Case 1 ;move & resize (2 x 2 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 2, 2, 2, 2, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalCentre, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalCentre, $NewActiveWindowAreaInfo)
		Case 2 ;move & resize (3 x 2 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 3, 2, 1, 2, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalCentre, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalTop, $NewActiveWindowAreaInfo)
		Case 3 ;move & resize (3 x 3 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 3, 3, 3, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalLeft, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalCentre, $NewActiveWindowAreaInfo)
		Case 4 ;move & resize (3 x 3 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 3, 3, 1, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalCentre, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalCentre, $NewActiveWindowAreaInfo)
	EndSwitch

	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
	$ActionToPerform = Mod($ActionToPerform, 4) + 1
EndFunc

Func ActiveWindowMoveAndResizeToRight()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	If $ActiveWindowHandle <> WinGetHandle("[ACTIVE]") Or ($LastHotKey <> "#!6" And $LastHotKey <> "#!{NUMPAD6}") Then
		$ActionToPerform = 1
	EndIf

	Switch $ActionToPerform
		Case 1 ;move & resize (2 x 2 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 2, 2, 1, 2, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalRight, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalCentre, $NewActiveWindowAreaInfo)
		Case 2 ;move & resize (3 x 2 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 3, 2, 1, 2, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalRight, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalCentre, $NewActiveWindowAreaInfo)
		Case 3 ;move & resize (3 x 3 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 3, 3, 1, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalRight, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalCentre, $NewActiveWindowAreaInfo)
	EndSwitch

	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
	$ActionToPerform = Mod($ActionToPerform, 3) + 1
EndFunc

Func ActiveWindowMoveAndResizeToTopLeft()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	If $ActiveWindowHandle <> WinGetHandle("[ACTIVE]") Or ($LastHotKey <> "#!7" And $LastHotKey <> "#!{NUMPAD7}") Then
		$ActionToPerform = 1
	EndIf

	Switch $ActionToPerform
		Case 1 ;move & resize (2 x 2 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 2, 2, 1, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalLeft, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalTop, $NewActiveWindowAreaInfo)
		Case 2 ;move & resize (3 x 2 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 3, 2, 1, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalLeft, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalTop, $NewActiveWindowAreaInfo)
		Case 3 ;move & resize (3 x 3 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 3, 3, 1, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalLeft, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalTop, $NewActiveWindowAreaInfo)
	EndSwitch

	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
	$ActionToPerform = Mod($ActionToPerform, 3) + 1
EndFunc

Func ActiveWindowMoveAndResizeToTop()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	If $ActiveWindowHandle <> WinGetHandle("[ACTIVE]") Or ($LastHotKey <> "#!8" And $LastHotKey <> "#!{NUMPAD8}") Then
		$ActionToPerform = 1
	EndIf

	Switch $ActionToPerform
		Case 1 ;move & resize (2 x 2 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 2, 2, 2, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalCentre, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalTop, $NewActiveWindowAreaInfo)
		Case 2 ;move & resize (3 x 2 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 3, 2, 1, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalCentre, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalTop, $NewActiveWindowAreaInfo)
		Case 3 ;move & resize (3 x 3 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 3, 3, 1, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalCentre, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalTop, $NewActiveWindowAreaInfo)
	EndSwitch

	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
	$ActionToPerform = Mod($ActionToPerform, 3) + 1
EndFunc

Func ActiveWindowMoveAndResizeToTopRight()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	If $ActiveWindowHandle <> WinGetHandle("[ACTIVE]") Or ($LastHotKey <> "#!9" And $LastHotKey <> "#!{NUMPAD9}") Then
		$ActionToPerform = 1
	EndIf
	
	Switch $ActionToPerform
		Case 1 ;move & resize (2 x 2 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 2, 2, 1, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalRight, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalTop, $NewActiveWindowAreaInfo)
		Case 2 ;move & resize (3 x 2 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 3, 2, 1, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalRight, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalTop, $NewActiveWindowAreaInfo)
		Case 3 ;move & resize (3 x 3 grid)
			ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, 3, 3, 1, 1, $NewActiveWindowAreaInfo)
			ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalRight, $NewActiveWindowAreaInfo)
			ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalTop, $NewActiveWindowAreaInfo)
	EndSwitch

	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
	$ActionToPerform = Mod($ActionToPerform, 3) + 1
EndFunc

Func ActiveWindowSnapToBottomLeft()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	ActiveWindowSetWidthBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalLeft, $NewActiveWindowAreaInfo)
	ActiveWindowSetHeightBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalBottom, $NewActiveWindowAreaInfo)
	ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalLeft, $NewActiveWindowAreaInfo)
	ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalBottom, $NewActiveWindowAreaInfo)
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowSnapToBottom()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	ActiveWindowSetHeightBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalBottom, $NewActiveWindowAreaInfo)
	ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalBottom, $NewActiveWindowAreaInfo)
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowSnapToBottomRight()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	ActiveWindowSetWidthBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalRight, $NewActiveWindowAreaInfo)
	ActiveWindowSetHeightBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalBottom, $NewActiveWindowAreaInfo)
	ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalRight, $NewActiveWindowAreaInfo)
	ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalBottom, $NewActiveWindowAreaInfo)
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowSnapToLeft()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	ActiveWindowSetWidthBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalLeft, $NewActiveWindowAreaInfo)
	ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalLeft, $NewActiveWindowAreaInfo)
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowSnapToCentre()
	Local $NewActiveWindowAreaInfo = AvailableAreaInfo()

	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowSnapToRight()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	ActiveWindowSetWidthBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalRight, $NewActiveWindowAreaInfo)
	ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalRight, $NewActiveWindowAreaInfo)
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowSnapToTopLeft()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	ActiveWindowSetWidthBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalLeft, $NewActiveWindowAreaInfo)
	ActiveWindowSetHeightBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalTop, $NewActiveWindowAreaInfo)
	ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalLeft, $NewActiveWindowAreaInfo)
	ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalTop, $NewActiveWindowAreaInfo)
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowSnapToTop()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	ActiveWindowSetHeightBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalTop, $NewActiveWindowAreaInfo)
	ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalTop, $NewActiveWindowAreaInfo)
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowSnapToTopRight()
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	ActiveWindowSetWidthBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalRight, $NewActiveWindowAreaInfo)
	ActiveWindowSetHeightBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalTop, $NewActiveWindowAreaInfo)
	ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalRight, $NewActiveWindowAreaInfo)
	ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalTop, $NewActiveWindowAreaInfo)
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)

	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowDecreaseSize()
	Local $ScreenResolutionToDecreaseSizeTo = -1
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	For $ScreenResolutionToDecreaseSizeTo = UBound($ScreenResolution) - 1 to 0 Step -1
		If $NewActiveWindowAreaInfo[$conAreaInfoWidth] > $ScreenResolution[$ScreenResolutionToDecreaseSizeTo][$conScreenResolutionWidth] Then
			ExitLoop
		EndIf
	Next
	If $ScreenResolutionToDecreaseSizeTo < 0 Then
		$ScreenResolutionToDecreaseSizeTo = 0
	EndIf

	$NewActiveWindowAreaInfo[$conAreaInfoWidth] = $ScreenResolution[$ScreenResolutionToDecreaseSizeTo][$conScreenResolutionWidth]
	$NewActiveWindowAreaInfo[$conAreaInfoHeight] = $ScreenResolution[$ScreenResolutionToDecreaseSizeTo][$conScreenResolutionHeight]
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)
	ShowPositionAndSizeOnTooltip($NewActiveWindowAreaInfo)

	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowIncreaseSize()
	Local $ScreenResolutionToDecreaseSizeTo = -1
	Local $AvailableAreaInfo = AvailableAreaInfo()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")

	For $ScreenResolutionToDecreaseSizeTo = 0 To UBound($ScreenResolution) - 1 Step 1
		If $NewActiveWindowAreaInfo[$conAreaInfoWidth] < $ScreenResolution[$ScreenResolutionToDecreaseSizeTo][$conScreenResolutionWidth] Then
			ExitLoop
		EndIf
	Next
	If $ScreenResolutionToDecreaseSizeTo > UBound($ScreenResolution) - 1 Then
		$ScreenResolutionToDecreaseSizeTo = UBound($ScreenResolution) - 1
	EndIf
	While $ScreenResolution[$ScreenResolutionToDecreaseSizeTo][$conScreenResolutionWidth] >= $AvailableAreaInfo[$conAreaInfoWidth] And $ScreenResolutionToDecreaseSizeTo > 0
		$ScreenResolutionToDecreaseSizeTo = $ScreenResolutionToDecreaseSizeTo - 1
	WEnd

	$NewActiveWindowAreaInfo[$conAreaInfoWidth] = $ScreenResolution[$ScreenResolutionToDecreaseSizeTo][$conScreenResolutionWidth]
	$NewActiveWindowAreaInfo[$conAreaInfoHeight] = $ScreenResolution[$ScreenResolutionToDecreaseSizeTo][$conScreenResolutionHeight]
	If $NewActiveWindowAreaInfo[$conAreaInfoX] + $NewActiveWindowAreaInfo[$conAreaInfoWidth] > $AvailableAreaInfo[$conAreaInfoX] + $AvailableAreaInfo[$conAreaInfoWidth] Then
		ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $conAlignmentHorizontalRight, $NewActiveWindowAreaInfo)
	EndIf
	If $NewActiveWindowAreaInfo[$conAreaInfoY] + $NewActiveWindowAreaInfo[$conAreaInfoHeight] > $AvailableAreaInfo[$conAreaInfoY] + $AvailableAreaInfo[$conAreaInfoHeight] Then
		ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $conAlignmentVerticalBottom, $NewActiveWindowAreaInfo)
	EndIf
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)
	ShowPositionAndSizeOnTooltip($NewActiveWindowAreaInfo)

	$ActiveWindowHandle = WinGetHandle("[ACTIVE]")
	$LastHotKey = @HotKeyPressed
EndFunc

Func ActiveWindowMoveLeftOnePixel()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")
	$NewActiveWindowAreaInfo[$conAreaInfoX] -= 1
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)
EndFunc

Func ActiveWindowMoveRightOnePixel()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")
	$NewActiveWindowAreaInfo[$conAreaInfoX] += 1
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)
EndFunc

Func ActiveWindowMoveUpOnePixel()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")
	$NewActiveWindowAreaInfo[$conAreaInfoY] -= 1
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)
EndFunc

Func ActiveWindowMoveDownOnePixel()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")
	$NewActiveWindowAreaInfo[$conAreaInfoY] += 1
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)
EndFunc

Func ActiveWindowIncreaseWidthByOnePixelAndMoveLeftOnePixel()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")
	$NewActiveWindowAreaInfo[$conAreaInfoWidth] += 1
	$NewActiveWindowAreaInfo[$conAreaInfoX] -= 1
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)
EndFunc

Func ActiveWindowIncreaseWidthByOnePixel()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")
	$NewActiveWindowAreaInfo[$conAreaInfoWidth] += 1
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)
EndFunc

Func ActiveWindowIncreaseHeightByOnePixelAndMoveUpOnePixel()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")
	$NewActiveWindowAreaInfo[$conAreaInfoHeight] += 1
	$NewActiveWindowAreaInfo[$conAreaInfoY] -= 1
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)
EndFunc

Func ActiveWindowIncreaseHeightByOnePixel()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")
	$NewActiveWindowAreaInfo[$conAreaInfoHeight] += 1
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)
EndFunc

Func ActiveWindowDecreaseWidthByOnePixel()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")
	$NewActiveWindowAreaInfo[$conAreaInfoWidth] -= 1
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)
EndFunc

Func ActiveWindowDecreaseWidthByOnePixelAndMoveRightOnePixel()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")
	$NewActiveWindowAreaInfo[$conAreaInfoWidth] -= 1
	$NewActiveWindowAreaInfo[$conAreaInfoX] += 1
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)
EndFunc

Func ActiveWindowDecreaseHeightByOnePixel()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")
	$NewActiveWindowAreaInfo[$conAreaInfoHeight] -= 1
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)
EndFunc

Func ActiveWindowDecreaseHeightByOnePixelAndMoveDownOnePixel()
	Local $NewActiveWindowAreaInfo = WinGetPos("[ACTIVE]")
	$NewActiveWindowAreaInfo[$conAreaInfoHeight] -= 1
	$NewActiveWindowAreaInfo[$conAreaInfoY] += 1
	ActiveWindowMoveTo($NewActiveWindowAreaInfo)
EndFunc

Func ActiveWindowSetSizeBasedOnGrid($AvailableAreaInfo, $GridColumns, $GridRows, $GridColumnTilesSpan, $GridRowTilesSpan, ByRef $NewActiveWindowAreaInfo)
	$NewActiveWindowAreaInfo[$conAreaInfoWidth] = Round(($AvailableAreaInfo[$conAreaInfoWidth] * ($GridColumnTilesSpan / $GridColumns)) + 0.49999, 0)
	$NewActiveWindowAreaInfo[$conAreaInfoHeight] = Round(($AvailableAreaInfo[$conAreaInfoHeight] * ($GridRowTilesSpan / $GridRows)) + 0.49999, 0)
EndFunc

Func ActiveWindowSetWidthBasedOnAlignment($AvailableAreaInfo, $HorizontalAlignment, ByRef $NewActiveWindowAreaInfo)
	Switch $HorizontalAlignment
		Case $conAlignmentHorizontalLeft
			$NewActiveWindowAreaInfo[$conAreaInfoWidth] = $NewActiveWindowAreaInfo[$conAreaInfoWidth] + ($NewActiveWindowAreaInfo[$conAreaInfoX] - $AvailableAreaInfo[$conAreaInfoX])
		Case $conAlignmentHorizontalCentre
			$NewActiveWindowAreaInfo[$conAreaInfoWidth] = $AvailableAreaInfo[$conAreaInfoWidth]
		Case $conAlignmentHorizontalRight
			$NewActiveWindowAreaInfo[$conAreaInfoWidth] = $NewActiveWindowAreaInfo[$conAreaInfoWidth] + (($AvailableAreaInfo[$conAreaInfoX] + $AvailableAreaInfo[$conAreaInfoWidth]) - ($NewActiveWindowAreaInfo[$conAreaInfoX] + $NewActiveWindowAreaInfo[$conAreaInfoWidth]))
	EndSwitch
EndFunc

Func ActiveWindowSetHeightBasedOnAlignment($AvailableAreaInfo, $VerticalAlignment, ByRef $NewActiveWindowAreaInfo)
	Switch $VerticalAlignment
		Case $conAlignmentVerticalTop
			$NewActiveWindowAreaInfo[$conAreaInfoHeight] = $NewActiveWindowAreaInfo[$conAreaInfoHeight] + ($NewActiveWindowAreaInfo[$conAreaInfoY] - $AvailableAreaInfo[$conAreaInfoY])
		Case $conAlignmentVerticalCentre
			$NewActiveWindowAreaInfo[$conAreaInfoHeight] = $AvailableAreaInfo[$conAreaInfoHeight]
		Case $conAlignmentVerticalBottom
			$NewActiveWindowAreaInfo[$conAreaInfoHeight] = $NewActiveWindowAreaInfo[$conAreaInfoHeight] + (($AvailableAreaInfo[$conAreaInfoY] + $AvailableAreaInfo[$conAreaInfoHeight]) - ($NewActiveWindowAreaInfo[$conAreaInfoY] + $NewActiveWindowAreaInfo[$conAreaInfoHeight]))
	EndSwitch
EndFunc

Func ActiveWindowSetXBasedOnAlignment($AvailableAreaInfo, $HorizontalAlignment, ByRef $NewActiveWindowAreaInfo)
	Switch $HorizontalAlignment
		Case $conAlignmentHorizontalLeft
			$NewActiveWindowAreaInfo[$conAreaInfoX] = $AvailableAreaInfo[$conAreaInfoX]
		Case $conAlignmentHorizontalCentre
			$NewActiveWindowAreaInfo[$conAreaInfoX] = $AvailableAreaInfo[$conAreaInfoX] + (($AvailableAreaInfo[$conAreaInfoWidth] - $NewActiveWindowAreaInfo[$conAreaInfoWidth]) / 2)
		Case $conAlignmentHorizontalRight
			$NewActiveWindowAreaInfo[$conAreaInfoX] = $AvailableAreaInfo[$conAreaInfoX] + ($AvailableAreaInfo[$conAreaInfoWidth] - $NewActiveWindowAreaInfo[$conAreaInfoWidth])
	EndSwitch
EndFunc

Func ActiveWindowSetYBasedOnAlignment($AvailableAreaInfo, $VerticalAlignment, ByRef $NewActiveWindowAreaInfo)
	Switch $VerticalAlignment
		Case $conAlignmentVerticalTop
			$NewActiveWindowAreaInfo[$conAreaInfoY] = $AvailableAreaInfo[$conAreaInfoY]
		Case $conAlignmentVerticalCentre
			$NewActiveWindowAreaInfo[$conAreaInfoY] = $AvailableAreaInfo[$conAreaInfoY] + (($AvailableAreaInfo[$conAreaInfoHeight] - $NewActiveWindowAreaInfo[$conAreaInfoHeight]) / 2)
		Case $conAlignmentVerticalBottom
			$NewActiveWindowAreaInfo[$conAreaInfoY] = $AvailableAreaInfo[$conAreaInfoY] + ($AvailableAreaInfo[$conAreaInfoHeight] - $NewActiveWindowAreaInfo[$conAreaInfoHeight])
	EndSwitch
EndFunc

Func ActiveWindowMoveTo($NewActiveWindowAreaInfo)
	If BitAND(WinGetState("[ACTIVE]"), 16) Or BitAND(WinGetState("[ACTIVE]"), 32) Then ;16 = minimized 32=maximized
		WinSetState("[ACTIVE]", "", @SW_RESTORE)
	EndIf
	WinMove("[ACTIVE]", "", $NewActiveWindowAreaInfo[$conAreaInfoX], $NewActiveWindowAreaInfo[$conAreaInfoY], $NewActiveWindowAreaInfo[$conAreaInfoWidth], $NewActiveWindowAreaInfo[$conAreaInfoHeight])
EndFunc

Func ShowPositionAndSizeOnTooltip($ActiveWindowAreaInfo)
	Local $XPosition = $ActiveWindowAreaInfo[$conAreaInfoX]
	Local $YPosition = $ActiveWindowAreaInfo[$conAreaInfoY]
	If BitAND(WinGetState("[ACTIVE]"), 32) Then ;32=maximized
		$XPosition = $XPosition + 8
		$YPosition = $YPosition + 8
	EndIf
	ToolTip($ActiveWindowAreaInfo[$conAreaInfoWidth] & " x " & $ActiveWindowAreaInfo[$conAreaInfoHeight] & " @ " & $ActiveWindowAreaInfo[$conAreaInfoX] & "," & $ActiveWindowAreaInfo[$conAreaInfoY], $XPosition + ($ActiveWindowAreaInfo[$conAreaInfoWidth] / 2), $YPosition + 10, "", 0, 2)
    Sleep(2000)
	ToolTip("")
EndFunc