sub init()
    m.top.functionName = "getContent"
end sub

sub getContent()
    searchRequest = CreateObject("roUrlTransfer")
    print "requesting"
    searchRequest.SetUrl("https://www.youtube.com/get_video_info?&video_id="+ m.top.VideoId+ "&el=info&ps=default&eurl=&gl=US&hl=en")
    text = "HELLO WORLD"
    print text
    text = searchRequest.getToString()
    print text
end sub