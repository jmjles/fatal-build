import QtQuick 1.1
import CursorShape 1.0
import StandardToolTip 1.0

/* DoubleStateButton.qml */
Image {
    id: button
    smooth: true
    signal clicked()

    /* pixmaps for placing on button */
    property variant pixmaps: {
        'default1': "",         /* image source for state1 default */
        'hovered1': "",         /* image source for state1 hovered */
        'default2': "",         /* image source for state2 default */
        'hovered2': ""          /* image source for state2 hovered */
    }
    /* condition=false - state 1, true - state 2 */
    property bool condition: false
    property variant tooltips: {
        '1': "",
        '2': ""
    }
    property bool containsMouse: buttonArea.containsMouse

    states: [
        State {
            when: !buttonArea.containsMouse && !condition
            PropertyChanges { target: button; source: pixmaps['default1'] }
        },
        State {
            when: buttonArea.containsMouse && !condition
            PropertyChanges { target: button; source: pixmaps['hovered1'] }
        },
        State {
            when: !buttonArea.containsMouse && condition
            PropertyChanges { target: button; source: pixmaps['default2'] }
        },
        State {
            when: buttonArea.containsMouse && condition
            PropertyChanges { target: button; source: pixmaps['hovered2'] }
        }
    ]

    StandardToolTipObject {
        id: standardToolTip
    }

    MouseArea {
        id: buttonArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: button.clicked()
        onEntered: standardToolTip.showToolTip(button.mapToItem( null, mouseX, mouseY ).x, button.mapToItem( null, mouseX, mouseY ).y, condition ? button.tooltips['2'] : button.tooltips['1'])
        onExited: standardToolTip.hideToolTip()

        CursorShapeArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
        }
    }
}
