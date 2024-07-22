import QtQuick 1.1
import CursorShape 1.0
import StandardToolTip 1.0

Image {
        width: 0
        visible: false
        height: panel.height;
        source: "panel/bg.png";
        property string streamName: "";
        property int streamIndex: -1;
        property bool hovered: false

        Rectangle {
            width: 1
            height: parent.height
            color: "#404040"
            anchors.left: parent.left
        }

        Text {
            text: parent.streamName
            color: parent.streamIndex == player.hls_streams_current ? "#00a691" : parent.hovered ? "#ffffff" : "#909090"
            font.pixelSize: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            hoverEnabled: true
            anchors.fill: parent
            onClicked: {
                root.uninitHlsStreamsMenu();
                if(parent.streamIndex != player.hls_streams_current) {
                    player.setHlsStream(parent.streamIndex);
                }
            }
            onEntered: parent.hovered = true
            onExited: parent.hovered = false
            CursorShapeArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
            }

            StandardToolTipObject {
                anchors.fill: parent
                text: parent.parent.streamName
            }
        }
    }