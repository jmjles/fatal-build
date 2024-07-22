import QtQuick 1.1
import CursorShape 1.0
import StandardToolTip 1.0

Rectangle {
    color: index == player.currentQuality ? "#d6d6d5" : hovered ? "#656565" : "transparent"
    height: chooseQuality.rowHeight
    width: parent.width
    visible: false
    property string name: "";
    property string bitrate: "";
    property bool hovered: false

    Text {
        text: parent.name + " " + parent.bitrate
        color: parent.index == player.currentQuality ? "#2b2b2b" : "#ffffff"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: parent.hovered = true;
        onExited: parent.hovered = false;
        onClicked: {
            if(parent.index != player.currentQuality)
                player.changeQuality(parent.index);
            panelMin.uninitQualityMenu();
        }
    }
}