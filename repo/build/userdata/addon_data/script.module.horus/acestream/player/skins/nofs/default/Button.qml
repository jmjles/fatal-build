import QtQuick 1.1
import CursorShape 1.0
import StandardToolTip 1.0

/* Button.qml */
Image {
    id: button
    smooth: true
    signal clicked()
    signal pressed()
    signal released()

    /* pixmaps for placing on button */
    property variant pixmaps: {
        'default': "",      /* image source for default state */
        'hovered': ""       /* image source for hovered state */
    }
    property string tooltip: ""

    states: [
        State {
            when: !buttonArea.containsMouse
            PropertyChanges { target: button; source: pixmaps['default'] }
        },
        State {
            when: buttonArea.containsMouse
            PropertyChanges { target: button; source: pixmaps['hovered'] }
        }
    ]

    MouseArea {
        id: buttonArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: button.clicked()
        onPressed: button.pressed()
        onReleased: button.released()

        CursorShapeArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
        }

        StandardToolTipObject {
            anchors.fill: parent
            text: button.tooltip
        }
    }
}
