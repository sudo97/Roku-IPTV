sub init()
    m.top.functionName = "getContent"
end sub

' **********************************************

sub getContent()
    feedurl = m.global.feedurl

    m.port = CreateObject ("roMessagePort")
    searchRequest = CreateObject("roUrlTransfer")
    searchRequest.setURL(feedurl)
    searchRequest.EnableEncodings(true)
    https = "https:"
    if LCase(Left(feedurl, Len(https))) = https
        searchRequest.SetCertificatesFile ("common:/certs/ca-bundle.crt")
        searchRequest.AddHeader ("X-Roku-Reserved-Dev-Id", "")
        searchRequest.InitClientCertificates ()
    end if


    text = searchRequest.getToString()
    print "recieved text";

    reLineSplit = CreateObject ("roRegex", "(?>\r\n|[\r\n])", "")
    reExtinf = CreateObject ("roRegex", "(?i)^#EXTINF:\s*(\d+|-1|-0).*,\s*(.*)$", "")
    rePath = CreateObject ("roRegex", "^([^#].*)$", "")
    inExtinf = false
    con = CreateObject("roSGNode", "ContentNode")

    for each line in reLineSplit.Split (text)
        if inExtinf
            maPath = rePath.Match (line)
            if maPath.Count () = 2
            item = con.CreateChild("ContentNode")
            item.url = maPath [1]
            item.title = title

            inExtinf = False
            end if
        end if
        maExtinf = reExtinf.Match (line)
        if maExtinf.Count () = 3
            length = maExtinf[1].ToInt ()
            if length < 0 then length = 0
            title = maExtinf[2]
            inExtinf = True
        end if
    end for

    m.top.content = con
end sub