function FindProxyForURL(url, host) {
    // Your proxy server name and port
    var proxyserver = '192.168.50.100:3128';
    //
    //  Here's a list of hosts to connect via the PROXY server
    //
    //var rawFile=new XMLHttpRequest();
    //rawFile.open('GET', '/vagrant/proxy_for', false);
    //rawFile.onreadystatechange = function()
    //{
    //    if(rawFile.readyState === 4)
    //    {
    //        if(rawFile.status === 200 || rawFile.status == 0)
    //        {
    //            var proxyList = new Array(rawFile.responseText);
    //        }
    //    }
    //}
    var proxyList = new Array(
        "*.oraclecorp.com",
        "*.oracle.com"
    );
    // Return our proxy name for matched domains/hosts
    for(var i=0; i<proxyList.length; i++) {
        var value = proxyList[i];
        if ( localHostOrDomainIs(host, value) ) {
            return "PROXY "+proxyserver;
        }
    }
    return "DIRECT";
}

