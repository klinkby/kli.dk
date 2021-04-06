---
author: Mads Klinkby
categories:
- .net
date: "2011-07-17T22:00:00Z"
description: ""
draft: false
slug: custom-combobox-control
tags:
- .net
title: Custom DropDown Control
---


Extensibility is not the strongest feature of Windows Forms. I recently required a custom drop down control like the common color picker or date picker control. I started out with [http://www.logresource.com/Question/1080206/showall/](http://www.logresource.com/Question/1080206/showall/) and modified it to properly handle usercontrols and keyboard control.  

```C#
// based on http://www.logresource.com/Question/1080206/showall/
internal class PopupComboBox : ComboBox, IMessageFilter
{
    // http://www.woodmann.com/fravia/sources/WINUSER.H
    const int WM_KEYDOWN = 0x0100;
    const int WM_SYSKEYDOWN = 0x0104;
    const int WM_LBUTTONDOWN = 0x0201;
    const int WM_LBUTTONDBLCLK = 0x0203;

    const int VK_UP = 0x26;
    const int VK_DOWN = 0x28;
    const int VK_ESC = 0x1b;

    readonly Form m_containerForm = new Form()
    {
        FormBorderStyle = FormBorderStyle.FixedToolWindow,
        ShowInTaskbar = false,
        ControlBox = false,
        StartPosition = FormStartPosition.Manual,
    };
    Control m_popupControl;

    public PopupComboBox()
    {
        Items.Add(string.Empty);
        SelectedIndex = 0;
        DropDownStyle = ComboBoxStyle.DropDownList;
        m_containerForm.Deactivate += (sender, e) => HideUserControl();
    }        

    [Browsable(false)]
    [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
    [Localizable(false)]
    public new ComboBox.ObjectCollection Items // hide from serializer
    {
        get { return base.Items; }
    }

    public Control PopupControl
    {
        get
        {
            return m_popupControl;
        }
        set
        {
            if (m_popupControl != null)
            {
                m_popupControl.Parent = null;
            }
            m_popupControl = value;
            if (m_popupControl != null)
            {
                m_popupControl.Dock = DockStyle.Fill;
                m_containerForm.Controls.Add(m_popupControl);
            }
        }
    }

    protected override void WndProc(ref Message m)
    {
        if (PopupControl == null)
            base.WndProc(ref m);
        if ((m.Msg == WM_LBUTTONDOWN) || (m.Msg == WM_LBUTTONDBLCLK))
        {
            if (DroppedDown)
                HideUserControl();
            else
                ShowUserControl();
        }
        else if (m.WParam.ToInt32() == VK_DOWN // DOWN KEY PRESSED
                && (m.Msg == WM_SYSKEYDOWN
                && m.LParam.ToInt32() == 0x21500001
                || m.Msg == WM_KEYDOWN
                && m.LParam.ToInt32() == 0x1500001)
            )
        {
            if (!DroppedDown)
                ShowUserControl();
        }                  
        else
        {
            base.WndProc(ref m);
        }
    }

    public bool PreFilterMessage(ref Message m)
    {
        if (PopupControl == null)
            return false;
        // intercept ESC key or ALT+UP
        else if (m.Msg == WM_KEYDOWN
            && m.WParam.ToInt32() == VK_ESC
            && m.LParam.ToInt32() == 0x10001                
            || m.Msg == WM_SYSKEYDOWN
            && m.WParam.ToInt32() == VK_UP
            && m.LParam.ToInt32() == 0x21480001)
        {
            HideUserControl();
            return true;
        }                            
        else
        {
            return false;
        }
    }

    protected virtual void ShowUserControl()
    {
        if (!Visible || m_containerForm.Visible)
            return;           
        m_containerForm.BackColor = BackColor;
        m_containerForm.Font = Font;
        m_containerForm.ForeColor = ForeColor;
        m_containerForm.Bounds = new Rectangle(
            Parent.PointToScreen(new Point(Left, Bottom)),
            new Size(Math.Max(PopupControl.Width, Width), PopupControl.Height));
        m_containerForm.Show(this);
        OnDropDown(EventArgs.Empty);
        Application.AddMessageFilter(this);// start listening for clicks
    }

    protected virtual void HideUserControl()
    {
        if (!m_containerForm.Visible)
            return;
        Application.RemoveMessageFilter(this);
        OnDropDownClosed(EventArgs.Empty);
        m_containerForm.Hide();
        Items[0] = PopupControl.Text;
        Focus();
    }

    protected override void Dispose(bool disposing)
    {
        if (disposing && PopupControl != null)
        {
            m_containerForm.Dispose();
        }
        base.Dispose(disposing);
    }
}
```

