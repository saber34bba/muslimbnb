import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return _MyHomePage();
   }

}

class _MyHomePage extends State<MyHomePage>{
  WebViewController _controller;

  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();
  bool isLoading=true;
  bool showImage=true;
  @override
  Widget build(BuildContext context) {
     return WillPopScope(
            onWillPop: () => _goBack(context),

       child: Scaffold(
         body:SafeArea(
           child: Stack(children: [
            WebView(
              
            initialUrl: "https://muslimbnb.fr/",
            javascriptMode: JavascriptMode.unrestricted,
             gestureNavigationEnabled: true,
              userAgent: "random",
              backgroundColor:Colors.white ,
           onWebViewCreated: (WebViewController webViewController) {
          _controllerCompleter.future.then((value) => _controller = value);
          _controllerCompleter.complete(webViewController);
        },
          onPageFinished: (finish) {
                  setState(() {
                    isLoading = false;
                    showImage=false;
                  });
                },
                navigationDelegate: (NavigationRequest request) async {
                setState(() {
                  isLoading=true;
                  showImage=false;
                });
                    if (request.url
                        .startsWith('https://api.whatsapp.com/send?phone')) {
                      List<String> urlSplitted = request.url.split("&text=");
                      String phone = "33467405747";
                      String message =
                          urlSplitted.last.toString().replaceAll("%20", " ");
                    
                      await _launchURL(
                          "https://wa.me/$phone/?text=}");
                      return NavigationDecision.prevent;
                    }
     
                    print('allowing navigation to $request');
                    return NavigationDecision.navigate;
                  },
           ),
         isLoading && showImage? Center( child: Column(children: [
          Expanded(child: Container()),
         Image.asset("assets/logo.jpg",fit: BoxFit.cover,
          width:150,
           
          ),
          SizedBox(height: 30,),
          CircularProgressIndicator(color: Color(0xff287FF5),
          strokeWidth: 2,
          ),
              Expanded(child: Container()),
         ]),):
          /*isLoading? Center( child: Container(
          color: Colors.white,
          height: 80,
          width: 80,
          padding: EdgeInsets.all(16),
            child: Column(children: [
            Expanded(child: Container()),
          
            CircularProgressIndicator(color: Color(0xff287FF5),
            strokeWidth: 2,
            ),
                Expanded(child: Container()),
                 ]),
          ),)
                        :*/ Container(),
           
           ],),
         )
       ),
     );
  
  }




Future<bool> _goBack(BuildContext context)async
{ if (await _controller.canGoBack()) {
      _controller.goBack();
      
      return Future.value(false);
    } 
  return Future.value(true);

}
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


}