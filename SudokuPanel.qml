import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import Theme 1.0

Item {
    id: sudokuPanel

    property int boardSize: (parent.width * 0.7)
    property int cellSize: boardSize / 8
    property int cellMargin: 1
    width: parent.width * 0.8
    height: parent.height * 0.8

    signal panelCellClicked(int index)

    GridView {
        id: gridView
        model: 9
        x: parent.x + sudokuPanel.cellSize
        width: sudokuPanel.cellSize * 10 + sudokuPanel.cellMargin * 10 * 2
        height: sudokuPanel.cellSize * 10 + sudokuPanel.cellMargin * 10 * 2
        cellWidth: sudokuPanel.cellSize + 2 * sudokuPanel.cellMargin
        cellHeight: sudokuPanel.cellSize + 2 * sudokuPanel.cellMargin

        delegate: Rectangle {
            width: sudokuPanel.cellSize
            height: sudokuPanel.cellSize
            anchors.margins: sudokuPanel.cellMargin
            border.color: Theme.cellBorderColor
            border.width: 1
            radius: 2
            color: Theme.cellBackgroundColor

            TextField {
                id: panelCell
                anchors.fill: parent
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                validator: IntValidator { bottom: 1; top: 9 }
                background: Rectangle { color: "transparent" }
                readOnly: true
                text: (index + 1).toString() // Update the text to be 1-base
                color: Theme.cellTextColor
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    sudokuPanel.panelCellClicked(index)
                }
            }
        }
    }
}
