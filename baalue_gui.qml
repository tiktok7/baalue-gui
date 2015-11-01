import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtWebKit 3.0
import io.thp.pyotherside 1.4

ApplicationWindow {
    title: qsTr("Baalue Control Panel")
    width: 640
    height: 480

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: messageDialog.show(qsTr("Open action triggered"));
            }
            MenuItem {
                text: qsTr("E&xit")
                onTriggered: Qt.quit();
            }
        }
    }

    toolBar:ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                iconSource: "pics/Gnome-document-new.svg"
                onClicked: messageDialog.show(qsTr("Button 1 pressed"))
            }
            ToolButton {
                iconSource: "pics/Gnome-document-open.svg"
            }
            ToolButton {
                iconSource: "pics/Gnome-document-save.svg"
            }

            ToolButton {
                iconSource: "pics/Gnome-go-previous.svg"
                enabled: webview.canGoBack
                onClicked: webview.goBack()
            }

            ToolButton {
                iconSource: "pics/Gnome-go-home.svg"
                onClicked: py.load_doc('/home/will/Projects/c/baalue_sdk/Documentation/howto_sdcard.md')
            }

            ToolButton {
                iconSource: "pics/Gnome-go-next.svg"
                enabled: webview.canGoForward
                onClicked: webview.goForward()
            }

            Item { Layout.fillWidth: true }
            CheckBox {
                text: "Enabled"
                checked: true
                Layout.alignment: Qt.AlignRight
            }
        }
    }

    MainForm {
        anchors.fill: parent
        //        button1.onClicked: messageDialog.show(qsTr("Button 1 pressed"))
        //        button2.onClicked: messageDialog.show(qsTr("Button 2 pressed"))
        //        button3.onClicked: messageDialog.show(qsTr("Button 3 pressed"))
        ScrollView {
            anchors.fill: parent
            verticalScrollBarPolicy: Qt.ScrollBarAsNeeded
            horizontalScrollBarPolicy: Qt.ScrollBarAsNeeded

            WebView {
                id: webview
                url: ""
                anchors.fill: parent

                function load_html(base_path, html) {
                    loadHtml(html);
                }

                onNavigationRequested: {
                    console.log('navtype:' + request.navigationType);
                    console.log('requested:' + request.url);
                    // detect URL scheme prefix, most likely an external link
                    var schemaRE = /^\w+:/;
                    if (schemaRE.test(request.url)) {
                        request.action = WebView.AcceptRequest;
                    } else {
                        request.action = WebView.IgnoreRequest;
                        py.load_doc(request.url)
                        // delegate request.url here
                    }
                }
            }
        }
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("May I have your attention, please?")

        function show(caption) {
            messageDialog.text = caption;
            messageDialog.open();
        }
    }

    // Pyotherside python object that we use to talk to all of plainbox
    Python {
        id: py

        function init() {
            console.log("Pyotherside version " + pluginVersion());
            console.log("Python version " + pythonVersion());
            // A bit hacky but that's where the python code is
            addImportPath(Qt.resolvedUrl('py/'));
            // Import path for plainbox and potentially other python libraries
            addImportPath(Qt.resolvedUrl('lib/py'))
            //setHandler('command_output', commandOutputPage.addText);
            initiated();
        }

        function load_doc(filename) {
            call('docgen.docgen', [filename], function(html) {
                console.log('filename: ' + filename);
                webview.load_html('', html);
            });
        }

        function chdir(path) {
            call('os.chdir', [path], function() {});
        }

        // gets triggered when python object is ready to be used
        signal initiated

        onError: {
            console.error("python error: " + traceback);
            //ErrorLogic.showError(mainView, "python error: " + traceback, Qt.quit);
        }
        onReceived: console.log("pyotherside.send: " + data)

        Component.onCompleted: {
            importModule('docgen', function(){});
            importModule('os.path', function(){});
            importModule('os', function() {
                call('os.getcwd', [], function (result) {
                    console.log('Working directory: ' + result);
                });
            });
            py.init();
        }
    }



}
