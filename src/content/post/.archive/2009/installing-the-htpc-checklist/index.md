---
author: "@klinkby"
keywords:
- dotnet
- gadgets
- microsoft
- technology
date: "2009-01-02T23:00:00Z"
description: ""
draft: false
slug: installing-the-htpc-checklist
tags:
- dotnet
- gadgets
- microsoft
- technology
title: Installing the HTPC, checklist
---


<div>Here's a checklist I came up with while reinstalling my HTPC:</div>  

1. Install Vista (I use x64 and manually sliced the disk in
   a [ 40GB boot partition](http://www.microsoft.com/windows/windows-vista/get/system-requirements.aspx), and left the
   rest for a data/recordings partition).
2. Allow automatic weekly updates (
   on [ Wednesday at 03:00](http://www.microsoft.com/protect/computer/updates/bulletins/default.mspx)).
3. Install your network.
4. Upgrade to latest BIOS (you might wanna skip this).
5. Uncheck all components in "Control Panel, Programs, Turn Windows Features On or Off".
6. Install your chipset driver (I installed
   the [ Intel package](http://downloadcenter.intel.com/Detail_Desc.aspx?agr=Y&DwnldId=16026&lang=eng)).
7. Download and
   install [ SP1](http://www.microsoft.com/downloads/details.aspx?familyid=F559842A-9C9B-4579-B64A-09146A0BA746&displaylang=en) (
   choose x86 or x64 and your installed language).
8. When finished, run [vsp1cln.exe](http://technet.microsoft.com/en-us/library/cc709655.aspx) to clean up after SP1
   installation.
9. Start Windows Update and install all important updates.
10. If you have a 2GB 150x USB stick or better, plug it in and configure 512MB
    for [ReadyBoost](http://kli.dk/2007/05/27/readyboost-monitor-gadget/), and use the rest for timeshifting in your
    Media Center application.
11. Right click Computer, then "Manage, Configuration, Services". Set to disabled startup and stop the following
    services, that is [useless on an HTPC](http://tweakhound.com/vista/tweakguide/page_8.htm):

1. DFS Replication
2. Diagnostic Policy Service*(change to manual)*
3. Distributed Link Tracking Client
4. IKE and AuthIP IPsec Keying Modules
5. IPsec Policy Agent
6. KtmRm for Distributed Transaction Coordinator
7. Offline Files
8. Remote Registry
9. Tablet PC Input Service
10. Windows Error Reporting Service
11. Windows Search
12. Download and install graphics drivers (I installed
    ATI's[ Driver Only](http://game.amd.com/us-en/drivers_catalyst.aspx?p=vista64/common-vista64)option)13. Download and
                                                                                                            install TV
                                                                                                            tuner
                                                                                                            drivers (I
                                                                                                            installed
                                                                                                            Hauppauge's [Driver Only](http://www.wintvcd.co.uk/drivers/88x_2_122_26109_WHQL.zip)
                                                                                                            option).
14. Configure your sound card and select your speaker setup. Note Vista comes with a
    cool[ room correction](http://game.amd.com/us-en/drivers_catalyst.aspx?p=vista64/common-vista64)feature you can take
    advantage of if you have a surround sound setup and a microphone.
15. Download and install[Haali's MetroskaSplitter](http://haali.cs.msu.ru/mkv/)to support .mkv files (free).
16. Download and install[AC3Filter](http://ac3filter.net/project/1/releases)to support surround sound streams(free).
17. Open" Programs, AC3Filter, Configuration" and select your speaker setup.
18. Download and install[Cyberlink PowerDVD Ultra 8](http://www.cyberlink.com/multi/products/main_1_ENU.html)to support
    HD content (commercial app, trial).
19. Click "Control Panel, Add or Remove User Accounts". Create a standard user with a password, and allow auto logon.
    Supply the user/password you just created.
20. Restart.
21. In the bottom of the Welcome page, uncheck the "Always show..."
22. Right click desktop then "Properties, Display Settings", then adjust the resolution to match you flat panel screen,
    typically 1366 x 768 or 1920 x 1080.
23. Update Windows Experience Index by right click Computer, then "Properties, Windows Experience Index",24. Vista Home
                                                                                                             does not
                                                                                                             include
                                                                                                             Terminal
                                                                                                             Services.
                                                                                                             But you can
                                                                                                             install [Mesh](http://www.mesh.com)
                                                                                                             and connect
                                                                                                             the box to
                                                                                                             your mesh,
                                                                                                             to enable
                                                                                                             it.
25. If you have [DVB-C](http://en.wikipedia.org/wiki/DVB-C) (cable) or [DVB-S](http://en.wikipedia.org/wiki/DVB-S) (
    satellite), you cannot use Windows Media Center as it only supports [DVB-T (t](http://en.wikipedia.org/wiki/DVB-T)
    errestrial):

1. Download and install [DVBViewer Pro](http://www.dvbviewer.com/)(commercial app, no trial available).
2. Launch DVBViewer's options and check fullscreen, always on top and configure your hardware devices and directx
   filters. Choose the EVR renderer to enable [ DXVA2](http://msdn.microsoft.com/en-us/library/cc307941(VS.85).aspx).
3. [ Download and install EventGhost](http://sourceforge.net/project/showfiles.php?group_id=145751) to support remote
   control,
   and [ this eventghost configuration](http://www.dvbviewer.info/forum/index.php?s=6457e4a60ee22d8f3062d4b2854d9df9&act=attach&type=post&id=15688).4.
Add EventGhost to Startup folder.5. Launch EventGhost and load the configuration.6. Add an action to the Autostart event
                                                                                    of type "System, Start Application",
                                                                                    executable: "taskkill",
                                                                                    parameters: "/f /im ehtray.exe" to
                                                                                    prevent Windows Media Center from
                                                                                    stealing the remote control
                                                                                    commands. If you have no keyboard
                                                                                    connected and you are an absolute
                                                                                    purist, you could also add "
                                                                                    taskkill", "/f /im explorer.exe" to
                                                                                    shut down the Windows Explorer and
                                                                                    free up extra resources.
26. Activate Windows.
27. Enjoy!

