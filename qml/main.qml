import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Dialogs 1.1

ApplicationWindow {
    id: window
    visible: true
    visibility: fullScreenSwitch.checked ? 'FullScreen' : 'Windowed'
    width: 1280
    height: 720

    // REMOVE TITLE BAR & STAY ON TOP
    flags: {
        if (ontopSwitch.checked)
            (Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Window)
        else
            (Qt.FramelessWindowHint & ~Qt.WindowStaysOnTopHint | Qt.Window)
    }

    function setThemeColor(color) {
        if (color === 'orange') {
            return Material.DeepOrange
        } else if (color === 'blue') {
            return Material.Blue
        } else if (color === 'pink') {
            return Material.Pink
        } else {
            return Material.Teal
        }
    }

    LayoutMirroring.enabled: isRightLayout
    LayoutMirroring.childrenInherit: true

    property var isRightLayout: (Qt.application.layoutDirection === Qt.RightToLeft)
    property var themeColor: Material.color(setThemeColor(backend.color))
    Material.theme: themeSwitch.checked ? Material.Dark : Material.Light
    Material.accent: themeColor
    Material.primary: themeColor

    FontLoader {
        id: myFont
        source: 'qrc:/myfont'
    }

    // BACKEND CONNECTIONS
    Connections {
        id: backend
        target: con
        property var language: backend.getLanguage()
        property var color: backend.getColor()

        function getLanguage() {
            try {
                return con.get_language()
            } catch (TypeError) {

            }
        }

        function getTheme() {
            try {
                return con.get_theme()
            } catch (TypeError) {

            }
        }

        function getColor() {
            try {
                return con.get_color()
            } catch (TypeError) {

            }
        }

        function setLanguage(language) {
            try {
                con.set_language(language)
            } catch (TypeError) {

            }
        }

        function setTheme(theme) {
            try {
                con.set_theme(theme)
            } catch (TypeError) {

            }
        }

        function setColor(color) {
            try {
                con.set_color(color)
            } catch (TypeError) {

            }
        }

        function setAttach(filename, image, audio) {
            try {
                con.set_attach(filename, image, audio)
            } catch (TypeError) {

            }
        }

        function setInfo(receivers, cc, bcc, subject, message) {
            try {
                con.set_info(receivers, cc, bcc, subject, message)
            } catch (TypeError) {

            }
        }

        function setSettings(repeat, sleep, multi) {
            try {
                con.set_settings(repeat, sleep, multi)
            } catch (TypeError) {

            }
        }

        function setLogin(email, password) {
            try {
                con.set_login(email, password)
            } catch (TypeError) {

            }
        }

        function sendMessage() {
            try {
                con.send_message()
            } catch (TypeError) {

            }
        }

        function readTextFile(path) {
            return con.read_file(path)
        }
    }
    // END BACKEND

    // GLOBAL VARIABLES
    property var lnkInsta: 'https://www.instagram.com/9_tay'

    RowLayout {
        anchors.fill: parent
        LayoutMirroring.enabled: false
        LayoutMirroring.childrenInherit: false

        ColumnLayout {
            id: columnLayoutRight
            width: 100
            height: 100
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            RowLayout {
                width: 100
                height: 100
                Layout.rightMargin: isRightLayout ? 0 : 0
                Layout.leftMargin: isRightLayout ? 0 : 20
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                TextField {
                    id: txtSubject
                    padding: 5
                    focus: true
                    selectByMouse: true
                    persistentSelection: true
                    Layout.preferredWidth: isRightLayout ? 230 : 240
                    placeholderText: qsTr("Subject")

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.IBeamCursor
                        acceptedButtons: Qt.RightButton
                        onClicked: {
                            contextMenu4.x = mouse.x
                            contextMenu4.y = mouse.y
                            contextMenu4.open()
                        }
                    }

                    Menu {
                        id: contextMenu4

                        MenuItem {
                            text: qsTr("Copy")
                            enabled: txtSubject.selectedText
                            onTriggered: txtSubject.copy()
                        }
                        MenuItem {
                            text: qsTr("Cut")
                            enabled: txtSubject.selectedText
                            onTriggered: txtSubject.cut()
                        }
                        MenuItem {
                            text: qsTr("Paste")
                            enabled: txtSubject.canPaste
                            onTriggered: txtSubject.paste()
                        }
                        MenuItem {
                            text: qsTr("Clear")
                            enabled: (txtSubject.text.length !== 0)
                            onTriggered: txtSubject.clear()
                        }
                        MenuItem {
                            text: qsTr("Select All")
                            enabled: (txtSubject.text.length !== 0)
                            onTriggered: txtSubject.selectAll()
                        }
                    }
                }

                ToolButton {
                    id: openText
                    icon.source: 'qrc:/opentext'
                    display: AbstractButton.IconOnly

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: textDialog.open()
                    }

                    ToolTip {
                        x: -35
                        y: -35
                        delay: 150
                        parent: openText
                        visible: openText.hovered
                        text: qsTr('Open Text File')
                    }

                    FileDialog {
                        id: textDialog
                        title: qsTr('Please choose a Text file')
                        folder: shortcuts.home
                        nameFilters: ["Text files (*.txt)", "All files (*)"]
                        onAccepted: {
                            messageArea.text = backend.readTextFile(
                                        textDialog.fileUrl)
                        }
                    }
                }

                ToolSeparator {}

                ToolButton {
                    id: btnFile1
                    icon.source: "qrc:/file"

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: fileDialog.open()
                    }

                    ToolTip {
                        x: -30
                        y: -35
                        visible: btnFile1.hovered
                        text: qsTr("Attach File")
                        parent: btnFile1
                        delay: 150
                    }
                }

                ToolButton {
                    id: btnImage1
                    icon.source: "qrc:/image"

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: imageDialog.open()
                    }

                    ToolTip {
                        x: -30
                        y: -35
                        visible: btnImage1.hovered
                        text: qsTr('Attach Image')
                        parent: btnImage1
                        delay: 150
                    }
                }

                ToolButton {
                    id: btnAudio1
                    icon.source: "qrc:/audio"

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: audioDialog.open()
                    }

                    ToolTip {
                        x: -30
                        y: -35
                        visible: btnAudio1.hovered
                        text: qsTr('Attach Audio')
                        parent: btnAudio1
                        delay: 150
                    }
                }
                //                ToolButton {
                //                    id: btnBold
                //                    icon.source: 'qrc:/bold'
                //                    display: AbstractButton.IconOnly
                //                    checkable: true
                //                    enabled: false
                //                }

                //                ToolButton {
                //                    id: btnItalic
                //                    icon.source: 'qrc:/italic'
                //                    display: AbstractButton.IconOnly
                //                    checkable: true
                //                    enabled: false
                //                }

                //                ToolButton {
                //                    id: btnUnderline
                //                    icon.source: 'qrc:/underlined'
                //                    display: AbstractButton.IconOnly
                //                    checkable: true
                //                    enabled: false
                //                }

                //                ToolButton {
                //                    id: btnStriket
                //                    icon.source: 'qrc:/striket'
                //                    display: AbstractButton.IconOnly
                //                    checkable: true
                //                    enabled: false
                //                }
                ToolSeparator {}

                ToolButton {
                    id: btnClearText
                    icon.source: 'qrc:/clear'
                    display: AbstractButton.IconOnly
                    focusPolicy: Qt.TabFocus
                    enabled: messageArea.activeFocus
                             && (messageArea.text.length !== 0)

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: messageArea.clear()
                    }

                    ToolTip {
                        x: -10
                        y: -35
                        delay: 150
                        parent: btnClearText
                        visible: btnClearText.hovered
                        text: qsTr('Clear')
                    }
                }

                ToolButton {
                    id: btnCut
                    icon.source: 'qrc:/cut'
                    display: AbstractButton.IconOnly
                    focusPolicy: Qt.TabFocus
                    enabled: messageArea.activeFocus && messageArea.selectedText

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: messageArea.cut()
                    }

                    ToolTip {
                        x: -10
                        y: -35
                        delay: 150
                        parent: btnCut
                        visible: btnCut.hovered
                        text: qsTr('Cut')
                    }
                }

                ToolButton {
                    id: btnCopy
                    icon.source: 'qrc:/copy'
                    display: AbstractButton.IconOnly
                    focusPolicy: Qt.TabFocus
                    enabled: messageArea.activeFocus && messageArea.selectedText

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: messageArea.copy()
                    }

                    ToolTip {
                        x: -10
                        y: -35
                        delay: 150
                        parent: btnCopy
                        visible: btnCopy.hovered
                        text: qsTr('Copy')
                    }
                }
                ToolButton {
                    id: btnPaste
                    icon.source: 'qrc:/paste'
                    display: AbstractButton.IconOnly
                    focusPolicy: Qt.TabFocus
                    enabled: messageArea.activeFocus

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: messageArea.paste()
                    }

                    ToolTip {
                        x: -10
                        y: -35
                        delay: 150
                        parent: btnPaste
                        visible: btnPaste.hovered
                        text: qsTr('Paste')
                    }
                }
            }
            ScrollView {
                antialiasing: true
                LayoutMirroring.enabled: false
                LayoutMirroring.childrenInherit: false
                rightPadding: isRightLayout ? 5 : 5
                leftPadding: isRightLayout ? 0 : 0
                Layout.leftMargin: isRightLayout ? 0 : 10

                Layout.preferredHeight: window.height - 103
                Layout.fillWidth: true
                Layout.maximumWidth: ((window.width / 2) + 120)
                Layout.bottomMargin: -7

                TextArea {
                    id: messageArea
                    textFormat: Text.PlainText
                    wrapMode: TextArea.Wrap
                    renderType: Text.QtRendering

                    focus: true
                    selectByMouse: true
                    persistentSelection: true
                    topPadding: 5
                    bottomPadding: 10
                    rightPadding: 20
                    leftPadding: 20
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    placeholderText: qsTr("Message")

                    MouseArea {
                        anchors.fill: parent
                        anchors.bottomMargin: 8
                        cursorShape: Qt.IBeamCursor
                        acceptedButtons: Qt.RightButton
                        onClicked: {
                            contextMenu5.x = mouse.x
                            contextMenu5.y = mouse.y
                            contextMenu5.open()
                        }
                    }

                    Menu {
                        id: contextMenu5

                        MenuItem {
                            text: qsTr("Copy")
                            enabled: messageArea.selectedText
                            onTriggered: messageArea.copy()
                        }
                        MenuItem {
                            text: qsTr("Cut")
                            enabled: messageArea.selectedText
                            onTriggered: messageArea.cut()
                        }
                        MenuItem {
                            text: qsTr("Paste")
                            enabled: messageArea.canPaste
                            onTriggered: messageArea.paste()
                        }
                        MenuItem {
                            text: qsTr("Clear")
                            enabled: (messageArea.text.length !== 0)
                            onTriggered: messageArea.clear()
                        }
                        MenuItem {
                            text: qsTr("Select All")
                            enabled: (messageArea.text.length !== 0)
                            onTriggered: messageArea.selectAll()
                        }
                    }
                }
            }
        }

        ToolSeparator {
            leftPadding: 0
            rightPadding: 0

            Layout.fillHeight: true
            Layout.preferredHeight: 720

            Rectangle {
                id: warningsLabel
                y: window.height
                width: 175
                height: 45
                opacity: 0.81
                color: themeColor
                radius: 25
                anchors.horizontalCenter: parent.horizontalCenter

                PropertyAnimation {
                    id: warningsAnimation
                    target: warningsLabel
                    duration: 1500
                    properties: "y"
                    easing.type: Easing.InOutElastic

                    property var pos: (window.height / 2) - 250
                    to: (warningsLabel.y === pos) ? window.height : pos
                    onFinished: {
                        if (warningsLabel.y === pos) {
                            warningsColorAnimation.start()
                        } else {
                            warningsLabel.color = themeColor
                        }
                    }
                }

                ColorAnimation {
                    id: warningsColorAnimation
                    target: warningsLabel
                    property: "color"
                    duration: 500
                    easing.type: Easing.InOutBack
                    onFinished: warningsTimer.start()
                }

                Timer {
                    id: warningsTimer
                    interval: 3500
                    repeat: false
                    running: false
                    onTriggered: warningsAnimation.start()
                }

                Text {
                    id: warningsMessage
                    color: (warningsLabel.color === themeColor) ? "white" : 'black'
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                LayoutMirroring.childrenInherit: false
                LayoutMirroring.enabled: false
            }
        }

        ColumnLayout {
            id: columnLayoutLeft
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: true
            spacing: 10

            RowLayout {
                height: 100
                Layout.alignment: (isRightLayout ? Qt.AlignHCenter : Qt.AlignLeft) | Qt.AlignVCenter
                Layout.fillWidth: true
                spacing: 19

                ToolButton {
                    id: btnClear
                    icon.source: 'qrc:/clearlist'
                    display: AbstractButton.IconOnly
                    hoverEnabled: true

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: clear.start()
                    }

                    ToolTip {
                        x: -30
                        y: -35
                        delay: 150
                        parent: btnClear
                        visible: btnClear.hovered
                        text: qsTr('Clear List')
                    }

                    Timer {
                        id: clear
                        interval: 150
                        repeat: true
                        onTriggered: listView.model.count ? listView.model.remove(
                                                                0) : clear.stop(
                                                                )
                    }
                }

                TextField {
                    id: txtInput
                    padding: 5
                    focus: true
                    selectByMouse: true
                    persistentSelection: true
                    Layout.preferredWidth: 255

                    placeholderText: comboBox.currentText

                    onTextChanged: isEmail(txtInput.text)

                    Keys.onReturnPressed: {
                        if (isEmail(txtInput.text)) {
                            listView.model.append({
                                                      "email": txtInput.text
                                                  })
                            txtInput.text = ""
                        }
                    }

                    Keys.onDeletePressed: btnClear.clicked()

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.IBeamCursor
                        acceptedButtons: Qt.RightButton
                        onClicked: {
                            contextMenu3.x = mouse.x
                            contextMenu3.y = mouse.y
                            contextMenu3.open()
                        }
                    }

                    Menu {
                        id: contextMenu3

                        MenuItem {
                            text: qsTr("Copy")
                            enabled: txtInput.selectedText
                            onTriggered: txtInput.copy()
                        }
                        MenuItem {
                            text: qsTr("Cut")
                            enabled: txtInput.selectedText
                            onTriggered: txtInput.cut()
                        }
                        MenuItem {
                            text: qsTr("Paste")
                            enabled: txtInput.canPaste
                            onTriggered: txtInput.paste()
                        }
                        MenuItem {
                            text: qsTr("Clear")
                            enabled: (txtInput.text.length !== 0)
                            onTriggered: txtInput.clear()
                        }
                        MenuItem {
                            text: qsTr("Select All")
                            enabled: (txtInput.text.length !== 0)
                            onTriggered: txtInput.selectAll()
                        }
                    }

                    function isEmail(text) {
                        const pattern = /^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+\.[a-zA-Z0-9]+(?:\.[a-zA-Z0-9]+|)$/
                        var match = text.match(pattern)

                        if (txtInput.text)
                            statusEmail.visible = true
                        else
                            statusEmail.visible = false

                        if (match) {
                            statusEmail.color = Material.color(Material.Green)
                            statusEmailImg.source = "qrc:/true"
                            return true
                        } else {
                            statusEmail.color = Material.color(Material.Red)
                            statusEmailImg.source = "qrc:/clear"
                            return false
                        }
                    }

                    Rectangle {
                        id: statusEmail
                        width: 17
                        height: 17
                        radius: 20
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.verticalCenterOffset: -1
                        anchors.leftMargin: -23
                        color: "#fff000"
                        visible: false

                        Image {
                            id: statusEmailImg

                            anchors.fill: parent
                        }
                    }
                }

                ComboBox {
                    id: comboBox
                    font.pointSize: 7.5
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredWidth: 130

                    model: [qsTr("Receivers"), qsTr("CC"), qsTr("BCC")]
                }
            }

            ScrollView {
                leftPadding: 15
                rightPadding: 25
                antialiasing: true
                LayoutMirroring.enabled: true
                LayoutMirroring.childrenInherit: true
                Layout.rightMargin: isRightLayout ? 0 : 0
                Layout.leftMargin: isRightLayout ? 0 : 0
                Layout.fillWidth: true
                Layout.bottomMargin: -25
                Layout.topMargin: 25
                Layout.fillHeight: true

                ListView {
                    id: listView
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    antialiasing: true
                    model: setModel()

                    function setModel() {
                        return (comboBox.currentIndex
                                === 0) ? recModel : (comboBox.currentIndex
                                                     === 1) ? ccModel : bccModel
                    }

                    delegate: SwipeDelegate {
                        id: delegate
                        text: modelData
                        width: listView.width
                        LayoutMirroring.enabled: false
                        LayoutMirroring.childrenInherit: false
                        //! [delegate]
                        swipe.left: Rectangle {
                            width: parent.width
                            height: parent.height

                            clip: true
                            color: SwipeDelegate.pressed ? "#555" : "#666"

                            Label {
                                font.family: myFont.name
                                text: delegate.swipe.complete ? "\ue805 " + qsTr(
                                                                    'Restore') // icon-cw-circled
                                                              : "\ue801 " + qsTr(
                                                                    'Remove') // icon-cancel-circled-1

                                padding: 20
                                anchors.fill: parent
                                horizontalAlignment: Qt.AlignRight
                                verticalAlignment: Qt.AlignVCenter

                                opacity: delegate.swipe.position

                                color: Material.color(
                                           delegate.swipe.complete ? Material.Green : Material.Red,
                                           Material.Purple)
                                Behavior on color {
                                    ColorAnimation {}
                                }
                            }

                            SwipeDelegate.onClicked: delegate.swipe.close()
                            SwipeDelegate.onPressedChanged: undoTimer.stop()
                        }
                        //! [delegate]

                        //! [removal]
                        Timer {
                            id: undoTimer
                            interval: 3600
                            onTriggered: listView.model.remove(index)
                        }

                        swipe.onCompleted: undoTimer.start()
                        //! [removal]
                    }
                }
            }

            Rectangle {
                height: 2
                Layout.fillWidth: true
                color: themeColor
                Layout.bottomMargin: 1
            }
            ListModel {
                id: recModel
            }
            ListModel {
                id: ccModel
            }
            ListModel {
                id: bccModel
            }
        }
    }

    // SWIPE VIEW

    // ABOUT DIALOGE
    Dialog {
        id: aboutDialog
        modal: true
        focus: true
        title: qsTr("About")
        width: parent.height / 1.21
        x: (parent.width / 2) - (width / 2)
        y: (parent.height / 2) - (height / 2)

        contentHeight: aboutColumn.height

        Column {
            id: aboutColumn
            spacing: 20

            Label {
                width: aboutDialog.availableWidth
                text: qsTr('About Line one')
                wrapMode: Label.Wrap
                font.pixelSize: 15
            }

            Label {
                width: aboutDialog.availableWidth
                text: qsTr('About Line two')
                wrapMode: Label.Wrap
                font.pixelSize: 14
            }
        }
    }

    // LEFT SLIDE BAR ANIMATIONS
    PropertyAnimation {
        id: leftBarHover
        target: leftBar
        property: "width"
        to: (leftBar.width === 50) ? 5 : 50
        duration: 350
        easing.type: Easing.InOutQuad
        onToChanged: {
            var setOpacity = (leftBar.width === 50) ? 1 : 0
            btnExit.opacity = setOpacity
            btnInfo.opacity = setOpacity
            btnReact.opacity = setOpacity
            btnSettings.opacity = setOpacity
            btnShare.opacity = setOpacity

            btnExit.enabled = setOpacity
            btnInfo.enabled = setOpacity
            btnReact.enabled = setOpacity
            btnSettings.enabled = setOpacity
            btnShare.enabled = setOpacity
        }
    }

    // LEFT SLIDE BAR
    Rectangle {
        id: leftBar
        width: 5
        color: themeColor
        border.color: "#1c1d20"
        border.width: 1
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.bottomMargin: 0

        HoverHandler {
            target: leftBar
            onHoveredChanged: leftBarHover.start()
        }

        MouseArea {
            anchors.fill: parent
        }

        Column {
            id: column
            anchors.fill: parent
            topPadding: 7
            spacing: 75
            anchors.bottomMargin: 90

            ToolButton {
                id: btnReact
                width: 50
                Material.foreground: "white"
                icon.source: btnShare.isChecked ? 'qrc:/smile' : 'qrc:/sad'
                hoverEnabled: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                }

                ToolTip {
                    x: 50
                    y: 7
                    delay: 150
                    parent: btnReact
                    visible: btnReact.hovered
                    text: btnShare.isChecked ? qsTr("Thanks!") : qsTr(
                                                   "I'm Sad Share To Make Me Smile!")
                }
            }

            ToolButton {
                id: btnShare
                width: 50
                Material.foreground: "white"
                icon.source: 'qrc:/share'
                hoverEnabled: true

                property bool isChecked: false

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        btnShare.isChecked = true
                    }
                }

                ToolTip {
                    x: 50
                    y: 7
                    delay: 150
                    parent: btnShare
                    visible: btnShare.hovered
                    text: qsTr('SHARE')
                }
            }

            ToolButton {
                id: btnInfo
                width: 50
                Material.foreground: "white"
                icon.source: 'qrc:/info'
                hoverEnabled: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: aboutDialog.open()
                }

                ToolTip {
                    x: 50
                    y: 7
                    delay: 150
                    parent: btnInfo
                    visible: btnInfo.hovered
                    text: qsTr('INFO')
                }
            }

            ToolButton {
                id: btnSettings
                width: 50
                Material.foreground: "white"
                icon.source: 'qrc:/settings'
                hoverEnabled: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: settingsDialog.open()
                }

                ToolTip {
                    x: 50
                    y: 7
                    delay: 150
                    parent: btnSettings
                    visible: btnSettings.hovered
                    text: qsTr('Settings')
                }
            }
            ToolButton {
                id: btnExit
                width: 50
                icon.source: 'qrc:/quit'
                Material.foreground: "white"
                hoverEnabled: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: window.close()
                }

                ToolTip {
                    x: 50
                    y: 7
                    delay: 150
                    parent: btnExit
                    visible: btnExit.hovered
                    text: qsTr('Quit')
                }
            }
        }
    }

    // END LEFT SLIDE BAR

    // ACTIONS
    Action {
        id: optionsMenuAction
        onTriggered: {
            optionsMenu.open()
        }
    }

    BusyIndicator {
        id: sending
        width: 55
        height: 55
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 10
        LayoutMirroring.enabled: false
        LayoutMirroring.childrenInherit: false

        Image {
            width: 30
            height: 30
            anchors.verticalCenter: parent.verticalCenter
            source: themeSwitch.checked ? "qrc:/cancel" : "qrc:/clear"
            fillMode: Image.PreserveAspectFit
            sourceSize.height: 30
            sourceSize.width: 30
            anchors.horizontalCenter: parent.horizontalCenter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                sendEmail.visible = true
                con.cancel_message()
            }
            cursorShape: Qt.PointingHandCursor
        }

        ToolTip {
            x: 55
            y: 10
            delay: 150
            parent: sending
            visible: sending.hovered
            text: qsTr('Cancel')
        }
    }

    Rectangle {
        id: statusLabel
        x: -120
        width: 115
        height: 35
        opacity: 0.75
        color: themeColor
        radius: 25
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        LayoutMirroring.enabled: false
        LayoutMirroring.childrenInherit: false

        PropertyAnimation {
            id: statusLabelAnimation
            target: statusLabel
            duration: 1000
            properties: 'x'
            easing.type: Easing.InOutElastic
            to: (statusLabel.x === 75) ? -120 : 75
            onFinished: {
                if (statusLabel.x === 75) {
                    statuscolorAnimation.start()
                } else {
                    statusLabel.color = themeColor
                }
            }
        }

        ColorAnimation {
            id: statuscolorAnimation
            target: statusLabel
            property: "color"
            easing.type: Easing.InOutBack
            duration: 500
            onFinished: statusLabeltimer.start()
        }

        Timer {
            id: statusLabeltimer
            running: false
            repeat: false
            interval: 3500
            onTriggered: statusLabelAnimation.start()
        }

        Text {
            id: statusText
            color: "#ffffff"
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Action {
        id: openDrawerAction
        onTriggered: drawer.open()
    }

    // END ACTIONS

    // START HEADER
    header: ToolBar {
        Material.foreground: 'white'
        //        Material.primary: themeColor

        // Attach AND DROP WINDOW
        MouseArea {
            id: dragWindow
            height: 45
            anchors.leftMargin: 55
            anchors.rightMargin: 55
            anchors.left: parent.left
            anchors.right: parent.right
            property real lastMouseX: 0
            property real lastMouseY: 0
            onPressed: {
                lastMouseX = mouseX
                lastMouseY = mouseY
            }
            onMouseXChanged: window.x += (mouseX - lastMouseX)
            onMouseYChanged: window.y += (mouseY - lastMouseY)
        }

        // HEADER ITEMS
        RowLayout {
            spacing: 20
            anchors.fill: parent

            // HEADER LOGO
            TabButton {
                id: btnLogo
                Layout.leftMargin: 7
                Layout.preferredHeight: 35
                Layout.preferredWidth: 35
                display: AbstractButton.IconOnly

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Qt.openUrlExternally(lnkInsta)
                }

                ToolTip {
                    x: -195
                    y: 0
                    delay: 150
                    parent: btnLogo
                    visible: btnLogo.hovered
                    text: qsTr('Follow Dev. on instagram')
                }

                Image {
                    source: 'qrc:/logo'
                    anchors.fill: parent
                    Material.elevation: 6
                }
            }

            // HEADER TITLE
            Label {
                id: titleLabel
                text: "Al-Taie"
                font.pixelSize: 20
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            // MINIMIZE
            ToolButton {
                id: btnMinimize
                Layout.rightMargin: -25
                icon.source: 'qrc:/minimize'
                onClicked: window.showMinimized()
                enabled: !fullScreenSwitch.checked

                ToolTip {
                    x: 45
                    y: 5
                    delay: 150
                    parent: btnMinimize
                    visible: btnMinimize.hovered
                    text: qsTr('Minimize')
                }
            }

            // FULLSCREEN
            ToolButton {
                id: btnFullscreen
                Layout.rightMargin: -25
                icon.source: 'qrc:/fullscreen'
                onClicked: fullScreenSwitch.checked = fullScreenSwitch.checked ? false : true

                ToolTip {
                    x: 45
                    y: 5
                    delay: 150
                    parent: btnFullscreen
                    visible: btnFullscreen.hovered
                    text: fullScreenSwitch.checked ? qsTr('Exit Fullscreen') : qsTr(
                                                         'Fullscreen')
                }
            }

            // OPTIONS MENU
            ToolButton {
                id: mainMenu
                icon.source: 'qrc:/menu'
                action: optionsMenuAction

                ToolTip {
                    x: 45
                    y: 0
                    delay: 150
                    parent: mainMenu
                    visible: mainMenu.hovered
                    text: qsTr('Main Menu')
                }

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    Action {
                        text: qsTr("Settings")
                        onTriggered: settingsDialog.open()
                    }

                    Action {
                        text: qsTr("Instagram")
                        onTriggered: Qt.openUrlExternally(lnkInsta)
                    }

                    Action {
                        text: qsTr("About")
                        onTriggered: aboutDialog.open()
                    }

                    Action {
                        text: qsTr("Exit")
                        onTriggered: window.close()
                    }
                }
            }
        }
    }

    // END HEADER

    // RIGHT LINE
    PropertyAnimation {
        id: rightBarHover
        target: rightBar
        property: "width"
        to: (rightBar.width === 50) ? 5 : 50
        duration: 350
        easing.type: Easing.InOutQuad
        onToChanged: {
            var setOpacity = (rightBar.width === 50) ? 1 : 0
            btnFile.opacity = setOpacity
            btnImage.opacity = setOpacity
            btnAudio.opacity = setOpacity
            btnMailSettings.opacity = setOpacity
            closeRightSide.opacity = setOpacity

            btnFile.enabled = setOpacity
            btnImage.enabled = setOpacity
            btnAudio.enabled = setOpacity
            btnMailSettings.enabled = setOpacity
            closeRightSide.enabled = setOpacity
        }
    }

    RoundButton {
        id: openRightSide
        icon.source: isRightLayout ? 'qrc:/right' : 'qrc:/left'
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        rightPadding: isRightLayout ? 0 : 10
        leftPadding: isRightLayout ? 10 : 0
        anchors.rightMargin: -15

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                rightBarHover.start()
                openRightSide.enabled = false
            }
        }

        ToolTip {
            x: 50
            y: 7
            delay: 150
            parent: openRightSide
            visible: openRightSide.hovered
            text: qsTr('Open Side Menu')
        }
    }

    Rectangle {

        id: rightBar
        width: 5
        color: themeColor
        border.color: "#1c1d20"
        border.width: 1
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 0
        anchors.bottomMargin: 0
        anchors.rightMargin: 0

        Column {
            anchors.fill: parent
            topPadding: 7
            spacing: 75
            anchors.bottomMargin: 90

            ToolButton {
                id: btnFile
                width: 50
                Material.foreground: "white"
                icon.source: 'qrc:/file'
                hoverEnabled: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: fileDialog.open()
                }

                ToolTip {
                    x: 50
                    y: 7
                    delay: 150
                    parent: btnFile
                    visible: btnFile.hovered
                    text: qsTr("Attach File")
                }

                FileDialog {
                    id: fileDialog
                    title: qsTr('Please choose a file')
                    folder: shortcuts.home
                    nameFilters: ["All files (*)", "Archive files (*.rar *.zip *.tar *.tar.gz *.7z)"]
                    onAccepted: {
                        backend.setAttach(fileDialog.fileUrl, '', '')
                    }
                }
            }

            ToolButton {
                id: btnImage
                Material.foreground: "white"
                icon.source: 'qrc:/image'
                hoverEnabled: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: imageDialog.open()
                }

                ToolTip {
                    x: 50
                    y: 7
                    delay: 150
                    parent: btnImage
                    visible: btnImage.hovered
                    text: qsTr('Attach Image')
                }

                FileDialog {
                    id: imageDialog
                    title: qsTr('Please choose a Image file')
                    folder: shortcuts.home
                    nameFilters: ["Image files (*.jpg *.png, *.ico *.gif *.bmp)", "All files (*)"]
                    onAccepted: {
                        console.log(imageDialog.fileUrl)
                        backend.setAttach('', imageDialog.fileUrl, '')
                    }
                }
            }

            ToolButton {
                id: btnAudio
                width: 50
                Material.foreground: "white"
                icon.source: 'qrc:/audio'
                hoverEnabled: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: audioDialog.open()
                }

                ToolTip {
                    x: 50
                    y: 7
                    delay: 150
                    parent: btnAudio
                    visible: btnAudio.hovered
                    text: qsTr('Attach Audio')
                }

                FileDialog {
                    id: audioDialog
                    title: qsTr('Please choose Audio file')
                    folder: shortcuts.home
                    nameFilters: ["Audio files (*.mp3 *.ogg *.wav *.flac *.m4a *.aac)", "All files (*)"]
                    onAccepted: {
                        backend.setAttach('', '', audioDialog.fileUrl)
                    }
                }
            }

            ToolButton {
                id: closeRightSide
                width: 50
                Material.foreground: "white"
                icon.source: isRightLayout ? 'qrc:/left' : 'qrc:/right'
                hoverEnabled: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        rightBarHover.start()
                        openRightSide.enabled = true
                    }
                }

                ToolTip {
                    x: 50
                    y: 7
                    delay: 150
                    parent: closeRightSide
                    visible: closeRightSide.hovered
                    text: qsTr('Close Side Menu')
                }
            }

            ToolButton {
                id: btnMailSettings
                width: 50
                Material.foreground: "white"
                icon.source: 'qrc:/settings'
                hoverEnabled: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: loginDialog.open()
                }

                ToolTip {
                    x: 50
                    y: 7
                    delay: 150
                    parent: btnMailSettings
                    visible: btnMailSettings.hovered
                    text: qsTr('Mail Settings')
                }
            }
        }
    }

    // END RIGHT SLIDE LINE

    // SETTINGS DIALOG
    Dialog {
        id: settingsDialog

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        parent: Overlay.overlay

        focus: true
        modal: true
        title: qsTr("Settings")

        //        standardButtons: Dialog.Ok | Dialog.Cancel
        ColumnLayout {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                elide: Label.ElideRight
                Layout.topMargin: -3
                text: qsTr("General Settings")
                Layout.fillWidth: true
            }
            Label {
                id: warning
                visible: false
                text: qsTr('Reboot Required!')
                Layout.fillWidth: true
                color: Material.color(Material.Red)
            }
            Switch {
                id: arabicSwitch
                text: qsTr("Arabic")
                Layout.fillWidth: true
                checked: backend.language === 'ar'
                onCheckedChanged: {
                    arabicSwitch.checked ? backend.setLanguage(
                                               'ar') : backend.setLanguage('en')

                    warning.visible = (backend.language !== backend.getLanguage(
                                           ))
                }
            }

            Switch {
                id: ontopSwitch
                text: qsTr("Stay on Top")
                Layout.fillWidth: true
            }

            Switch {
                id: fullScreenSwitch
                text: qsTr("Full Screen")
                Layout.fillWidth: true
                onCheckedChanged: {

                    if (fullScreenSwitch.checked) {
                        txtInput.Layout.preferredWidth = 515
                        txtSubject.Layout.preferredWidth = 515
                    } else {
                        txtInput.Layout.preferredWidth = 255
                        txtSubject.Layout.preferredWidth = 220
                    }
                }
            }

            ColumnLayout {
                id: columnTheme
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                Label {
                    elide: Label.ElideRight
                    text: qsTr("Theme Settings")
                    Layout.fillWidth: true
                }

                Switch {
                    id: themeSwitch
                    text: qsTr("Dark Mode")
                    checked: (backend.getTheme() === 'dark')
                    onCheckedChanged: themeSwitch.checked ? backend.setTheme(
                                                                'dark') : backend.setTheme(
                                                                'light')
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    LayoutMirroring.enabled: false
                    LayoutMirroring.childrenInherit: false

                    spacing: 5

                    Rectangle {
                        id: colorPink
                        height: 35
                        width: 35
                        radius: 25
                        color: Material.color(Material.Pink)

                        ToolButton {
                            id: btnPink
                            anchors.fill: parent
                            icon.source: (themeColor === colorPink.color) ? 'qrc:/true' : ''
                            onClicked: {
                                themeColor = colorPink.color
                                backend.setColor('pink')
                            }

                            ToolTip {
                                x: -65
                                y: 0
                                delay: 150
                                parent: btnPink
                                visible: btnPink.hovered
                                text: qsTr('Pink')
                            }
                        }

                        Material.foreground: "white"
                    }

                    Rectangle {
                        id: colorTeal
                        height: 35
                        width: 35
                        radius: 25
                        color: Material.color(Material.Teal)

                        ToolButton {
                            id: btnTeal
                            anchors.fill: parent
                            icon.source: (themeColor === colorTeal.color) ? 'qrc:/true' : ''
                            onClicked: {
                                themeColor = colorTeal.color
                                backend.setColor('teal')
                            }

                            ToolTip {
                                x: btnTeal.x - (btnTeal.width / 2)
                                y: 40
                                delay: 150
                                parent: btnTeal
                                visible: btnTeal.hovered
                                text: qsTr('Teal')
                            }
                        }

                        Material.foreground: "white"
                    }

                    //                    Rectangle {
                    //                        id: colorOrange
                    //                        height: 35
                    //                        width: 35
                    //                        radius: 25
                    //                        color: Material.color(Material.DeepOrange)

                    //                        ToolButton {
                    //                            id: btnOrange
                    //                            anchors.fill: parent
                    //                            icon.source: (themeColor === colorOrange.color) ? 'qrc:/true' : ''
                    //                            onClicked: {
                    //                                themeColor = colorOrange.color
                    //                                backend.setColor('orange')
                    //                            }

                    //                            ToolTip {
                    //                                x: -10
                    //                                y: 40
                    //                                delay: 150
                    //                                parent: btnOrange
                    //                                visible: btnOrange.hovered
                    //                                text: qsTr('Orange')
                    //                            }
                    //                        }
                    //                        Material.foreground: "white"
                    //                    }
                    Rectangle {
                        id: colorBlue
                        height: 35
                        width: 35
                        radius: 25
                        color: Material.color(Material.Blue)

                        ToolButton {
                            id: btnBlue
                            anchors.fill: parent
                            icon.source: (themeColor === colorBlue.color) ? 'qrc:/true' : ''
                            onClicked: {
                                themeColor = colorBlue.color
                                backend.setColor('blue')
                            }

                            ToolTip {
                                x: 40
                                y: 0
                                delay: 150
                                parent: btnBlue
                                visible: btnBlue.hovered
                                text: qsTr('Blue')
                            }
                        }

                        Material.foreground: "white"
                    }
                }
            }
        }
    }

    // END SETTINGS DIALOG

    // MAIL SETTINGS DIALOG
    Dialog {
        id: loginDialog

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 350
        parent: Overlay.overlay

        focus: true
        modal: true
        title: qsTr("Mail Settings")
        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: {
            backend.setLogin(txtEmail.text, txtPassword.text)
            backend.setSettings(1, 0, multiSwitch.checked)
        }

        ColumnLayout {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            Label {
                elide: Label.ElideRight
                text: qsTr("General Settings")
                Layout.fillWidth: true
            }

            Switch {
                id: multiSwitch
                text: qsTr("Multi Message")
            }

            Label {
                elide: Label.ElideRight
                text: qsTr("Login")
                Layout.fillWidth: true
            }

            TextField {
                id: txtEmail
                focus: true
                selectByMouse: true
                persistentSelection: true
                placeholderText: qsTr("Email")
                Layout.fillWidth: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.IBeamCursor
                    acceptedButtons: Qt.RightButton
                    onClicked: {
                        contextMenu1.x = mouse.x
                        contextMenu1.y = mouse.y
                        contextMenu1.open()
                    }
                }

                Menu {
                    id: contextMenu1

                    MenuItem {
                        text: qsTr("Copy")
                        enabled: txtEmail.selectedText
                        onTriggered: txtEmail.copy()
                    }
                    MenuItem {
                        text: qsTr("Cut")
                        enabled: txtEmail.selectedText
                        onTriggered: txtEmail.cut()
                    }
                    MenuItem {
                        text: qsTr("Paste")
                        enabled: txtEmail.canPaste
                        onTriggered: txtEmail.paste()
                    }
                    MenuItem {
                        text: qsTr("Clear")
                        enabled: (txtEmail.text.length !== 0)
                        onTriggered: txtEmail.clear()
                    }
                    MenuItem {
                        text: qsTr("Select All")
                        enabled: (txtEmail.text.length !== 0)
                        onTriggered: txtEmail.selectAll()
                    }
                }
            }
            TextField {
                id: txtPassword
                focus: true
                selectByMouse: true
                persistentSelection: true
                placeholderText: qsTr("Password")
                echoMode: TextField.PasswordEchoOnEdit
                Layout.fillWidth: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.IBeamCursor
                    acceptedButtons: Qt.RightButton
                    onClicked: {
                        contextMenu2.x = mouse.x
                        contextMenu2.y = mouse.y
                        contextMenu2.open()
                    }
                }

                Menu {
                    id: contextMenu2

                    MenuItem {
                        text: qsTr("Copy")
                        enabled: txtPassword.selectedText
                        onTriggered: txtPassword.copy()
                    }
                    MenuItem {
                        text: qsTr("Cut")
                        enabled: txtPassword.selectedText
                        onTriggered: txtPassword.cut()
                    }
                    MenuItem {
                        text: qsTr("Paste")
                        enabled: txtPassword.canPaste
                        onTriggered: txtPassword.paste()
                    }
                    MenuItem {
                        text: qsTr("Clear")
                        enabled: (txtPassword.text.length !== 0)
                        onTriggered: txtPassword.clear()
                    }
                    MenuItem {
                        text: qsTr("Select All")
                        enabled: (txtPassword.text.length !== 0)
                        onTriggered: txtPassword.selectAll()
                    }
                }
            }
        }
    }

    // END MAIL SETTINGS DIALOG

    //    ColorDialog {
    //        id: colorDialog
    //        title: "Please choose a color"
    //        onAccepted: console.log("color = " + colorDialog.color)
    //    }

    // SEND ROUNDER Button
    function getList(listmodel) {
        var result = []

        for (var i = 0; i < listmodel.count; i++) {

            result.push(recModel.get(i).email)
        }
        return result
    }

    function setMail() {
        var subject = txtSubject.text
        var message = messageArea.text

        backend.setInfo(getList(recModel), getList(ccModel), getList(bccModel),
                        subject, message)
    }

    RoundButton {
        id: sendEmail
        width: 55
        height: 55
        icon.source: 'qrc:/send'
        highlighted: true
        anchors.margins: 10
        display: AbstractButton.IconOnly
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        LayoutMirroring.enabled: false
        LayoutMirroring.childrenInherit: false

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (txtEmail.text && txtPassword.text) {
                    setMail()
                    sendEmail.visible = false
                    backend.sendMessage()
                } else {
                    loginDialog.open()
                }
            }
        }

        ToolTip {
            x: 55
            y: 10
            delay: 150
            parent: sendEmail
            visible: sendEmail.hovered
            text: qsTr('Send')
        }
    }

    // HANDELING BACKEND WARNINGS
    Connections {
        target: con

        function onWarningChanged(warning) {
            if (warning === 'sizeLimited') {
                warningsMessage.text = qsTr("Size Limited To") + ': 50KB'
                warningsColorAnimation.to = Material.color(Material.Yellow)
                warningsAnimation.start()
            } else if (warning === '') {
                console.log(status)
            }
        }
    }

    // HANDELING SENT MESSAGE STATUS
    Connections {
        target: con

        function onCurrentStatusChanged(status) {
            if (status) {
                console.log(status)
                statusText.text = qsTr("Successed") + '!'
                statuscolorAnimation.to = Material.color(Material.Green)
                statusLabelAnimation.start()
            } else {
                console.log(status)
                statusText.text = qsTr("Failed") + '!'
                statuscolorAnimation.to = Material.color(Material.Red)
                statusLabelAnimation.start()
            }
            sendEmail.visible = true
        }
    }
}
