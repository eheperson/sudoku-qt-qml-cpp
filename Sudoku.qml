import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: sudoku
    anchors.fill: parent

    signal settingsClicked()

    ColumnLayout {
        anchors.fill: parent
        spacing: 2

        SudokuHeader {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height / 10
            onSettingsClicked: {
                sudoku.settingsClicked()
            }
        }

        SudokuBoard {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            width: parent.width * 0.8
            height: parent.height * 0.8
            boardSize: parent.height * 0.7
            // Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }


        SudokuPanel {
            id: sudokuPanel
            Layout.fillWidth: true
            // width: parent.width
            Layout.preferredHeight: parent.height / 11
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
        }
    }
}
