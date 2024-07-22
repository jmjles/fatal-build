import QtQuick 1.1
import "functions.js" as Lib
import CursorShape 1.0
import StandardToolTip 1.0

Rectangle {
    id: panelMin
    color: "#2f2f2f"
    opacity: 1

    /* menu quality functions */
    function initQualityMenu() {
        for(var i = 0; i < panel.qualities.length; i++) {
            chooseQuality.showItem(i, panel.qualities[i], panel.bitrates[i]);
        }
        chooseQuality.visible = true;
    }

    function uninitQualityMenu() {
        chooseQuality.visible = false;
        for(var i = 0; i < chooseQuality.itemsCount; i++) {
            chooseQuality.hideItem(i);
        }
    }

    /* hls streams functions */
    function initHlsStreamsMenu() {
        var hls_streams = root.getHlsStreamsList();
        for(var i = 0; i < hls_streams.length; i++) {
            chooseHlsStream.showItem(i, hls_streams[i].name, hls_streams[i].index);
        }
        chooseHlsStream.visible = true;
    }

    function uninitHlsStreamsMenu() {
        chooseHlsStream.visible = false;
        for(var i = 0; i < chooseHlsStream.itemsCount; i++) {
            chooseHlsStream.hideItem(i);
        }
    }

    /* left controls area */
    Row {
        id: leftRow
        spacing: 0

        /* skip ad button */
        Item {
            id: btnAd
            width: state == "wait" ? lblAd.width + 10 + parent.height : lblSkip.width + 10
            height: panelMin.height
            visible: player.isAd

            states: [
                State {
                    name: "wait"
                    when: player.isAd && player.waitForAd >= 0
                    PropertyChanges {
                        target: skip_layout
                        visible: false
                    }
                    PropertyChanges {
                        target: wait_layout
                        visible: true
                    }
                },
                State {
                    name: "skip"
                    when: player.isAd && player.waitForAd < 0
                    PropertyChanges {
                        target: skip_layout
                        visible: true
                    }
                    PropertyChanges {
                        target: wait_layout
                        visible: false
                    }
                }
            ]

            MouseArea {
                id: wait_layout
                anchors.fill: parent
                visible: false

                onClicked: {}

                Item {
                    width: parent.height
                    height: parent.height
                    anchors.top: parent.top
                    anchors.left: parent.left

                    Image {
                        source: root.imgPath+"ad_waiting.png"
                        anchors.fill: parent
                        smooth: true

                        NumberAnimation on rotation {
                            from: 0;
                            to: 360;
                            running: visible;
                            loops: Animation.Infinite;
                            duration: 900
                        }
                    }

                    Text {
                        id: time_wait
                        text: player.waitForAd
                        font.pixelSize: 12
                        color: "#E5E5E5"
                        anchors.centerIn: parent
                    }
                }

                Item {
                    width: lblAd.width + 10
                    height: parent.height
                    anchors.top: parent.top
                    anchors.right: parent.right

                    Text {
                        id: lblAd
                        text: translator.translate("Advertising")
                        font.pixelSize: 12
                        anchors.centerIn: parent
                        color: "#E5E5E5"
                    }
                }
            }

            MouseArea {
                id: skip_layout
                anchors.fill: parent
                hoverEnabled: true
                visible: false

                onClicked: player.skipAd();

                Text {
                    id: lblSkip
                    text: translator.translate("Skip this ad")
                    color: skip_layout.containsMouse ? "#D5D5D5" : "#E5E5E5"
                    font.pixelSize: 12
                    anchors.centerIn: parent
                }

                CursorShapeArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }

        /* separator */
        Rectangle {
            width: 1
            height: panelMin.height
            color: "#404040"
            visible: btnAd.visible
        }


        /* prev button */
        Button {
            id: btnPrevMin
            width: Math.floor(height * 1.944)
            height: panelMin.height
            anchors.verticalCenter: parent.verticalCenter
            visible: !player.liveStream && !player.isAd && player.hasPlaylist
            pixmaps: {
                'default': root.imgPath+"prev-btn.png",
                'hovered': root.imgPath+"prev-btn_h.png"
            }
            onClicked: player.prev()
        }

        /* separator */
        Rectangle {
            width: 1
            height: panelMin.height
            color: "#404040"
            visible: btnPrevMin.visible
        }

        /* play button */
        DoubleStateButton {
            id: btnPlayMin
            width: Math.floor(height * 1.944)
            height: panelMin.height
            anchors.verticalCenter: parent.verticalCenter
            visible: !player.isAd
            pixmaps: {
                'default1': root.imgPath+"play-btn.png",
                'hovered1': root.imgPath+"play-btn_h.png",
                'default2': root.imgPath+"pause-btn.png",
                'hovered2': root.imgPath+"pause-btn_h.png"
            }
            condition: player.state==playerstates.playing || player.state==playerstates.prebuffering
            onClicked: player.play()
        }

        /* separator */
        Rectangle {
            width: 1
            height: panelMin.height
            color: "#404040"
            visible: btnPlayMin.visible
        }

        /* next button */
        Button {
            id: btnNextMin
            width: Math.floor(height * 1.944)
            height: panelMin.height
            anchors.verticalCenter: parent.verticalCenter
            visible: !player.liveStream && !player.isAd && player.hasPlaylist
            pixmaps: {
                'default': root.imgPath+"next-btn.png",
                'hovered': root.imgPath+"next-btn_h.png"
            }
            onClicked: player.next()
        }

        /* separator */
        Rectangle {
            width: 1
            height: panelMin.height
            color: "#404040"
            visible: btnNextMin.visible
        }

        /* live button */
        Item {
            id: live_options
            width: live_text.width+live_text.x+live_img.x //Math.floor(height * 1.944)
            height: panelMin.height
            anchors.verticalCenter: parent.verticalCenter
            visible: player.liveStream && !player.isAd

            Image {
                id: live_img
                width: 10
                height: 10
                x: (btnPlayMin.width - (width + live_text.width + 7))/2
                y: (parent.height - height)/2

                states: [
                    State {
                        name: "undefined"
                        when: player.liveStreamIsLive == -1
                        PropertyChanges { target: live_img; source: root.imgPath+"live_no_fs.png" }
                    },
                    State {
                        name: "timeshiftable"
                        when: player.liveStreamIsLive == 0
                        PropertyChanges { target: live_img; source: root.imgPath+"live_time.png" }
                    },
                    State {
                        name: "untimeshiftable"
                        when: player.liveStreamIsLive == 1
                        PropertyChanges { target: live_img; source: root.imgPath+"live.png" }
                    }
                ]
            }

            Text {
                id: live_text
                text: root.translate("Live")
                color: "#909090"
                font.pixelSize: 12
                x: live_img.width + live_img.x + 7
                y: (parent.height - height)/2
            }

            MouseArea {
                id: live_area_mouse_area
                anchors.fill: parent
                hoverEnabled: true

                CursorShapeArea {
                    anchors.fill: parent
                    cursorShape: live_img.state == "timeshiftable" ? Qt.PointingHandCursor : Qt.ArrowCursor
                }

                onClicked: {
                    if(live_img.state == "timeshiftable")
                         player.changePlayback(-1);
                }
            }
        }

        /* separator */
        Rectangle {
            width: 1
            height: panelMin.height
            color: "#404040"
            visible: live_options.visible
        }

        /* volume controls */
        Item {
            id: volumeHolderMin
            width:  volumeControlsRow.width
            height: panelMin.height

            MouseArea {
                id: volumeHolderMinArea
                anchors.fill: parent
                hoverEnabled: true

                Row {
                    id: volumeControlsRow
                    spacing: volumeHolderMinArea.containsMouse ? (Math.floor(panel.height * 4.292) - btnMuteMin.width - volumeScaleMin.width - 1) / 2 : 0

                    /* mute button */
                    DoubleStateButton {
                        id: btnMuteMin
                        width:  Math.floor(height * 1.444)
                        height: panelMin.height
                        anchors.verticalCenter: parent.verticalCenter
                        pixmaps: {
                            'default1': root.imgPath+"mute-on-small.png",
                            'hovered1': root.imgPath+"mute-on-small_h.png",
                            'default2': root.imgPath+"mute-off-small.png",
                            'hovered2': root.imgPath+"mute-off-small_h.png"
                        }
                        condition: player.mute
                        onClicked: player.toggleMute()
                    }

                    /* volume scale */
                    Image {
                        id: volumeScaleMin
                        width: Math.floor(panel.height * 2.708)
                        anchors.verticalCenter: parent.verticalCenter
                        source: root.imgPath + "scale.png"
                        visible: volumeHolderMinArea.containsMouse

                        Rectangle {
                            id: soundLevelMin
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: parent.width
                            height: parent.height * 0.3846
                            color: "#404040"

                            Rectangle {
                                x: 0
                                width: player.volume * parent.width / 100
                                height: parent.height
                                color: "#00a691"
                            }
                            Rectangle {
                                x: parent.width * 0.58
                                width: (player.volume - 58) * parent.width / 100
                                height: parent.height
                                color: "#dd9a22"
                                visible: player.volume > 58
                            }
                            Rectangle {
                                x: parent.width * 0.76
                                width: (player.volume - 76) * parent.width / 100
                                height: parent.height
                                color: "#d73e3e"
                                visible: player.volume > 76
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                var newVolume = parseInt(100 * mouseX / volumeScaleMin.width);
                                player.changeVolume(newVolume);
                            }
                        }

                        Rectangle {
                            id: volumeSliderMin
                            x: volumeSliderMinArea.drag.active ? x : player.volume * volumeScaleMin.width / 100
                            y: (parent.height - height) / 2
                            width: 2
                            height: Math.floor(parent.height*0.8462)
                            color: "#f8f8f8"

                            MouseArea {
                                id: volumeSliderMinArea
                                anchors.fill: parent
                                drag.target: parent
                                drag.axis: Drag.XAxis
                                drag.minimumX: 0 - volumeSliderMin.width / 2
                                drag.maximumX: volumeScaleMin.width - volumeSliderMin.width / 2

                                onPositionChanged: {
                                    var newVolume = parseInt(100 * (volumeSliderMin.x + volumeSliderMin.width / 2) / volumeScaleMin.width);
                                    player.changeVolume(newVolume);
                                }
                            }
                        }
                    }

                    /* separator */
                    Rectangle {
                        width: 1
                        height: panelMin.height
                        color: "#404040"
                        visible: btnMuteMin.visible
                    }
                }
            }
        }

        /* playback/duration label */
        Item {
            id: lblTimeValues
            width: Math.floor(panel.height * 2.792)
            height: Math.floor(panel.height * 0.27)
            anchors.verticalCenter: parent.verticalCenter
            visible: !player.liveStream && !player.isAd && !volumeHolderMinArea.containsMouse

            Row {
                anchors.left: parent.left
                anchors.leftMargin: Math.floor(panel.height * 0.354)
                spacing: 0

                Text {
                    id: lblPlaybackMin
                    text: Lib.secondsAsString(parseInt(player.duration * player.playback))
                    font.pixelSize: lblTimeValues.height
                    color: "#e5e5e5"
                    smooth: true
                }
                Text {
                    text: "/"
                    font.pixelSize: lblTimeValues.height
                    color: "#e5e5e5"
                    smooth: true
                }
                Text {
                    id: lblDurationMin
                    text: Lib.secondsAsString(player.duration)
                    font.pixelSize: lblTimeValues.height
                    color: "#e5e5e5"
                    smooth: true
                }
            }
        }
    }

    /* information label */
    Item {
        id: lblInformationItem
        height: panelMin.height
        anchors.left: leftRow.right
        anchors.leftMargin: Math.floor(panel.height * 0.354)
        anchors.right: rightRow.left
        anchors.rightMargin: Math.floor(panel.height * 0.354)
        anchors.verticalCenter: parent.verticalCenter
        clip: true

        Text {
            id: lblInfo
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: lblTimeValues.height
            color: "#e5e5e5"
            text: player.statusMsg == "" ? player.currentTitle : player.statusMsg
            property bool animate:  lblInfo.width / lblInformationItem.width > 0.8

            onTextChanged: {
                animate = lblInfo.width / lblInformationItem.width > 0.8
                if(animate) {
                    if(!animateInfo.running) {
                        animateInfo.from = 0;
                        animateInfo.to = -lblInfo.width;
                        animateInfo.duration = 20000;
                        animateInfo.start();
                    }
                }
                else {
                    animateInfo.stop();
                    lblInfo.x=0;
                }
            }

            PropertyAnimation on x {
                id: animateInfo
                running: false
                from: 0;
                to: -lblInfo.width;
                duration: 20000;
                onRunningChanged: {
                    if(!running && lblInfo.animate ) {
                        if( from === 0 ) {
                            from = lblInformationItem.width;
                            duration = duration*1.5;
                        }
                        start()
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: { if(lblInfo.animate) animateInfo.pause() }
            onExited: { if(lblInfo.animate) animateInfo.resume() }
        }
    }

    /* right controls area */
    Row {
        id: rightRow
        anchors.right: parent.right
        spacing: 0

        /* separator */
        Rectangle {
            width: 1
            height: panelMin.height
            color: "#404040"
            visible: btnQualitytMin.visible || btnHlsStreamsMin.visible
        }

        /* quality button */
        Button {
            id: btnQualitytMin
            width: Math.floor(height * 1.944)
            height: panelMin.height
            anchors.verticalCenter: parent.verticalCenter
            visible: panel.hasQualityList && !player.isAd && player.hls_streams_count == 0

            Rectangle {
                id: btnQualitytMin_hover
                anchors.fill: parent
                color: "#d6d6d6"
                visible: chooseQuality.visible
            }

            Text {
                id: currentQuality
                text: panel.hasQualityList ? panel.qualities[player.currentQuality] : ""
                color: chooseQuality.visible  ? "#474747" : "#909090"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            onClicked: {
                if(chooseQuality.visible)
                    panelMin.uninitQualityMenu()
                else
                    panelMin.initQualityMenu()
            }
        }

        /* hls streams button */
        Button {
            id: btnHlsStreamsMin
            width: Math.floor(height * 1.944)
            height: panelMin.height
            anchors.verticalCenter: parent.verticalCenter
            visible: player.hls_streams_count > 0 && !player.isAd && (player.state < 3)

            Rectangle {
                id: btnHlsStreamsMin_hover
                anchors.fill: parent
                color: "#d6d6d6"
                visible: chooseHlsStream.visible
            }

            Text {
                id: currentHlsStream
                text: root.getCurrentHlsStreamName()
                color: chooseHlsStream.visible  ? "#474747" : "#909090"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            onClicked: {
                if(chooseHlsStream.visible)
                    panelMin.uninitHlsStreamsMenu()
                else
                    panelMin.initHlsStreamsMenu()
            }
        }

        /* separator */
        Rectangle {
            width: 1
            height: panelMin.height
            color: "#404040"
            visible: btnSaveCurrentMin.visible
        }

        /* save button */
        Button {
            id: btnSaveCurrentMin
            width: Math.floor(height * 1.944)
            height: panelMin.height
            visible: player.saveable && !player.isAd
            pixmaps: {
                'default': root.imgPath+"panel-save.png",
                'hovered': root.imgPath+"panel-save_h.png"
            }
            onClicked: player.saveCurrent()
        }

        /* separator */
        Rectangle {
            width: 1
            height: panelMin.height
            color: "#404040"
            visible: btnPlaylistMin.visible
        }

        /* playlist button */
        DoubleStateButton {
            id: btnPlaylistMin
            width: Math.floor(height * 1.944)
            height: panelMin.height
            anchors.verticalCenter: parent.verticalCenter
            visible: player.hasPlaylist && !player.isAd
            pixmaps: {
                'default1': root.imgPath+"playlist-btn.png",
                'hovered1': root.imgPath+"playlist-btn_h.png",
                'default2': root.imgPath+"playlist-active.png",
                'hovered2': root.imgPath+"playlist-active.png"
            }
            condition: player.playlistVisible
            onClicked: player.togglePlaylist();
        }

        /* separator */
        Rectangle {
            width: 1
            height: panelMin.height
            color: "#404040"
            visible: btnFullscreenMin.visible
        }

        /* fullscreen button */
        Button {
            id: btnFullscreenMin
            width: Math.floor(height * 1.944)
            height: panelMin.height
            anchors.verticalCenter: parent.verticalCenter
            pixmaps: {
                'default': root.imgPath+"fullscreen-btn.png",
                'hovered': root.imgPath+"fullscreen-btn_h.png"
            }
            onClicked: player.toggleFullscreen()
        }

        /* separator */
        Rectangle {
            width: 1
            height: panelMin.height
            color: "#404040"
            visible: btnPowerMin.visible
        }

        /* power button */
        DoubleStateButton {
            id: btnPowerMin
            width: Math.floor(height * 1.944)
            height: panelMin.height
            anchors.verticalCenter: parent.verticalCenter
            visible: !player.isAd
            pixmaps: {
                'default1': root.imgPath+"power-btn.png",
                'hovered1': root.imgPath+"power-btn_h.png",
                'default2': root.imgPath+"power-active.png",
                'hovered2': root.imgPath+"power-btn_h.png"
            }
            condition: player.state != playerstates.fullstopped
            onClicked: player.stop(true);

            Rectangle {
                color: "#434343"
                anchors.fill: parent
                z: -1
                visible: player.state != playerstates.fullstopped
            }
        }

        /* separator */
        Rectangle {
            width: 1
            height: panelMin.height
            color: "#404040"
            visible: btnUnableAds.visible
        }

        /* unable ads button */
        Item {
            id: btnUnableAds
            visible: player.isAd && player.adCanBeDisabled
            width: lblUnableAds.width + 10
            height: panelMin.height

            Text {
                id: lblUnableAds
                text: translator.translate("Disable ads")
                color: btnUnableAdsArea.containsMouse ? "#D5D5D5" : "#E5E5E5"
                font.pixelSize: 12
                anchors.centerIn: parent
            }

            MouseArea {
                id: btnUnableAdsArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: player.unableAds()

                CursorShapeArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                }

                StandardToolTipObject {
                    anchors.fill: parent
                    text: root.translate("Do not display ads anymore")
                }
            }
        }
    }

    /* tip */
    Item {
        id: tip_area
        width: lblTip.width+height //Math.floor(height * 5.033)
        height: Math.floor(panel.height * 0.625)
        y: playbackProgressBar.y - height - playbackProgressBar.height
        x: {
            var new_x = 0;
            if(live_area_mouse_area.containsMouse) {
                new_x = live_options.x + live_options.width / 2;
            }
            else if(btnPlayMin.containsMouse) {
                new_x = btnPlayMin.x + btnPlayMin.width / 2;
            }
            else if(btnMuteMin.containsMouse) {
                new_x = volumeHolderMin.x + btnMuteMin.x + btnMuteMin.width / 2;
            }
            else if(btnSaveCurrentMin.containsMouse) {
                new_x = rightRow.x + btnSaveCurrentMin.x + btnSaveCurrentMin.width / 2;
            }
            else if(btnPlaylistMin.containsMouse) {
                new_x = rightRow.x + btnPlaylistMin.x + btnPlaylistMin.width / 2;
            }
            else if(btnFullscreenMin.containsMouse) {
                new_x = rightRow.x + btnFullscreenMin.x;
            }
            else if(btnPowerMin.containsMouse) {
                new_x = rightRow.x + btnPowerMin.x;
            }

            if(new_x == 0) {
                new_x = last_x;
            }
            else {
                last_x = new_x;
            }

            return new_x;
        }
        opacity: 0
        smooth: true
        property int last_x: 0
        property string last_text: ""

        Image {
            id: tip_start
            height:  parent.height
            width: height
            source: root.imgPath + "tip-start.png"
        }
        Image {
            id: tip_body
            height: parent.height
            width: parent.width - tip_start.width
            x: tip_start.width
            source: root.imgPath + "tip-body.png"
            fillMode: Image.TileHorizontally
        }

        states: [
             State { name: "show_tip";
                 when: (live_area_mouse_area.containsMouse && live_img.state != "undefined")
                       || btnPlayMin.containsMouse
                       || btnSaveCurrentMin.containsMouse
                       || btnPlaylistMin.containsMouse
                       || btnFullscreenMin.containsMouse
                       || btnPowerMin.containsMouse
                       || btnMuteMin.containsMouse
                       },
             State { name: "hide_tip";
                 when: !(live_area_mouse_area.containsMouse && live_img.state != "undefined")
                       && !btnPlayMin.containsMouse
                       && !btnSaveCurrentMin.containsMouse
                       && !btnPlaylistMin.containsMouse
                       && !btnFullscreenMin.containsMouse
                       && !btnPowerMin.containsMouse
                       && !btnMuteMin.containsMouse
                       }
         ]
         transitions: [
             Transition {
                 from: "hide_tip"; to: "show_tip"
                 NumberAnimation {
                     target: tip_area
                     properties: "opacity"
                     from: 0; to: 1; duration: 500
                 }
             },
             Transition {
                 from: "show_tip"; to: "hide_tip"
                 NumberAnimation {
                     target: tip_area
                     properties: "opacity"
                     from: 1; to: 0; duration: 500
                 }
             }
         ]

        Text {
            id: lblTip
            y: (parent.height - height - 6) / 2
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 11
            color: "#e6e6e6"
            text: {
                var new_text = "";
                if(live_area_mouse_area.containsMouse) {
                    if(live_img.state == "untimeshiftable") {
                        new_text = "You are watching live broadcast";
                    }
                    else {
                        new_text = "Skip ahead to live broadcast";
                    }
                }
                else if(btnPlayMin.containsMouse) {
                    new_text = btnPlayMin.condition ? "Pause" : "Play";
                }
                else if(btnSaveCurrentMin.containsMouse) {
                    new_text = "Save";
                }
                else if(btnPlaylistMin.containsMouse) {
                    new_text = "Playlist";
                }
                else if(btnFullscreenMin.containsMouse) {
                    new_text = "Exit Fullscreen";
                }
                else if(btnPowerMin.containsMouse) {
                    new_text = "Turn off";
                }
                else if(btnMuteMin.containsMouse) {
                    new_text = btnMuteMin.condition ? "Mute off" : "Mute on";
                }

                if(new_text.length == 0) {
                    new_text = parent.last_text;
                }
                else {
                    parent.last_text = new_text;
                }

                if(new_text.length == 0) {
                    return "";
                }

                return root.translate(new_text);
            }

        }
    }

    /* choose quality */
    ChooseQualityMenuMin {
        id: chooseQuality
    }

    /* choose hls stream */
    ChooseHlsStreamMenuMin {
        id: chooseHlsStream
    }
}
