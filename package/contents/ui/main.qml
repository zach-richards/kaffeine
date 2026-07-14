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

    function inhibit() {
        console.log("running test")
        executable.exec("echo hello")
    }

    /*function inhibit() {
        if (pending) return
        pending = true
        console.log("calling inhibit")
        executable.exec("qdbus org.kde.Solid.PowerManagement /org/kde/Solid/PowerManagement/PolicyAgent org.kde.Solid.PowerManagement.PolicyAgent.AddInhibition 1 'sleep-inhibit-plasmoid' 'Manual toggle'")
    }*/

    function uninhibit() {
        if (pending) return
        if (cookie !== "") {
            pending = true
            executable.exec("qdbus org.kde.Solid.PowerManagement /org/kde/Solid/PowerManagement/PolicyAgent org.kde.Solid.PowerManagement.PolicyAgent.ReleaseInhibition " + cookie)
        }
    }

    Component.onCompleted: {
        console.log("KAFFEINE APPLET LOADED")
        root.toggled = false
    }

    P5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        function exec(cmd) {
            connectSource(cmd)
        }
        onNewData: function(sourceName, data) {
            console.log("stdout:", data["stdout"])
            console.log("stderr:", data["stderr"])
            var out = data["stdout"].trim()

            if (root.toggled && root.cookie === "") {
                // This was an inhibit call awaiting a cookie
                var match = out.match(/\d+/)
                if (match) {
                    root.cookie = match[0]
                    console.log("parsed cookie:", root.cookie)
                } else {
                    console.log("No cookie returned")
                    root.toggled = false
                }
            } else {
                // This was a release call
                console.log("inhibition released")
                root.cookie = ""
            }

            root.pending = false
            disconnectSource(sourceName)
        }
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
                    root.inhibit()
                } else {
                    root.uninhibit()
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
                        root.inhibit()
                    } else {
                        root.uninhibit()
                    }
                }
            }
        }
    }
}
