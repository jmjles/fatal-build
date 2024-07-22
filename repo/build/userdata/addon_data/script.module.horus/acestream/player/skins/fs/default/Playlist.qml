import QtQuick 1.1
import CursorShape 1.0
import StandardToolTip 1.0

/* Playlist.qml */
Rectangle {
    id: playlist
    color: "#404040"
    opacity: 0.85

    function wheel(val) { scrollbar.wheel(val); }

    /* header */
    Row {
        x: Math.floor(playlist.width * 0.018)
        y: Math.floor(playlist.width * 0.01)
        spacing: Math.floor(parent.width * 0.013)

        Rectangle {
            id: header
            width: Math.floor(playlist.width * 0.91)
            height: Math.floor(width * 0.0407)
            color: "#343434"

            Row {
                spacing: 0

                /* loader */
                Item {
                    id: loader
                    width: Math.floor(header.width * 0.067)
                    height: header.height

                    AnimatedImage {
                        id: loading
                        anchors.centerIn: parent
                        width: Math.floor(parent.width * 0.2623)
                        height: Math.floor(width * 0.6875)
                        source: root.imgPath + "loader.png"
                    }
                }
                /* separator */
                Rectangle {
                    width: 1
                    height: header.height
                    color: "#4b4b4a"
                }
                /* title */
                Item {
                    id: titleHeader
                    width: Math.floor(header.width * 0.6846)
                    height: header.height
                    Text {
                        text: root.translate("Title")
                        x: Math.floor(parent.width * 0.104)
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: Math.floor(parent.height * 0.4324)
                        color: "#e5e5e5"
                    }
                }
                /* separator */
                Rectangle {
                    width: 1
                    height: header.height
                    color: "#4b4b4a"
                }
                /* buttons */
                Item {
                    id: buttonsHeader
                    width: header.width - loader.width - titleHeader.width - 2
                    height: header.height

                    Text {
                        text: root.translate("Actions")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: Math.floor(parent.height * 0.4324)
                        color: "#e5e5e5"
                    }
                }
            }
        }

        /* close button */
        Rectangle {
            id: btnClose
            width: Math.floor(height * 1.3243)
            height: header.height
            color: "#343434"

            Image {
                source: root.imgPath + "close.png"
                smooth: true
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: player.togglePlaylist();

                    onEntered: btnSaveToolTip.showToolTip(btnClose.mapToItem(null, mouseX, mouseY).x, btnClose.mapToItem(null, mouseX, mouseY).y, "Close")
                    onExited: btnSaveToolTip.hideToolTip()

                    CursorShapeArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                    }

                    StandardToolTipObject {
                        id: btnSaveToolTip
                    }
                }
            }
        }
    }

    /* playlist */
    Item {
        id: list
        y: Math.floor(parent.width * 0.083)
        width: Math.floor(parent.width * 0.982)
        height: listView.rowHeight * listVisibleItems
        anchors.right: parent.right
        
        property int listVisibleItems: Math.floor(parent.width * 0.505 / listView.rowHeight)

        MouseArea {
            id: listArea
            anchors.fill: parent
            hoverEnabled: true

            onEntered: player.changeWheelType(1);
            onExited: player.changeWheelType(0);

             /* playlist view */
            ListView {
                id: listView
                model: playlistModel
                delegate: listViewDelegate
                anchors.fill: parent
                boundsBehavior: Flickable.StopAtBounds
                snapMode: ListView.SnapToItem
                clip:true

                property int rowHeight: header.height + rowSpacing
                property int rowSpacing: Math.floor(header.height * 0.4054)
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
                            name: "shown"
                            when: listView.dropIndex!=-1 && listView.dragDirection!=0
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

                /* draggable item template */
                Rectangle {
                    id: listViewDragContainer
                    z: 2; x: 0;
                    y: dragArea.mouseY - height / 2
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

                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: Math.floor(list.width * 0.0242)
                        /* active checkbox */
                        Item {
                            width: loader.width
                            height: listViewDragContainer.height
                            Image {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                source: listViewDragContainer.dragActiveSource
                                smooth: true
                            }
                        }
                        /* title */
                        Item {
                            width: titleHeader.width - parent.spacing * 2
                            height: listViewDragContainer.height
                            clip: true
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: listViewDragContainer.dragTitle
                                font.pixelSize: Math.floor(parent.height * 0.5)
                                color: "#2f2f2f"
                                smooth: true
                            }
                        }
                        /* action button */
                        Item {
                            width: buttonsHeader.width
                            height: listViewDragContainer.height
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
                    x: titleHeader.x
                    width: titleHeader.width //titleHeader.width - 28
                    height: parent.height
                    property bool canScroll: true

                    CursorShapeArea {
                        anchors.fill: parent
                        cursorShape: listView.dragIndex == -1 ? Qt.OpenHandCursor : Qt.ClosedHandCursor
                    }

                    function resync() {
                        if(listView.dragIndex != -1) {
                            var newPos = listView.indexAt(mouseX, mouseY + listView.contentY)
                            if (newPos !== listView.dropIndex && newPos !== -1) {
                                listView.dragDirection = newPos > listView.dragIndex
                                        ? 1 : newPos < listView.dragIndex ? -1 : 0
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
                    x: 0; y: 0
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
                                    dragActionSource: current && ( player.state == playerstates.playing || player.state == playerstates.prebuffering ) ? root.imgPath + "pl_stop_cur.png" : root.imgPath + "pl_play_cur.png"
                                    dragActiveSource: active ? root.imgPath + "checked-current.png" : root.imgPath + "unchecked.png"
                                    dragSaveSource: saveable ? root.imgPath + "save-btn-active.png" : ''
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

                            Row {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: Math.floor(list.width * 0.0242)

                                /* active checkbox */
                                Item {
                                    id: checkboxActiveArea
                                    width: loader.width
                                    height: rowArea.height

                                    states: [
                                        State {
                                            when: active && !current
                                            PropertyChanges { target: checkboxActive; source: root.imgPath + "check.png" }
                                        },
                                        State {
                                            when: !active
                                            PropertyChanges { target: checkboxActive; source: root.imgPath + "unchecked.png" }
                                        },
                                        State {
                                            when: current
                                            PropertyChanges { target: checkboxActive; source: root.imgPath + "checked-current.png" }
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
                                    width: titleHeader.width - parent.spacing * 2
                                    height: rowArea.height
                                    clip: true

                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true

                                        onEntered: {
                                            if(lblTitle.animate) {
                                                animateTitle.from = 2;
                                                animateTitle.to = labelTitleArea.width - lblTitle.width - labelTitleArea.width / 10;
                                                animateTitle.duration = Math.abs(animateTitle.to - animateTitle.from)*animateTitle.k;
                                                animateTitle.start();
                                            }
                                        }
                                        onExited: {
                                            if(lblTitle.animate) {
                                                animateTitle.forced = true;
                                                animateTitle.stop();
                                                lblTitle.x = 2;
                                            }
                                        }
                                    }

                                    Text {
                                        id: lblTitle
                                        x: 2
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: title
                                        font.pixelSize: Math.floor(parent.height * 0.5)
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
                                                    x: 2
                                                    restoreEntryValues: false
                                                }
                                            }
                                        ]


                                        PropertyAnimation on x {
                                            id: animateTitle
                                            running: false
                                            from: 2
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
                                    width: buttonsHeader.width
                                    height: rowArea.height
                                    visible: active

                                    states: [
                                        State {
                                            when: (!current || (current && player.state!=playerstates.playing && player.state!=playerstates.prebuffering)) && !rowArea.containsMouse
                                            PropertyChanges { target: btnAction; source: root.imgPath + "pl_play.png" }
                                        },
                                        State {
                                            when: (!current || (current && player.state!=playerstates.playing && player.state!=playerstates.prebuffering)) && rowArea.containsMouse
                                            PropertyChanges { target: btnAction; source: root.imgPath + "pl_play_hover.png" }
                                        },
                                        State {
                                            when: current && player.state!=playerstates.playing && player.state!=playerstates.prebuffering && !rowArea.containsMouse
                                            PropertyChanges { target: btnAction; source: root.imgPath + "pl_play_cur.png" }
                                        },
                                        State {
                                            when: current && ( player.state==playerstates.playing || player.state==playerstates.prebuffering ) && rowArea.containsMouse
                                            PropertyChanges { target: btnAction; source: root.imgPath + "pl_stop_hover.png" }
                                        },
                                        State {
                                            when: current && ( player.state==playerstates.playing || player.state==playerstates.prebuffering ) && !rowArea.containsMouse
                                            PropertyChanges { target: btnAction; source: root.imgPath + "pl_stop_cur.png" }
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
                                            CursorShapeArea {
                                                anchors.fill: parent
                                                cursorShape: Qt.PointingHandCursor
                                            }
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
                                                PropertyChanges { target: btnActionSave; source: root.imgPath + "save-btn.png" }
                                            },
                                            State {
                                                when: rowArea.containsMouse
                                                PropertyChanges { target: btnActionSave; source: root.imgPath + "save-btn_h.png" }
                                            },
                                            State {
                                                when: current && !rowArea.containsMouse
                                                PropertyChanges { target: btnActionSave; source: root.imgPath + "save-btn-active.png" }
                                            }
                                        ]

                                        Rectangle {
                                            id: btnActionSaveBackground
                                            anchors.fill: parent
                                            visible: false

                                            states: [
                                                State {
                                                    when: rowArea.containsMouse
                                                    PropertyChanges { target: btnActionSaveBackground; color: "#696969"; visible: true }
                                                },
                                                State {
                                                    when: !rowArea.containsMouse && current
                                                    PropertyChanges { target: btnActionSaveBackground; color: "#e5e5e5"; visible: true }
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
                                            }
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
                anchors.rightMargin: Math.floor(width * 0.204)
                color: "transparent"
                smooth: true
                visible: listView.contentHeight > listView.height

                function wheel(val) {
                    if(!scrollbar.visible) return;
                    if(val>0) {
                        if(listView.contentY > 25)
                            listView.contentY -= 25
                        else
                            listView.contentY = 1
                    }
                    else {
                        if(listView.contentHeight-listView.height > listView.contentY+25)
                            listView.contentY += 25
                        else
                            listView.contentY = listView.contentHeight-listView.height
                    }
                }

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
    }

    /* bottom button select */
    MouseArea {
        id: btnSelectArea
        x: Math.floor(width * 0.2027)
        width: Math.floor(parent.width * 0.222)
        height: Math.floor(width * 0.1847)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Math.floor(parent.width * 0.031)
        hoverEnabled: true

        Image {
            id: arrow
            smooth: true
        }
        Image {
            id: btnSelect
            width: Math.floor(parent.width * 0.7387)
            height: Math.floor(width*0.2195)
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            smooth: true
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

            Text {
                id: lblSelect
                anchors.centerIn: parent
                font.pixelSize: Math.floor(parent.height * 0.5556)
                smooth: true
            }
        }

        states: [
            State {
                when: !btnSelectArea.containsMouse
                PropertyChanges { target: arrow; source: root.imgPath + "pl_arrow.png" }
                PropertyChanges { target: btnSelect; source: root.imgPath + "select.png" }
                PropertyChanges { target: lblSelect; color: "#858585" }
            },
            State {
                when: btnSelectArea.containsMouse
                PropertyChanges { target: arrow; source: root.imgPath + "pl_arrow-act.png" }
                PropertyChanges { target: btnSelect; source: root.imgPath + "select-act.png" }
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

