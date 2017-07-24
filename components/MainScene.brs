' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

sub init()
    m.top.SetFocus(true)
    
    m.get_channel_list = m.top.FindNode("get_channel_list")
    m.get_channel_list.ObserveField("content", "SetContent")
    
    m.list = m.top.FindNode("list")
    m.list.ObserveField("itemSelected", "setChannel")
    
    m.video = m.top.FindNode("Video")
    m.video.ObserveField("state", "checkState")
End sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    
    if(press)
        if(key = "right")
            m.list.SetFocus(false)
            m.top.SetFocus(true)
            m.video.translation = [0, 0]
            m.video.width = 0
            m.video.height = 0
            result = true
        else if(key = "left")
            m.list.SetFocus(true)
            m.video.translation = [900, 100]
            m.video.width = 960
            m.video.height = 540
            result = true
        end if
    end if
    
    return result 
end function

sub checkState()
    print m.video.state
    if(m.video.state = "error")
        print m.video.Errormsg
    end if
end sub

sub SetContent()
    m.list.content = m.get_channel_list.content
    m.list.SetFocus(true)
end sub

sub setChannel()
    con = m.list.content.getChild(m.list.itemSelected)
    print con.url
    con.streamFormat = "hls"
    m.video.content = con
    m.video.control = "play"
end sub
