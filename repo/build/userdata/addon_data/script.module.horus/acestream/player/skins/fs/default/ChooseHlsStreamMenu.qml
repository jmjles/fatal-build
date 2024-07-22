import QtQuick 1.1
import CursorShape 1.0
import StandardToolTip 1.0

Item {
    id: chooseHlsStream
    width: Math.floor(centralArea.height * 0.9583)
    height: hlsSelectorBottom.height + hlsSelectorMiddle.height + hlsSelectorTop.height - chooseHlsStream.rowSpacing //Math.floor(width * 1.057971) //146
    y: buttons_row.y - height
    x: buttons_row.x + hls_streams_area.x + hls_streams_area.width / 2 - width / 2
    smooth: true
    visible: false

    property int rowHeight : Math.floor(chooseHlsStream.width * 0.130435)
    property int rowWidth : Math.floor(chooseHlsStream.width * 0.826087)
    property int rowSpacing : Math.floor(chooseHlsStream.width * 0.039855)

    property int spacing : Math.floor(chooseHlsStream.width * 0.123188)
    property int itemsCount : 10

    function showItem(index, streamName, streamIndex) {
        hlsStreamsList.children[index].streamName = streamName;
        hlsStreamsList.children[index].streamIndex = streamIndex;
        hlsStreamsList.children[index].visible = true;
        hlsStreamsList.children[index].hovered = false;
    }

    function hideItem(index) {
        hlsStreamsList.children[index].hovered = false;
        hlsStreamsList.children[index].visible = false;
    }

    Image {
        id: hlsSelectorTop
        source: root.imgPath + "q-top.png"
        width: parent.width
        anchors.bottom: hlsSelectorMiddle.top
        opacity: 0.9
    }
    Image {
        id: hlsSelectorMiddle
        source: root.imgPath + "q-middle.png"
        width: parent.width
        height: hlsStreamsList.height + hlsSelectorTitle.height + 2 * chooseHlsStream.spacing //chooseHlsStream.height - hlsSelectorTop.height - hlsSelectorBottom.height
        anchors.bottom: hlsSelectorBottom.top //y: hlsSelectorTop.height
        fillMode: Image.TileVertically
        opacity: 0.9
    }
    Image {
        id: hlsSelectorBottom
        source: root.imgPath + "q-bottom.png"
        width: parent.width
        anchors.bottom: parent.bottom
        opacity: 0.9
    }

    Rectangle {
        id: hlsSelectorTitle
        color: "#2f2f2f"
        height: chooseHlsStream.rowHeight
        width: chooseHlsStream.rowWidth
        y: Math.floor(chooseHlsStream.width * 0.043478)
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: hlsSelectorTitleText
            text: root.translate("Selected stream")
            color: "#d5d5d5"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Column {
        id: hlsStreamsList
        width: chooseHlsStream.rowWidth
        anchors.horizontalCenter: parent.horizontalCenter
        y: hlsSelectorTitle.y + hlsSelectorTitle.height + chooseHlsStream.spacing
        spacing: chooseHlsStream.rowSpacing

        ChooseHlsStreamMenuItem {
            property int index: 0;
        }
        ChooseHlsStreamMenuItem {
            property int index: 1;
        }
        ChooseHlsStreamMenuItem {
            property int index: 2;
        }
        ChooseHlsStreamMenuItem {
            property int index: 3;
        }
        ChooseHlsStreamMenuItem {
            property int index: 4;
        }
        ChooseHlsStreamMenuItem {
            property int index: 5;
        }
        ChooseHlsStreamMenuItem {
            property int index: 6;
        }
        ChooseHlsStreamMenuItem {
            property int index: 7;
        }
        ChooseHlsStreamMenuItem {
            property int index: 8;
        }
        ChooseHlsStreamMenuItem {
            property int index: 9;
        }

    }
}