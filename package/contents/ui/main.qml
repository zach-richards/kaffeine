import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami 2.20 as Kirigami

PlasmoidItem {
    id: root

    property bool toggled: false

    // Run systemctl to mask/unmask sleep on toggle
    function setSleep(enable) {
        if (enable) {
            sleepProcess.command = ["pkexec", "systemctl", "unmask",
                "sleep.target", "suspend.target",
                "hibernate.target", "hybrid-sleep.target"]
        } else {
            sleepProcess.command = ["pkexec", "systemctl", "mask",
                "sleep.target", "suspend.target",
                "hibernate.target", "hybrid-sleep.target"]
        }
        sleepProcess.start()
    }

    // Check current state on load
    Component.onCompleted: checkProcess.start()

    QtObject {
        id: sleepProcess
        property var command: []
        property bool running: false

        function start() {
            executable.exec(command.join(" "))
        }
    }

    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []

        function exec(cmd) {
            connectSource(cmd)
        }

        onNewData: function(source, data) {
            disconnectSource(source)
        }
    }

    // Check if sleep is currently masked
    PlasmaCore.DataSource {
        id: checkProcess
        engine: "executable"
        connectedSources: []

        function start() {
            exec("systemctl is-enabled sleep.target 2>/dev/null || echo masked")
        }

        function exec(cmd) {
            connectSource(cmd)
        }

        onNewData: function(source, data) {
            var out = data["stdout"].trim()
            root.toggled = (out !== "masked")
            disconnectSource(source)
        }
    }

    preferredRepresentation: compactRepresentation

    compactRepresentation: Item {
        Kirigami.Icon {
            anchors.centerIn: parent
            width: parent.height
            height: parent.height
            source: root.toggled
                ? Qt.resolvedUrl("../icons/icon-on.svg")
                : Qt.resolvedUrl("../icons/icon-off.svg")
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.toggled = !root.toggled
                root.setSleep(root.toggled)
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
                    ? Qt.resolvedUrl("../icons/icon-on.svg")
                    : Qt.resolvedUrl("../icons/icon-off.svg")
            }

            PlasmaComponents.Label {
                Layout.alignment: Qt.AlignHCenter
                text: root.toggled ? "Sleep: Enabled" : "Sleep: Disabled"
                font.pixelSize: 18
                font.bold: true
                color: root.toggled ? Kirigami.Theme.textColor : "#c0392b"
            }

            PlasmaComponents.Button {
                Layout.alignment: Qt.AlignHCenter
                text: root.toggled ? "Disable Sleep" : "Enable Sleep"
                onClicked: {
                    root.toggled = !root.toggled
                    root.setSleep(root.toggled)
                }
            }
        }
    }
}