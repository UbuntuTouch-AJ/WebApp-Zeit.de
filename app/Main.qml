import QtQuick 2.9
import Ubuntu.Components 1.3
import QtQuick.Window 2.2
import Morph.Web 0.1
import "Buttons"
import QtWebEngine 1.7
import Qt.labs.settings 1.0
import QtSystemInfo 5.5

MainView {
  id:window
  objectName: "mainView"
  theme.name: "Ubuntu.Components.Themes.SuruDark"

  applicationName: "zeit"


  backgroundColor : "#ffffff"





  WebView {
    id: webview
    anchors{ fill: parent}

    enableSelectOverride: true


    settings.fullScreenSupportEnabled: true
    property var currentWebview: webview
    settings.pluginsEnabled: true

    onFullScreenRequested: function(request) {
      nav.visible = !nav.visible
      request.accept();
    }



    profile:  WebEngineProfile{
      id: webContext
      persistentCookiesPolicy: WebEngineProfile.ForcePersistentCookies
      property alias dataPath: webContext.persistentStoragePath

      dataPath: dataLocation



      httpUserAgent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.106 Safari/537.36"
    }

    anchors{
      fill:parent
    }

    url: "https://www.zeit.de/"
    userScripts: [
      WebEngineScript {
        injectionPoint: WebEngineScript.DocumentReady
        worldId: WebEngineScript.MainWorld
        name: "QWebChannel"
        sourceUrl: "ubuntutheme.js"
      }
    ]


  }
  RadialBottomEdge {
    id: nav
    visible: true
    actions: [

    RadialAction {
      id: start
      iconSource: Qt.resolvedUrl("icons/home.svg")
      onTriggered: {
        webview.url = "https://www.zeit.de"
      }
      text: qsTr("Start")
      },
      RadialAction {
        id: wissen
        iconSource: Qt.resolvedUrl("icons/wissen.svg")
        onTriggered: {
          webview.url = "https://www.zeit.de/wissen/"
        }
        text: qsTr("Wissen")
      },
      RadialAction {
        id: forward
        enabled: webview.canGoForward
        iconName: "go-next"
        onTriggered: {
          webview.goForward()
        }
        text: qsTr("Vorwärts")
      },
      RadialAction {
        id: sport
        iconSource: Qt.resolvedUrl("icons/sport.svg")
        onTriggered: {
          webview.url = "https://www.zeit.de/sport/"
        }
        text: qsTr("Sport")
      },
      RadialAction {
        id: wirtschaft
        iconSource: Qt.resolvedUrl("icons/wirtschaft.svg")
        onTriggered: {
          webview.url = "https://www.zeit.de/wirtschaft/"
        }
        text: qsTr("Wirtschaft")
      },
      RadialAction {
        id: kultur
        iconSource: Qt.resolvedUrl("icons/kultur.svg")
        onTriggered: {
          webview.url = "https://www.zeit.de/kultur/"
        }
        text: qsTr("Kultur")
      },
      RadialAction {
        id: back
        enabled: webview.canGoBack
        iconName: "go-previous"
        onTriggered: {
          webview.goBack()
        }
        text: qsTr("Zurück")
      },
      RadialAction {
        id: politik
        iconSource: Qt.resolvedUrl("icons/politik.png")
        onTriggered: {
          webview.url = "https://www.zeit.de/politik/"
        }
        text: qsTr("Politik")

      }
    ]
  }

  Connections {
    target: Qt.inputMethod
    onVisibleChanged: nav.visible = !nav.visible
  }

  Connections {
    target: webview

    onIsFullScreenChanged: {
      window.setFullscreen()
      if (currentWebview.isFullScreen) {
        nav.state = "hidden"
      }
      else {
        nav.state = "shown"
      }
    }

  }

  Connections {
    target: webview

    onIsFullScreenChanged: window.setFullscreen(webview.isFullScreen)
  }
  function setFullscreen(fullscreen) {
    if (!window.forceFullscreen) {
      if (fullscreen) {
        if (window.visibility != Window.FullScreen) {
          internal.currentWindowState = window.visibility
          window.visibility = 5
        }
      } else {
        window.visibility = internal.currentWindowState
        //window.currentWebview.fullscreen = false
        //window.currentWebview.fullscreen = false
      }
    }
  }

  Connections {
    target: UriHandler

    onOpened: {

      if (uris.length > 0) {
        console.log('Incoming call from UriHandler ' + uris[0]);
        webview.url = uris[0];
      }
    }
  }



  ScreenSaver {
    id: screenSaver
    screenSaverEnabled: !(Qt.application.active) || !webview.recentlyAudible
  }
}
