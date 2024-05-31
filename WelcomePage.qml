import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 2.15
import Theme 1.0

Item {
    id: welcomePage
    anchors.fill: parent

    signal startClicked()
    signal exitClicked()

    Rectangle {
        anchors.fill: parent
        color: Theme.overallBackgroundColor

        Column {
            anchors.centerIn: parent
            spacing: 20

            Image {
                id: cubeImage
                source: "qrc:/assets/images/sudoku-logo.png"
                width: 200
                height: 200
                fillMode: Image.PreserveAspectFit
            }

            Button {
                id: startButton
                text: "Start"
                width: 200
                height: 50
                font.pixelSize: 20
                onClicked: {
                    cubeImageSequential.start();
                    welcomePage.startClicked();
                }
                background: Rectangle {
                    color: Theme.buttonBackgroundColor
                    radius: 10
                    border.color: Theme.buttonBorderColor
                }
                contentItem: Text {
                    text: startButton.text
                    color: Theme.buttonTextColor
                    font.pixelSize: exitButton.font.pixelSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                }

            }

            Button {
                id: exitButton
                text: "Exit"
                width: 200
                height: 50
                font.pixelSize: 20
                onClicked: welcomePage.exitClicked()
                background: Rectangle {
                    color: Theme.buttonBackgroundColor
                    radius: 10
                    border.color: Theme.buttonBorderColor
                }
                contentItem: Text {
                    text: exitButton.text
                    color: Theme.buttonTextColor
                    font.pixelSize: exitButton.font.pixelSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                }
            }
        }
    }

    SequentialAnimation {
        id: cubeImageSequential
        loops: 1
        running: false
        PropertyAnimation {
            target: cubeImage
            property: "rotation"
            to: 360
            duration: 1000
        }
        ScriptAction {
            script: {
                welcomePage.startClicked();
            }
        }
    }
}
