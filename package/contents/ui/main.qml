import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.plasma5support 2.0 as P5Support

PlasmoidItem {
    id: root

    property bool toggled: false
    property string cookie: ""
        property bool isDark: Kirigami.Theme.backgroundColor.hslLightness < 0.5

    function iconOn() {
        return isDark
            ? Qt.resolvedUrl("../icons/coffee-dark-on.svg")
            : Qt.resolvedUrl("../icons/coffee-on.svg")
    }

    function iconOff() {
        return isDark
            ? Qt.resolvedUrl("../icons/coffee-dark-off.svg")
            : Qt.resolvedUrl("../icons/coffee-off.svg")
    }

    function inhibit() {
        executable.exec("dbus-send --session --print-reply --dest=org.freedesktop.ScreenSaver /ScreenSaver org.freedesktop.ScreenSaver.Inhibit string:Kaffeine string:'User requested screen stay awake' 2>/dev/null")
    }

    function uninhibit() {
        if (cookie !== "") {
            executable.exec("dbus-send --session --dest=org.freedesktop.ScreenSaver /ScreenSaver org.freedesktop.ScreenSaver.UnInhibit uint32:" + cookie + " >/dev/null 2>&1")
            cookie = ""
        }
    }

    Component.onCompleted: {
        root.toggled = false
    }

    P5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        function exec(cmd) {
            connectSource(cmd)
        }
        onNewData: function(source, data) {
            var out = data["stdout"].trim()
            if (out.indexOf("uint32") !== -1) {
                root.cookie = out.replace(/.*uint32\s+(\d+).*/, "$1")
            }
            disconnectSource(source)
        }
    }

    preferredRepresentation: compactRepresentation

    compactRepresentation: Item {
        Kirigami.Icon {
            anchors.centerIn: parent
            width: parent.height
            height: parent.height
            source: root.toggled ? root.iconOn() : root.iconOff()
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.toggled = !root.toggled
                if (root.toggled) {
                    root.inhibit()
                } else {
                    root.uninhibit()
                }
            }
        }
    }

    fullRepresentation: Item {
        width: 300
        height: 200
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 16
            Kirigami.Icon {
                Layout.alignment: Qt.AlignHCenter
                width: 64
                height: 64
                source: root.toggled
                    ? Qt.resolvedUrl("../icons/coffee-dark-on.svg")
                    : Qt.resolvedUrl("../icons/coffee-dark-off.svg")
            }
            PlasmaComponents.Label {
                Layout.alignment: Qt.AlignHCenter
                text: root.toggled ? "Screen awake" : "Screen sleep on"
                font.pixelSize: 18
                font.bold: true
                color: root.toggled ? Kirigami.Theme.textColor : "#c0392b"
            }
            PlasmaComponents.Button {
                Layout.alignment: Qt.AlignHCenter
                text: root.toggled ? "Allow sleep" : "Keep awake"
                onClicked: {
                    root.toggled = !root.toggled
                    if (root.toggled) {
                        root.inhibit()
                    } else {
                        root.uninhibit()
                    }
                }
            }
        }
    }
}