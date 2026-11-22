NotifyQoL(title, text := "") {
    static osdGui := 0, titleCtrl := 0, textCtrl := 0

    if !osdGui {
        osdGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
        osdGui.BackColor := "18181b"
        osdGui.MarginX := 16
        osdGui.MarginY := 12
        osdGui.SetFont("s10 bold cffffff", "Segoe UI")
        titleCtrl := osdGui.AddText("w280", "")
        osdGui.SetFont("s9 norm ca1a1aa", "Segoe UI")
        textCtrl := osdGui.AddText("w280 yp+22", "")
        DllCall("dwmapi\DwmSetWindowAttribute", "ptr", osdGui.Hwnd, "uint", 33, "int*", 2, "uint", 4)
    }

    SetTimer(Dismiss, 0)
    titleCtrl.Value := title
    textCtrl.Value := text
    textCtrl.Visible := (text != "")

    osdGui.Show("AutoSize Hide")
    osdGui.GetPos(, , &w, &h)
    MonitorGetWorkArea(, &waLeft, &waTop, &waRight, &waBottom)
    x := waRight - w - 24
    y := waBottom - h - 24
    osdGui.Show("x" x " y" y " NoActivate")
    SetTimer(Dismiss, -2200)

    Dismiss() {
        if osdGui
            osdGui.Hide()
    }
}
