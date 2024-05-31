import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import Sudoku 1.0
import Theme 1.0

Dialog {
    id: settingsDialog
    modal: true
    width: parent.width
    height: parent.height
    visible: false

    signal gameStateChanged(string msg);

    background: Rectangle{
        color: Theme.overallBackgroundColor
    }

    Column {
        anchors.centerIn: parent
        spacing: 20

        Button {
            text: "Resume"
            width: 200
            height: 50
            background: Rectangle {
                color: Theme.buttonBackgroundColor
                radius: 5
            }
            contentItem: Text {
                text: "Resume"
                color: Theme.buttonTextColor
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                settingsDialog.close()
            }
        }

        Button {
            text: "Reset"
            width: 200
            height: 50
            background: Rectangle {
                color: Theme.buttonBackgroundColor
                radius: 5
            }
            contentItem: Text {
                text: "Reset"
                color: Theme.buttonTextColor
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                settingsDialog.close()
                console.log("Board reset");
                SudokuModel.handleGameStateChanged("reset");
                sudokuHeader.resetTimer(); // Call resetTimer function
            }
        }

        Button {
            width: 200
            height: 50
            text: "Solve"
            background: Rectangle {
                color: Theme.buttonBackgroundColor
                radius: 5
            }
            contentItem: Text {
                text: "Solve"
                color: Theme.buttonTextColor
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                settingsDialog.close()
                SudokuModel.handleGameStateChanged("solve");
            }
        }

        Button {
            width: 200
            height: 50
            text: "Exit"
            background: Rectangle {
                color: Theme.buttonBackgroundColor
                radius: 5
            }
            contentItem: Text {
                text: "Exit"
                color: Theme.buttonTextColor
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                Qt.quit()
            }
        }
    }
}
