import QtQuick 2.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls 2.15

ApplicationWindow {
    id: splash
    width: 850
    height: 500
    visible: true
    flags: Qt.SplashScreen

    property int timeoutInterval: 3500

    // SPLASH IMAGE
    Image {
        anchors.fill: parent
        source: "qrc:/splash"

        ProgressBar {
            id: progressBar
            x: (320 / 2) - (width / 2)
            y: 300
            value: 0
            Material.accent: Material.color(Material.Pink)
        }
    }

    // END IMAGE

    // TIMER
    Timer {
        id: timer
        interval: 200
        running: true
        repeat: true
        onTriggered: {

            if (progressBar.value === 1) {
                timer.stop()
                splash.close()
            } else {
                progressBar.value += 0.09
            }
        }
    }

    // END TIMER
}
