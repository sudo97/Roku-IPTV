' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

sub init()
    
   showdialog()
'    m.top.SetFocus(true)

    m.save_feed_url = m.top.FindNode("save_feed_url")
 '   m.get_channel_list.ObserveField("content", "SetContent")
    
    m.get_channel_list = m.top.FindNode("get_channel_list")
    m.get_channel_list.ObserveField("content", "SetContent")
    
    m.list = m.top.FindNode("list")
    m.list.ObserveField("itemSelected", "setChannel")
    
    m.video = m.top.FindNode("Video")
    m.video.ObserveField("state", "checkState")
End sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    
    if(press)'
    
    print "KEY PRESSED IS >>>> "; key
    
        if(key = "right")
            m.list.SetFocus(false)
            m.top.SetFocus(true)
            m.video.translation = [0, 0]
            m.video.width = 0
            m.video.height = 0
            result = true
        else if(key = "left")
            m.list.SetFocus(true)
            m.video.translation = [800, 100]
            m.video.width = 960
            m.video.height = 540
            result = true
        end if
    end if
    
    return result 
end function

sub checkState()
    state = m.Video.state
    print "Video player state is now: " + state

    if(state = "error")
        print "ERROR - Code " + m.Video.errorCode.ToStr() + ", Message: " + m.Video.errorMsg
    end if
end sub

sub SetContent()
    m.list.content = m.get_channel_list.content
    m.list.SetFocus(true)
end sub

sub setChannel()
    con = m.list.content.getChild(m.list.itemSelected)
'   print "Title of STream is >>>>>>>>  "; con.title
'   print "URL FOR STREAM IS >>>>>>>>>  "; con.url
    
content = createObject("RoSGNode","ContentNode")
content.streamFormat = "hls"
content.title = con.title
content.description = con.description
print "URL FOR  STREAM IS >>>>>>>>>";con.url
' content.url = "http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8"
 content.url = con.url
 print "http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8"
 print con.url
 content.HttpSendClientCertificates = true
 content.HttpCertificatesFile = "common:/certs/ca-bundle.crt"
 m.video.EnableCookies()
 m.video.SetCertificatesFile("common:/certs/ca-bundle.crt")
 m.video.InitClientCertificates()

m.video.content = content


' m.videoPlayer.control = "play"

   m.video.control = "play"
     
end sub

sub showdialog()

PRINT "ENTERING KEYBOARD ************************"


  keyboarddialog = createObject("roSGNode", "KeyboardDialog")
  keyboarddialog.backgroundUri = "pkg:/images/rsgde_dlg_bg_hd.9.png"
  keyboarddialog.title = "Enter .m3u URL"

  keyboarddialog.buttons=["OK","CANCEL"]
  keyboarddialog.optionsDialog=true
 

  m.top.dialog = keyboarddialog
'  m.top.dialog.text = "https://pastebin.com/raw/vVBSHpNq"
   m.top.dialog.text = m.global.feedurl
 
 KeyboardDialog.observeField("buttonSelected","onKeyPress")
' KeyboardDialog.observeField("buttonSelected","onKeyPressCancel")
end sub

function onKeyPress()
    print " button is"m.top.dialog.buttonSelected
    print "m.value:::>>"m.top.dialog.text
    if m.top.dialog.buttonSelected = 0
    print "OK"
    url = m.top.dialog.text
    print "THE ENTERED FEEDURL IS"; url
'    m.global.addFields( {feedurl: url } )
     m.global.feedurl = url
    print "THE NEW GLOBAL FEEDURL IS"; m.global.feedurl
    m.save_feed_url.control = "RUN"
    
'    m.top.dialog.visible ="false"
    m.top.unobserveField("buttonSelected")
    m.top.dialog.close = true
    m.get_channel_list.control = "RUN"
    
    end if
    if m.top.dialog.buttonSelected = 1
    print "CANCEL"
'    m.top.dialog.visible ="false"
'    m.top.unobserveField("buttonSelected")
    m.top.dialog.close = true
    end if
    
end Function

