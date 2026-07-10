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

    property bool pending: false

    function inhibit() {
        if (pending) return
        pending = true
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
        onNewData: function(sourceName, data) {
            var out = data["stdout"].trim()
            if (out.indexOf("uint32") !== -1) {
                root.cookie = out.replace(/.*uint32\s+(\d+).*/, "$1")
            }
            root.pending = false
            disconnectSource(sourceName)
        }
    }

    preferredRepresentation: compactRepresentation

causeDiagnosed uninitialized parent dimensions causing component sizing failureDiagnosed uninitialized parent dimensions causing component sizing failureThe single most likely root cause, given your actual code: compactRepresentation's outer Item has no explicit size, and Plasma doesn't automatically size it for you.
qmlcompactRepresentation: Item {
    Kirigami.Icon {
        anchors.centerIn: parent
        width: parent.height
        height: parent.height
PlasmoidItem.compactRepresentation needs the Item to declare Layout.minimumWidth/Layout.minimumHeight (or Layout.preferredWidth/Height) so the panel's layout system knows how big to make it. You never set these. So on first layout pass, parent.height for your Kirigami.Icon can resolve to 0.
That cascades directly into your warning:

Item has no layout hints → panel gives it height: 0 (or an undefined/transient size) on the first paint.
Kirigami.Icon.height and .width are both bound to that 0.
Kirigami.Icon's internal Image/QQuickImage tries to build a scene graph node for a zero-size image.
The SVG image provider either skips creating a texture or creates one with invalid dimensions.
The scene graph calls updateSampledImage() expecting a texture, gets null back → the warning you saw.

This is a very common pattern with hand-rolled compactRepresentation in Plasma 6 — people assume the panel sizes the root Item automatically the way it sizes the applet icon by convention, but it doesn't unless you tell it to.
Fix:
qmlcompactRepresentation: Item {
    Layout.minimumWidth: Kirigami.Units.iconSizes.small
    Layout.minimumHeight: Kirigami.Units.iconSizes.small
    Layout.preferredWidth: height
    Layout.preferredHeight: parent ? parent.height : Kirigami.Units.iconSizes.small

    Kirigami.Icon {
        anchors.fill: parent
        source: root.toggled ? root.iconOn() : root.iconOff()
    }
    MouseArea { anchors.fill: parent; /* ... */ }
}
This is very likely your actual cause — the path-resolution issue I mentioned earlier is a secondary possibility, but a sizing bug producing a 0×0 icon is the more common trigger for this specific warning text.zach@solomon:~/Projects/kaffeine$ qt.qml.propertyCache.append: Member visible of the object PlasmaQuick::Dialog overrides a member of the base object. Consider renaming it or adding final or override specifier
qt.qml.propertyCache.append: Member enabled of the object DeclarativeDropArea overrides a member of the base object. Consider renaming it or adding final or override specifier
Connecting to deprecated signal QDBusConnectionInterface::serviceOwnerChanged(QString,QString,QString)Distinguished framework warnings from core issuesDistinguished framework warnings from core issuesThose three lines aren't your bug — they're standard Plasma/Qt framework noise that shows up for basically every plasmoid run through plasmoidviewer or a full Plasma session:

qt.qml.propertyCache.append: Member visible ... overrides a member of the base object — this is from Plasma's own internal QML/C++ (PlasmaQuick::Dialog, DeclarativeDropArea), not your code. It's a known cosmetic warning in Plasma 6's frameworks where their C++ classes redeclare a QML property name that clashes with a QQuickItem base property (visible, enabled). Harmless, and not something you can fix from your plasmoid.
Connecting to deprecated signal QDBusConnectionInterface::serviceOwnerChanged — also framework-side, some internal Plasma component still using the old D-Bus signal. Not yours either.

None of these three relate to updateSampledImage() or your icon. They'll appear in the log regardless of whether your plasmoid works correctly.
Question back to you: did the actual No QSGTexture provided from updateSampledImage() warning still appear in this run, or did fixing the sizing (or whatever you changed) make it go away? If it's still showing up, paste the exact console output around where it fires — specifically I want to see if there's a companion line just before/after it, like an SVG parse error, an image provider "cannot open" message, or a file:// path that looks wrong. That'll confirm whether it's the sizing issue or the path issue.idk how to fix sizingFormulated concrete solution for sizing convention problemsFormulated concrete solution for sizing convention problemsNo worries — here's the concrete, minimal fix. In Plasma 6, compactRepresentation's root item needs Layout.* size hints because the panel (or desktop) places it inside a layout it controls; without those hints, the item can start at 0×0.
Replace your compactRepresentation block with this:
qmlcompactRepresentation: Item {
    Layout.minimumWidth: Kirigami.Units.iconSizes.small
    Layout.minimumHeight: Kirigami.Units.iconSizes.small
    Layout.preferredWidth: Kirigami.Units.iconSizes.medium
    Layout.preferredHeight: Kirigami.Units.iconSizes.medium

    Kirigami.Icon {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.smallSpacing
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

compactRepresentation: Item {
    Layout.minimumWidth: Kirigami.Units.iconSizes.small
    Layout.minimumHeight: Kirigami.Units.iconSizes.small
    Layout.preferredWidth: Kirigami.Units.iconSizes.medium
    Layout.preferredHeight: Kirigami.Units.iconSizes.medium

    Component.onCompleted: {
        console.log("resolved icon path:", root.toggled ? root.iconOn() : root.iconOff())
    }

    Kirigami.Icon {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.smallSpacing
        source: root.toggled ? root.iconOn() : root.iconOff()
        onStatusChanged: console.log("icon status:", status) // Image.Ready=1, Loading=2, Error=3
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
                source: root.toggled ? root.iconOn() : root.iconOff()
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