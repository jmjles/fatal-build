import QtQuick 1.1
import CursorShape 1.0
import StandardToolTip 1.0

Image {
    width: 0
    visible: false
    height: panel.height;
    source: "panel/bg.png";
    property string name: "";
    property string bitrate: "";
    property bool hovered: false
    
    Rectangle {
        width: 1
        height: parent.height
        color: "#404040"
        anchors.left: parent.left
    }

    Text {
        text: parent.name
        color: parent.index == player.currentQuality ? "#00a691" : parent.hovered ? "#ffffff" : "#909090"
        font.pixelSize: 12
        anchors.top: parent.top
        anchors.topMargin: 1
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        text: parent.bitrate
        color: parent.index == player.currentQuality ? "#00a691" : parent.hovered ? "#ffffff" : "#909090"
        font.pixelSize: 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 1
        anchors.horizontalCenter: parent.horizontalCenter
    }

    MouseArea {
        hoverEnabled: true
        anchors.fill: parent
        onClicked: {
            root.uninitQualityMenu();
            if(parent.index != player.currentQuality)
                player.changeQuality(parent.index);
        }
        onEntered: parent.hovered = true
        onExited: parent.hovered = false
        CursorShapeArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
        }

        StandardToolTipObject {
            anchors.fill: parent
            text: parent.parent.name
        }
    }
}