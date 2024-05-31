import QtQuick 2.15
import QtQuick.Controls 2.15
import Sudoku 1.0
import Theme 1.0

Window {
    color: Theme.overallBackgroundColor

    id: rootWindow
    visible: true
    width: 600
    height: 800
    minimumWidth: 600
    minimumHeight: 800
    maximumHeight: 1000
    maximumWidth: 800
    // color: Theme.overallBackgroundColor
    title: qsTr("Sudoku")

    property bool showWelcomePage: true

    function resumeGame() {
        // sudoku.sudokuHeader.timer.running = true
    }

    // Audio {
    //     id: backgroundMusic
    //     source: "qrc:/assets/audio/amb-majhong-.mp3"
    //     loop: Audio.Infinite
    //     volume: 0.8
    //     autoPlay: true
    // }

    // Audio {
    //     id: startMusic
    //     source: "qrc:/assets/audio/main-menu-theme.mp3"
    //     volume: 0.8
    // }

    WelcomePage {
        anchors.fill: parent
        visible: showWelcomePage
        onStartClicked: {
            showWelcomePage = false
            // backgroundMusic.stop()
            // startMusic.play()
        }
        onExitClicked: {
            Qt.quit()
        }
    }

    Sudoku{
        id: sudoku
        // anchors.fill: parent
        // width: parent.width*0.8
        // height:parent.height*0.8
        visible: !showWelcomePage
        onSettingsClicked: {
            settingsDialog.open()
        }
    }

    SettingsDialog {
        id: settingsDialog
        // onAccepted: {
        //     resumeGame()
        // }
    }
}
