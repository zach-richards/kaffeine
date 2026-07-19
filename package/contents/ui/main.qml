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
    property bool pending: false

    readonly property url iconOn: isDark
        ? Qt.resolvedUrl("../icons/kaffeine-dark-on.svg")
        : Qt.resolvedUrl("../icons/kaffeine-on.svg")

    readonly property url iconOff: isDark
        ? Qt.resolvedUrl("../icons/kaffeine-dark-off.svg")
        : Qt.resolvedUrl("../icons/kaffeine-off.svg")

    property bool inhibiting: false
    property int inhibitPid: -1

    // General-purpose one-off command runner (logging only)
    P5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []

        onNewData: (sourceName, data) => {
            console.log("stdout:", data["stdout"], "stderr:", data["stderr"])
            disconnectSource(sourceName)
        }

        function exec(cmd) {
            connectSource(cmd)
        }
    }

    // Captures the PID of the backgrounded systemd-inhibit process
    P5Support.DataSource {
        id: pidSource
        engine: "executable"
        connectedSources: []

        onNewData: (sourceName, data) => {
            var stdout = data["stdout"].toString().trim()
            var pid = parseInt(stdout)
            if (!isNaN(pid)) {
                inhibitPid = pid
                console.log("inhibit script pid:", inhibitPid)
            } else {
                console.log("failed to parse pid from:", stdout)
            }
            disconnectSource(sourceName)
        }
    }

    // Fires the kill command
    P5Support.DataSource {
        id: killSource
        engine: "executable"
        connectedSources: []

        onNewData: (sourceName, data) => {
            console.log("kill result:", data["stdout"], data["stderr"])
            disconnectSource(sourceName)
        }
    }

    function startInhibit() {
        if (inhibiting) return
        pidSource.connectSource(
            'sh -c \'systemd-inhibit --what=handle-lid-switch:sleep:idle --who="kaffeine" --why="Kaffeine toggled" sleep infinity & echo $!\''
        )
        inhibiting = true
    }

    function stopInhibit() {
        if (!inhibiting || inhibitPid <= 0) return
        killSource.connectSource('kill -TERM ' + inhibitPid)
        inhibiting = false
        inhibitPid = -1
    }

    Component.onCompleted: {
        console.log("KAFFEINE APPLET LOADED")
        root.toggled = false
    }

    Component.onDestruction: {
        stopInhibit()
    }

    preferredRepresentation: compactRepresentation

    compactRepresentation: Item {
        Layout.minimumWidth: Kirigami.Units.iconSizes.small
        Layout.minimumHeight: Kirigami.Units.iconSizes.small
        Layout.preferredWidth: Kirigami.Units.iconSizes.medium
        Layout.preferredHeight: Kirigami.Units.iconSizes.medium

        Kirigami.Icon {
            anchors.fill: parent
            anchors.margins: Kirigami.Units.smallSpacing
            source: root.toggled ? root.iconOn : root.iconOff
            opacity: root.pending ? 0.5 : 1.0
        }

        TapHandler {
            enabled: !root.pending
            onTapped: {
                console.log("TAPHANDLER TAPPED")
                root.toggled = !root.toggled
                if (root.toggled) {
                    root.startInhibit()
                } else {
                    root.stopInhibit()
                }
            }
        }
    }

    fullRepresentation: Item {
        Layout.preferredWidth: 300
        Layout.preferredHeight: 200

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 16

            Kirigami.Icon {
                Layout.alignment: Qt.AlignHCenter
                width: 64
                height: 64
                source: root.toggled ? root.iconOn : root.iconOff
                opacity: root.pending ? 0.5 : 1.0
            }

            PlasmaComponents.Label {
                Layout.alignment: Qt.AlignHCenter
                text: root.toggled ? "Screen awake" : "Screen sleep on"
                font.pixelSize: Kirigami.Theme.defaultFont.pixelSize * 1.2
                font.bold: true
                color: root.toggled ? Kirigami.Theme.textColor : Kirigami.Theme.negativeTextColor
            }

            PlasmaComponents.Button {
                Layout.alignment: Qt.AlignHCenter
                enabled: !root.pending
                text: root.toggled ? "Allow sleep" : "Keep awake"
                onClicked: {
                    console.log("CLICK FIRED")
                    root.toggled = !root.toggled
                    if (root.toggled) {
                        root.startInhibit()
                    } else {
                        root.stopInhibit()
                    }
                }
            }
        }
    }
}
