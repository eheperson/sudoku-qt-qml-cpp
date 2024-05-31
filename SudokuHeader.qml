import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Sudoku 1.0
import Theme 1.0

Item {
    id: sudokuHeader
    width: parent.width

    property int elapsedTime: 0
    signal settingsClicked()

    function resetTimerSlot(){
        elapsedTime = 0
    }

    function formatTime(totalSeconds) {
        var hours = Math.floor(totalSeconds / 3600);
        var minutes = Math.floor((totalSeconds % 3600) / 60);
        var seconds = totalSeconds % 60;
        return (hours < 10 ? "0" : "") + hours + ":" +
               (minutes < 10 ? "0" : "") + minutes + ":" +
               (seconds < 10 ? "0" : "") + seconds;
    }

    function resetTimer() {
        timer.running = false;
        elapsedTime = 0;
        timer.start();  // Restart the timer if needed
    }

    RowLayout {
        id: headerRow
        anchors.fill: parent
        width: parent.width
        anchors.margins: 30
        spacing: 20

        Row {
            Layout.fillWidth: true
            Layout.preferredWidth: parent.width / 3
            spacing: 2

            Repeater {
                model: SudokuModel.health
                delegate: Image {
                    source: "qrc:/assets/icons/star.png"
                    width: 25
                    height: 25
                }
            }
        }

        Rectangle {
            id: gameTimer
            color: "transparent"
            Layout.fillWidth: true
            Layout.preferredWidth: parent.width / 3
            height: parent.height

            // Timer {
            //     id: timer
            //     interval: 1000
            //     repeat: true
            //     running: true

            //     onTriggered: {
            //         elapsedTime += 1
            //     }
            // }

            Text {
                id: timerText
                anchors.centerIn: parent
                text: "Sudoku"
                font.bold: false
                font.pixelSize: parent.width/4
                color: Theme.textColor
            }
        }

        Rectangle {
            color: "transparent"
            Layout.fillWidth: true
            Layout.preferredWidth: parent.width / 3
            height: parent.height

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // timer.running = false
                    sudokuHeader.settingsClicked()
                    console.log("Settings icon clicked")
                }

                Image {
                    anchors.centerIn: parent
                    source: "qrc:/assets/icons/setting.png"
                    width: 50
                    height: 50
                }
            }
        }
    }

    Connections {
        target: WelcomePage
        onStartClicked: {
            timer.running = false
        }
    }
}
