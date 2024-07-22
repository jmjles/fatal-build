import QtQuick 1.1
import CursorShape 1.0
import StandardToolTip 1.0

Item {
    id: chooseQuality
    width: Math.floor(centralArea.height * 0.9583)
    height: qBottom.height + qMiddle.height + qTop.height - chooseQuality.rowSpacing //Math.floor(width * 1.057971) //146
    y: buttons_row.y - height
    x: buttons_row.x + quality_area.x + quality_area.width / 2 - width / 2
    smooth: true
    visible: false

    property int rowHeight : Math.floor(chooseQuality.width * 0.130435)
    property int rowWidth : Math.floor(chooseQuality.width * 0.826087)
    property int rowSpacing : Math.floor(chooseQuality.width * 0.039855)

    property int spacing : Math.floor(chooseQuality.width * 0.123188)
    property int itemsCount : 5
    
    function showItem(i, name, bitrate) {
        qList.children[i].name = name;
        qList.children[i].bitrate = bitrate;
        qList.children[i].visible = true;
        qList.children[i].hovered = false;
    }
    
    function hideItem(i) {
        qList.children[i].hovered = false;
        qList.children[i].visible = false;
    }

    Image {
        id: qTop
        source: root.imgPath + "q-top.png"
        width: parent.width
        anchors.bottom: qMiddle.top
        opacity: 0.9
    }
    Image {
        id: qMiddle
        source: root.imgPath + "q-middle.png"
        width: parent.width
        height: qList.height + qTitle.height + 2 * chooseQuality.spacing //chooseQuality.height - qTop.height - qBottom.height
        anchors.bottom: qBottom.top //y: qTop.height
        fillMode: Image.TileVertically
        opacity: 0.9
    }
    Image {
        id: qBottom
        source: root.imgPath + "q-bottom.png"
        width: parent.width
        anchors.bottom: parent.bottom
        opacity: 0.9
    }

    Rectangle {
        id: qTitle
        color: "#2f2f2f"
        height: chooseQuality.rowHeight
        width: chooseQuality.rowWidth
        y: Math.floor(chooseQuality.width * 0.043478)
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: qTitleText
            text: root.translate("Quality")
            color: "#d5d5d5"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Column {
        id: qList
        width: chooseQuality.rowWidth
        anchors.horizontalCenter: parent.horizontalCenter
        y: qTitle.y + qTitle.height + chooseQuality.spacing
        spacing: chooseQuality.rowSpacing

        ChooseQualityMenuItem {
            property int index: 0;
        }
        ChooseQualityMenuItem {
            property int index: 1;
        }
        ChooseQualityMenuItem {
            property int index: 2;
        }
        ChooseQualityMenuItem {
            property int index: 3;
        }
        ChooseQualityMenuItem {
            property int index: 4;
        }

    }
}