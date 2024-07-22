import QtQuick 1.1
import CursorShape 1.0
import StandardToolTip 1.0

Rectangle {
    color: streamIndex == player.hls_streams_current ? "#d6d6d5" : hovered ? "#656565" : "transparent"
    height: chooseHlsStream.rowHeight
    width: parent.width
    visible: false
    property string streamName: "";
    property int streamIndex: -1;
    property bool hovered: false

    Text {
        text: parent.streamName
        color: parent.streamIndex == player.hls_streams_current ? "#2b2b2b" : "#ffffff"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: parent.hovered = true;
        onExited: parent.hovered = false;
        onClicked: {
            if(parent.streamIndex != player.hls_streams_current) {
                player.setHlsStream(parent.streamIndex);
            }
            panel.uninitHlsStreamsMenu();
        }
    }
}