import QtQuick 1.1
import CursorShape 1.0
import Translator 1.0
import StandardToolTip 1.0

/* playlist.qml */
Rectangle {
    id: root
    width: 640
    height: 357
    color: "#404040"

    /* translator */
    TranslatorObject {
        id: translator
    }
    function translate(val) { return translator.translate(val); }

    Item {
        id: playerstates
        property int playing: 0
        property int paused: 1
        property int prebuffering: 2
        property int stopped: 3
        property int fullstopped: 4
    }
    
    /* header */
    Rectangle {
        id: header
        y: Math.floor(parent.width * 0.01)
        height: 23
        anchors.left: parent.left
        anchors.leftMargin: Math.floor(parent.width * 0.017)
        anchors.right: parent.right
        anchors.rightMargin: Math.floor(parent.width * 0.0125) * 2 + 31
        color: "#343434"

        /* loader */
        Item {
            id: loader
            width: 35
            height: parent.height

            AnimatedImage {
                anchors.centerIn: parent
                source: "playlist/loader.png"
                smooth: true
            }
        }

        /* separator */
        Rectangle {
            x: loader.width
            width: 1
            height: parent.height
            color: "#3c3b3b"
        }

        /* title */
        Item {
            id: titleHeader
            height: parent.height
            anchors.left: parent.left
            anchors.leftMargin: loader.width + 1
            anchors.right: parent.right
            anchors.rightMargin: buttonsHeader.width + 1

            Text {
                x: Math.floor(header.width * 0.07)
                anchors.verticalCenter: parent.verticalCenter
                text: root.translate("Title")
                font.pixelSize: Math.floor(parent.height * 0.4324)
                color: "#d5d5d5"
                smooth: true
            }
        }

        /* separator */
        Rectangle {
            x: titleHeader.x + titleHeader.width
            width: 1
            height: parent.height
            color: "#3c3b3b"
        }

        /* buttons */
        Item {
            id: buttonsHeader
            width: 144
            height: parent.height
            anchors.right: parent.right

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: root.translate("Actions")
                font.pixelSize: Math.floor(parent.height * 0.4324)
                color: "#d5d5d5"
                smooth: true
            }
        }
    }

    /* close button */
    Rectangle {
        id: btnClose
        y: Math.floor(parent.width * 0.01)
        width: 31
        height: header.height
        anchors.right: parent.right
        anchors.rightMargin: Math.floor(parent.width * 0.0125)
        color: "#2f2f2f"

        Image {
            anchors.fill: parent
            source: "playlist/close-btn.png"
            smooth: true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: player.togglePlaylist()
            CursorShapeArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
            }

            StandardToolTipObject {
                anchors.fill: parent
                text: "Close"
            }
        }
    }

    /* playlist */
    Item {
        id: list
        width: header.width + btnClose.width + Math.floor(parent.width * 0.0125)
        anchors.top: parent.top
        anchors.topMargin: header.y + header.height + listView.rowSpacing * 2
        height: listView.rowHeight * listVisibleItems
        anchors.left: parent.left
        anchors.leftMargin: Math.floor(parent.width * 0.017)
        property int listVisibleItems: (btnSelectHolder.y - listView.rowSpacing * 2 - y) / listView.rowHeight

        /* playlist view */
        ListView {
            id: listView
            model: playlistModel
            delegate: listViewDelegate
            anchors.fill: parent
            boundsBehavior: Flickable.StopAtBounds
            snapMode: ListView.SnapToItem
            clip:true
            
            property int rowHeight: 32
            property int rowSpacing: 8
            property int dragIndex: -1
            property int dropIndex: -1
            property int xToDrop: -1
            property int yToDrop: -1
            property int dragDirection: 0
            
            /* drop position indicator */
            Rectangle {
                id: listViewDropIndicator
                height: 2
                width: header.width
                color: "#e5e5e5"
                visible: false

                states: [
                    State {
                        when: listView.dropIndex != -1 && listView.dragDirection != 0
                        PropertyChanges {
                            target: listViewDropIndicator
                            visible: true
                            x: Math.floor(listView.xToDrop / listView.width) * listView.width
                            y: (listView.dragDirection == 1)
                               ? Math.floor(listView.yToDrop / listView.rowHeight) * listView.rowHeight + listView.rowHeight - 1
                               : Math.floor(listView.yToDrop / listView.rowHeight) * listView.rowHeight - 1
                        }
                    }
                ]
            }
            
             /* draged item template */
            Rectangle {
                id: listViewDragContainer
                z: 2
                x: 0//loader.width + 14 + dragArea.mouseX - width/2
                y: dragArea.mouseY - height/2
                width: header.width
                height: listView.rowHeight - listView.rowSpacing
                color: "#e5e5e5"
                opacity: 0.5
                visible: listView.dragIndex != -1
                
                property string dragTitle: ''
                property string dragActiveSource: ''
                property string dragActionSource: ''
                property string dragSaveSource: ''
                property bool dragActive: false

                /* active checkbox */
                Item {
                    width: loader.width
                    height: parent.height
                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: listViewDragContainer.dragActiveSource
                        smooth: true
                    }
                }
                /* title */
                Item {
                    x: loader.width + 14
                    width: titleHeader.width - 28
                    height: parent.height
                    clip: true
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: listViewDragContainer.dragTitle
                        font.pixelSize: 12
                        color: "#2f2f2f"
                        smooth: true
                    }
                }
                /* action button */
                Item {
                    x: buttonsHeader.x
                    width: buttonsHeader.width
                    height: parent.height
                    visible: listViewDragContainer.dragActive

                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: listViewDragContainer.dragActionSource
                        smooth: true
                    }

                    /* save button */
                    Item {
                        height: parent.height
                        width: Math.floor(height * 1.333)
                        anchors.right: parent.right
                        visible: listViewDragContainer.dragSaveSource!=''

                        Image {
                            anchors.fill: parent
                            source: listViewDragContainer.dragSaveSource
                            smooth:  true
                        }
                    }
                }
            }
            
            /* timer for scrolling while dragging */
            Timer {
                id: wheelTimer
                interval: 500;
                running: false;
                repeat: true;

                onTriggered: {
                    if(listView.dragDirection == -1)
                        listView.positionViewAtIndex(listView.dropIndex - 1, ListView.Beginning)
                    else if(listView.dragDirection == 1)
                        listView.positionViewAtIndex(listView.dropIndex + 1, ListView.End)
                    dragArea.resync()
                }
            }
            
            /* drag area */
            MouseArea {
                id: dragArea
                x: loader.width + 14
                width: titleHeader.width - 28
                height: parent.height

                CursorShapeArea {
                    anchors.fill: parent
                    cursorShape: listView.dragIndex == -1 ? Qt.OpenHandCursor : Qt.ClosedHandCursor
                }

                function resync() {
                    if(listView.dragIndex != -1) {
                        var newPos = listView.indexAt(mouseX, mouseY + listView.contentY)
                        if (newPos !== listView.dropIndex && newPos !== -1) {
                            listView.dragDirection = newPos > listView.dragIndex ? 1 : newPos < listView.dragIndex ? -1 : 0
                            listView.dropIndex = newPos
                            listView.xToDrop = mouseX
                            listView.yToDrop = mouseY

                            if((listView.dropIndex === listView.indexAt(0,listView.contentY) && listView.dropIndex != 0)
                                    || (listView.dropIndex === listView.indexAt(0,listView.contentY+listView.height-1) && listView.dropIndex != listView.count-1)){
                                if(!wheelTimer.running)
                                    wheelTimer.start()
                            }
                            else {
                                if(wheelTimer.running)
                                    wheelTimer.stop()
                            }
                        }
                    }
                    else {
                        if(wheelTimer.running)
                            wheelTimer.stop()
                    }
                }

                onPressed: {
                    if(listView.dragIndex == -1) {
                        listView.dragIndex = listView.dropIndex = listView.indexAt(mouseX, mouseY + listView.contentY)
                        listView.positionViewAtIndex(listView.indexAt(0, listView.contentY), ListView.Beginning)
                        listView.interactive = false
                        listView.xToDrop = mouseX
                        listView.yToDrop = mouseY

                        if(listView.dropIndex === listView.indexAt(0,listView.contentY) && listView.dropIndex != 0) {
                            listView.dragDirection = -1
                            wheelTimer.start()
                        }
                        else if(listView.dropIndex === listView.indexAt(0,listView.contentY+listView.height-1) && listView.dropIndex != listView.count-1) {
                            listView.dragDirection = 1
                            wheelTimer.start()
                        }
                    }
                }
                onPositionChanged: {
                    resync()
                }
                onReleased: {
                    if (listView.dragIndex != -1) {
                        if(listView.dragIndex != listView.dropIndex && listView.dropIndex != -1)
                            player.moveItem(listView.dragIndex, listView.dropIndex)
                        if(listView.dropIndex == 0)
                            listView.positionViewAtIndex(listView.dropIndex, ListView.Beginning)
                        else if(listView.dropIndex == listView.count-1)
                            listView.positionViewAtIndex(listView.dropIndex, ListView.End)
                        listView.dragIndex = -1
                        listView.dropIndex = -1
                        listView.dragDirection = 0
                        if(wheelTimer.running)
                            wheelTimer.stop()
                    }
                    listView.interactive = true
                }
            }
        }

         /* playlist item view */
        Component {
            id: listViewDelegate

            Item {
                id: row
                width: header.width
                height: listView.rowHeight

                Item {
                    id: rowViewWrapper
                    width: parent.width
                    height: parent.height - listView.rowSpacing
                    anchors.verticalCenter: parent.verticalCenter
                    opacity: index == listView.dragIndex ? 0.1 : 1

                    states: [
                        State {
                            when: index == listView.dragIndex
                            PropertyChanges { 
                                target: listViewDragContainer;
                                restoreEntryValues: false;
                                dragTitle: title
                                dragActive: active
                                dragActionSource: current && player.state == 0 ? "playlist/pl_stop_cur.png" : "playlist/pl_play_cur.png"
                                dragActiveSource: active ? "playlist/checked-current.png" : "playlist/unchecked.png"
                                dragSaveSource: saveable ? "playlist/save_active.png" : ''
                            }
                        }
                    ]
                    
                    MouseArea {
                        id: rowArea
                        anchors.fill: parent
                        hoverEnabled: true

                        /* row background */
                        Rectangle {
                            id: rowBackground
                            height: parent.height
                            width: saveable ? parent.width - Math.floor(parent.height * 1.333) - Math.floor(parent.height * 0.444) : parent.width
                            opacity: 0.9
                            visible: false

                            states: [
                                State {
                                    when: rowArea.containsMouse
                                    PropertyChanges { target: rowBackground; color: "#696969"; visible: true }
                                },
                                State {
                                    when: !rowArea.containsMouse && current
                                    PropertyChanges { target: rowBackground; color: "#e5e5e5"; visible: true }
                                }
                            ]
                        }

                        /* active checkbox */
                        Item {
                            id: checkboxActiveArea
                            width: loader.width
                            height: parent.height

                            states: [
                                State {
                                    when: active && !current
                                    PropertyChanges { target: checkboxActive; source: "playlist/check.png" }
                                },
                                State {
                                    when: !active
                                    PropertyChanges { target: checkboxActive; source: "playlist/unchecked.png" }
                                },
                                State {
                                    when: current
                                    PropertyChanges { target: checkboxActive; source: "playlist/checked-current.png" }
                                }
                            ]

                            Image {
                                id: checkboxActive
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                smooth: true

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        player.changeActiveState(index);
                                    }
                                    CursorShapeArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                    }
                                }
                            }
                        }

                        /* title */
                        Item {
                            id: labelTitleArea
                            x: loader.width + 14
                            width: titleHeader.width - 28
                            height: parent.height
                            clip: true

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true

                                onEntered: {
                                    if(lblTitle.animate) {
                                        animateTitle.from = 0;
                                        animateTitle.to = labelTitleArea.width - lblTitle.width - labelTitleArea.width / 10;
                                        animateTitle.duration = Math.abs(animateTitle.to - animateTitle.from)*animateTitle.k;
                                        animateTitle.start();
                                    }
                                }
                                onExited: {
                                    if(lblTitle.animate) {
                                        animateTitle.forced = true;
                                        animateTitle.stop();
                                        lblTitle.x = 0;
                                    }
                                }
                            }

                            Text {
                                id: lblTitle
                                anchors.verticalCenter: parent.verticalCenter
                                text: title
                                font.pixelSize: 12
                                color: (current && !rowArea.containsMouse) ? "#2f2f2f" : "#e5e5e5"
                                smooth: true
                                property bool animate: paintedWidth / labelTitleArea.width > 0.8

                                states: [
                                    State {
                                        when: listView.dragIndex != -1
                                        PropertyChanges {
                                            target: animateTitle
                                            forced: true
                                            running: false
                                            restoreEntryValues: false
                                        }
                                        PropertyChanges {
                                            target: lblTitle
                                            x: 0
                                            restoreEntryValues: false
                                        }
                                    }
                                ]

                                PropertyAnimation on x {
                                    id: animateTitle
                                    running: false
                                    from: 0
                                    to: labelTitleArea.width - lblTitle.width - labelTitleArea.width / 10
                                    duration: Math.abs(to - from) * k
                                    property bool forced: false
                                    property int k: 65

                                    onRunningChanged: {
                                        if(running) {
                                            forced = false;
                                        }
                                        else if(!forced) {
                                            if(to == labelTitleArea.width / 10) {
                                                from = labelTitleArea.width / 10;
                                                to = labelTitleArea.width - lblTitle.width - labelTitleArea.width / 10;
                                            }
                                            else {
                                                from = lblTitle.x;
                                                to = labelTitleArea.width / 10;
                                            }
                                            duration = Math.abs(to - from) * k;
                                            start();
                                        }
                                    }
                                }
                            }
                        }

                        /* action button */
                        Item {
                            id: buttonArea
                            x: buttonsHeader.x
                            width: buttonsHeader.width
                            height: parent.height
                            visible: active

                            states: [
                                State {
                                    when: (!current || (current && player.state!=playerstates.playing && player.state!=playerstates.prebuffering )) && !rowArea.containsMouse
                                    PropertyChanges { target: btnAction; source: "playlist/pl_play.png" }
                                },
                                State {
                                    when: (!current || (current && player.state!=playerstates.playing && player.state!=playerstates.prebuffering )) && rowArea.containsMouse
                                    PropertyChanges { target: btnAction; source: "playlist/pl_play_hover.png" }
                                },
                                State {
                                    when: current && player.state!=playerstates.playing && player.state!=playerstates.prebuffering && !rowArea.containsMouse
                                    PropertyChanges { target: btnAction; source: "playlist/pl_play_cur.png" }
                                },
                                State {
                                    when: current && (player.state==playerstates.playing || player.state==playerstates.prebuffering) && rowArea.containsMouse
                                    PropertyChanges { target: btnAction; source: "playlist/pl_stop_hover.png" }
                                },
                                State {
                                    when: current && (player.state==playerstates.playing || player.state==playerstates.prebuffering) && !rowArea.containsMouse
                                    PropertyChanges { target: btnAction; source: "playlist/pl_stop_cur.png" }
                                }
                            ]

                            Image {
                                id: btnAction
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                smooth: true

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: player.playItem(index);
                                }
                                CursorShapeArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                }
                            }

                            /* save button */
                            Item {
                                id: btnActionSaveArea
                                height: parent.height
                                width: Math.floor(height * 1.333)
                                anchors.right: parent.right
                                visible: saveable

                                states: [
                                    State {
                                        when: !rowArea.containsMouse
                                        PropertyChanges { target: btnActionSave; source: "playlist/save.png" }
                                    },
                                    State {
                                        when: rowArea.containsMouse
                                        PropertyChanges { target: btnActionSave; source: "playlist/save_h.png" }
                                    },
                                    State {
                                        when: current && !rowArea.containsMouse
                                        PropertyChanges { target: btnActionSave; source: "playlist/save_active.png" }
                                    }
                                ]

                                Rectangle {
                                    id: btnActionSaveBackground
                                    anchors.fill: parent
                                    visible: false

                                    states: [
                                        State {
                                            when: rowArea.containsMouse
                                            PropertyChanges { target: btnActionSaveBackground; color: "#656565"; visible: true }
                                        },
                                        State {
                                            when: !rowArea.containsMouse && current
                                            PropertyChanges { target: btnActionSaveBackground; color: "#e6e6e6"; visible: true }
                                        }
                                    ]
                                }

                                Image {
                                    id: btnActionSave
                                    anchors.fill: parent
                                    smooth:  true

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: player.saveItem(index);
                                        CursorShapeArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        /* scroll bar */
        Rectangle {
            id: scrollbar
            width: btnClose.width
            height: listView.height
            anchors.right: listView.right
            color: "transparent"
            smooth: true
            visible: listView.contentHeight > listView.height

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(mouse.y - 1 < slider.height / 2)
                        listView.contentY = parent.y * listView.contentHeight / parent.height
                    else if(parent.height - 1 - mouse.y < slider.height / 2)
                        listView.contentY = (parent.height - slider.height) * listView.contentHeight / parent.height
                    else
                        listView.contentY = (mouse.y - slider.height / 2) * listView.contentHeight / parent.height
                }
            }

            Rectangle {
                id: slider
                x: (parent.width - width) / 2
                y: listView.visibleArea.yPosition * parent.height
                width: parent.width * 0.204
                height: listView.visibleArea.heightRatio * parent.height
                smooth: true
                color: "#696969"

                MouseArea {
                    anchors.fill: parent
                    drag.target: parent
                    drag.axis: Drag.YAxis
                    drag.minimumY: 0
                    drag.maximumY: scrollbar.height - parent.height

                    onPositionChanged: {
                        if (pressedButtons == Qt.LeftButton)
                            listView.contentY = slider.y * listView.contentHeight / scrollbar.height
                    }
                }
            }
        }
    }

    /* bottom button select */
    Row {
        id: btnSelectHolder
        x: Math.floor(parent.width * 0.04)
        height: 42
        anchors.bottom: parent.bottom
        spacing: 10

        Image {
            id: arrow
            source: "playlist/arrow.png"
            anchors.top: parent.top
            opacity: 0.35
        }

        Item {
            id: btnSelect
            x: 37
            y: 4
            width: 105
            height: 23
            state: "unselect"

            states: [
                State {
                    name: "select"
                    PropertyChanges { target: lblSelect; text: root.translate("Select all") }
                },
                State {
                    name: "unselect"
                    PropertyChanges { target: lblSelect; text: root.translate("Select none") }
                }
            ]

            function toogleStates() {
                if(state=="unselect") {
                    player.unactiveStateForAll();
                    state = "select";
                }
                else {
                    player.activeStateForAll();
                    state = "unselect";
                }
            }

            Image {
                id: selectFrame
                source: "playlist/select-frame.png"
                anchors.fill: parent
                smooth: true
                opacity: 0.35
            }

            Text {
                id: lblSelect
                x: (parent.width - width)/2
                y: (parent.height - height)/2
                font.pixelSize: Math.floor(parent.height * 0.5556)
                smooth: true
            }

            MouseArea {
                id: btnSelectArea
                anchors.fill: parent
                hoverEnabled: true

                states: [
                    State {
                        when: !btnSelectArea.containsMouse
                        PropertyChanges { target: arrow; opacity: 0.35 }
                        PropertyChanges { target: selectFrame; opacity: 0.35 }
                        PropertyChanges { target: lblSelect; color: "#858585" }
                    },
                    State {
                        when: btnSelectArea.containsMouse
                        PropertyChanges { target: arrow; opacity: 1 }
                        PropertyChanges { target: selectFrame; opacity: 1 }
                        PropertyChanges { target: lblSelect; color: "#e5e5e5" }
                    }
                ]

                onClicked: btnSelect.toogleStates()
                CursorShapeArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }
}

