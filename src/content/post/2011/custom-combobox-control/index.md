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

<pre class="csharpcode"><code><span class="rem">// based on http://www.logresource.com/Question/1080206/showall/</span>
<span class="kwrd">internal</span> <span class="kwrd">class</span> PopupComboBox : ComboBox, IMessageFilter
{
    <span class="rem">// http://www.woodmann.com/fravia/sources/WINUSER.H</span>
    <span class="kwrd">const</span> <span class="kwrd">int</span> WM_KEYDOWN = 0x0100;
    <span class="kwrd">const</span> <span class="kwrd">int</span> WM_SYSKEYDOWN = 0x0104;
    <span class="kwrd">const</span> <span class="kwrd">int</span> WM_LBUTTONDOWN = 0x0201;
    <span class="kwrd">const</span> <span class="kwrd">int</span> WM_LBUTTONDBLCLK = 0x0203;

    <span class="kwrd">const</span> <span class="kwrd">int</span> VK_UP = 0x26;
    <span class="kwrd">const</span> <span class="kwrd">int</span> VK_DOWN = 0x28;
    <span class="kwrd">const</span> <span class="kwrd">int</span> VK_ESC = 0x1b;

    <span class="kwrd">readonly</span> Form m_containerForm = <span class="kwrd">new</span> Form()
    {
        FormBorderStyle = FormBorderStyle.FixedToolWindow,
        ShowInTaskbar = <span class="kwrd">false</span>,
        ControlBox = <span class="kwrd">false</span>,
        StartPosition = FormStartPosition.Manual,
    };
    Control m_popupControl;

    <span class="kwrd">public</span> PopupComboBox()
    {
        Items.Add(<span class="kwrd">string</span>.Empty);
        SelectedIndex = 0;
        DropDownStyle = ComboBoxStyle.DropDownList;
        m_containerForm.Deactivate += (sender, e) =&gt; HideUserControl();
    }        

    [Browsable(<span class="kwrd">false</span>)]
    [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
    [Localizable(<span class="kwrd">false</span>)]
    <span class="kwrd">public</span> <span class="kwrd">new</span> ComboBox.ObjectCollection Items <span class="rem">// hide from serializer</span>
    {
        get { <span class="kwrd">return</span> <span class="kwrd">base</span>.Items; }
    }

    <span class="kwrd">public</span> Control PopupControl
    {
        get
        {
            <span class="kwrd">return</span> m_popupControl;
        }
        set
        {
            <span class="kwrd">if</span> (m_popupControl != <span class="kwrd">null</span>)
            {
                m_popupControl.Parent = <span class="kwrd">null</span>;
            }
            m_popupControl = <span class="kwrd">value</span>;
            <span class="kwrd">if</span> (m_popupControl != <span class="kwrd">null</span>)
            {
                m_popupControl.Dock = DockStyle.Fill;
                m_containerForm.Controls.Add(m_popupControl);
            }
        }
    }

    <span class="kwrd">protected</span> <span class="kwrd">override</span> <span class="kwrd">void</span> WndProc(<span class="kwrd">ref</span> Message m)
    {
        <span class="kwrd">if</span> (PopupControl == <span class="kwrd">null</span>)
            <span class="kwrd">base</span>.WndProc(<span class="kwrd">ref</span> m);
        <span class="kwrd">if</span> ((m.Msg == WM_LBUTTONDOWN) || (m.Msg == WM_LBUTTONDBLCLK))
        {
            <span class="kwrd">if</span> (DroppedDown)
                HideUserControl();
            <span class="kwrd">else</span>
                ShowUserControl();
        }
        <span class="kwrd">else</span> <span class="kwrd">if</span> (m.WParam.ToInt32() == VK_DOWN <span class="rem">// DOWN KEY PRESSED</span>
                &amp;&amp; (m.Msg == WM_SYSKEYDOWN
                &amp;&amp; m.LParam.ToInt32() == 0x21500001
                || m.Msg == WM_KEYDOWN
                &amp;&amp; m.LParam.ToInt32() == 0x1500001)
            )
        {
            <span class="kwrd">if</span> (!DroppedDown)
                ShowUserControl();
        }                  
        <span class="kwrd">else</span>
        {
            <span class="kwrd">base</span>.WndProc(<span class="kwrd">ref</span> m);
        }
    }

    <span class="kwrd">public</span> <span class="kwrd">bool</span> PreFilterMessage(<span class="kwrd">ref</span> Message m)
    {
        <span class="kwrd">if</span> (PopupControl == <span class="kwrd">null</span>)
            <span class="kwrd">return</span> <span class="kwrd">false</span>;
        <span class="rem">// intercept ESC key or ALT+UP</span>
        <span class="kwrd">else</span> <span class="kwrd">if</span> (m.Msg == WM_KEYDOWN
            &amp;&amp; m.WParam.ToInt32() == VK_ESC
            &amp;&amp; m.LParam.ToInt32() == 0x10001                
            || m.Msg == WM_SYSKEYDOWN
            &amp;&amp; m.WParam.ToInt32() == VK_UP
            &amp;&amp; m.LParam.ToInt32() == 0x21480001)
        {
            HideUserControl();
            <span class="kwrd">return</span> <span class="kwrd">true</span>;
        }                            
        <span class="kwrd">else</span>
        {
            <span class="kwrd">return</span> <span class="kwrd">false</span>;
        }
    }

    <span class="kwrd">protected</span> <span class="kwrd">virtual</span> <span class="kwrd">void</span> ShowUserControl()
    {
        <span class="kwrd">if</span> (!Visible || m_containerForm.Visible)
            <span class="kwrd">return</span>;           
        m_containerForm.BackColor = BackColor;
        m_containerForm.Font = Font;
        m_containerForm.ForeColor = ForeColor;
        m_containerForm.Bounds = <span class="kwrd">new</span> Rectangle(
            Parent.PointToScreen(<span class="kwrd">new</span> Point(Left, Bottom)),
            <span class="kwrd">new</span> Size(Math.Max(PopupControl.Width, Width), PopupControl.Height));
        m_containerForm.Show(<span class="kwrd">this</span>);
        OnDropDown(EventArgs.Empty);
        Application.AddMessageFilter(<span class="kwrd">this</span>);<span class="rem">// start listening for clicks</span>
    }

    <span class="kwrd">protected</span> <span class="kwrd">virtual</span> <span class="kwrd">void</span> HideUserControl()
    {
        <span class="kwrd">if</span> (!m_containerForm.Visible)
            <span class="kwrd">return</span>;
        Application.RemoveMessageFilter(<span class="kwrd">this</span>);
        OnDropDownClosed(EventArgs.Empty);
        m_containerForm.Hide();
        Items[0] = PopupControl.Text;
        Focus();
    }

    <span class="kwrd">protected</span> <span class="kwrd">override</span> <span class="kwrd">void</span> Dispose(<span class="kwrd">bool</span> disposing)
    {
        <span class="kwrd">if</span> (disposing &amp;&amp; PopupControl != <span class="kwrd">null</span>)
        {
            m_containerForm.Dispose();
        }
        <span class="kwrd">base</span>.Dispose(disposing);
    }
}</code></pre>

