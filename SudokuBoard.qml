import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import Sudoku 1.0
import Theme 1.0

Item {
    id: sudokuBoard
    signal gameStateChanged(string msg)

    property int boardSize: (parent.width * 0.7)
    property int cellSize: boardSize / 11
    property int cellMargin: 1
    property int focusedIndex: 0
    property bool gameLoaded: false
    property int cellCount: 9
    // proper

    width: parent.width * 0.8
    height: parent.height * 0.8

    GridView {
        id: sudokuGrid
        model: SudokuModel
        anchors.centerIn: parent
        currentIndex: focusedIndex

        width: sudokuBoard.cellSize * cellCount + sudokuBoard.cellMargin * cellCount * 2
        height: sudokuBoard.cellSize * cellCount + sudokuBoard.cellMargin * cellCount * 2
        cellWidth: sudokuBoard.cellSize + sudokuBoard.cellMargin
        cellHeight: sudokuBoard.cellSize + sudokuBoard.cellMargin


        delegate: Rectangle {
            width: sudokuBoard.cellSize + sudokuBoard.cellMargin
            height: sudokuBoard.cellSize + sudokuBoard.cellMargin

            border.color: Theme.cellBorderColor
            border.width: (sudokuGrid.currentIndex === index) ? 3 : 0.5
            radius: 2

            color: model.readOnly ? Theme.cellDisabledColor : Theme.cellBackgroundColor

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (!model.readOnly) {
                        focusedIndex = index;
                        sudokuGrid.currentIndex = index;
                    }
                }
            }

            TextField {
                enabled: focus
                id: sudokuCell
                validator: IntValidator { bottom: 0; top: 9 }
                background: Rectangle { id: cellArea; color: "transparent" }

                inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhFormattedNumbersOnly
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: sudokuBoard.cellSize / 2
                focus: sudokuGrid.currentIndex === index
                color: Theme.cellTextColor

                readOnly: model.readOnly
                text: model.value !== 0 ? model.value.toString() : ""

                onTextChanged: {
                    let num = parseInt(text);
                    let idx = sudokuGrid.model.index(index, 0);
                    let tmp;

                    if (!sudokuCell.readOnly && sudokuCell.activeFocus) {
                        tmp = num;
                        sudokuGrid.model.setData(idx, 0, SudokuModel.valueRole);
                        if (SudokuModel.isValidMove(index, num)) {
                            sudokuGrid.model.setData(idx, num, SudokuModel.valueRole);
                            parent.color = Theme.cellBackgroundColor;
                        // } else if (sudokuGrid.model.data(sudokuGrid.model.index(index, 0), SudokuModel.readOnlyRole) !== num) {
                        //     parent.color = Theme.cellInvalidColor;
                        } else if (text === '' ){
                            parent.color = Theme.cellBackgroundColor;
                        } else if (text === '0') {
                            parent.color = Theme.cellBackgroundColor;
                            text = ''
                        } else {
                            parent.color = Theme.cellInvalidColor;
                            sudokuGrid.model.setData(idx, 0, SudokuModel.valueRole);
                            SudokuModel.decreaseHealth();
                        }
                    }

                }
            }
        }

        focus: true
        Keys.onReleased: event => {
            if (focusedIndex === -1) {
                focusedIndex = 0;
            }

            var row = Math.floor(focusedIndex / 9);
            var col = focusedIndex % 9;

            var initialRow = row;
            var initialCol = col;

            if (event.key === Qt.Key_Left || event.key === Qt.Key_A) {
                do {
                    col = (col - 1 + 9) % 9;
                    if (col === initialCol && row === initialRow) break;
                } while (sudokuGrid.model.data(sudokuGrid.model.index(row * 9 + col, 0), SudokuModel.readOnlyRole));
            } else if (event.key === Qt.Key_Right || event.key === Qt.Key_D) {
                do {
                    col = (col + 1) % 9;
                    if (col === initialCol && row === initialRow) break;
                } while (sudokuGrid.model.data(sudokuGrid.model.index(row * 9 + col, 0), SudokuModel.readOnlyRole));
            } else if (event.key === Qt.Key_Up || event.key === Qt.Key_W) {
                do {
                    row = (row - 1 + 9) % 9;
                    if (col === initialCol && row === initialRow) break;
                } while (sudokuGrid.model.data(sudokuGrid.model.index(row * 9 + col, 0), SudokuModel.readOnlyRole));
            } else if (event.key === Qt.Key_Down || event.key === Qt.Key_S) {
                do {
                    row = (row + 1) % 9;
                    if (col === initialCol && row === initialRow) break;
                } while (sudokuGrid.model.data(sudokuGrid.model.index(row * 9 + col, 0), SudokuModel.readOnlyRole));
            }

            var newFocusIndex = row * 9 + col;
            if (sudokuGrid.model.data(sudokuGrid.model.index(newFocusIndex, 0), SudokuModel.readOnlyRole) === false) {
                focusedIndex = newFocusIndex;
                sudokuGrid.currentIndex = newFocusIndex;
            }

            let idx = sudokuGrid.model.index(focusedIndex, 0);

            if (focus) {
                if (event.key >= Qt.Key_0 && event.key <= Qt.Key_9) {
                    var num = event.key - Qt.Key_0;
                    if (num >= 1 && num <= 9) {
                        sudokuGrid.model.setData(idx, num, SudokuModel.valueRole);
                    }
                }
            }
        }
    }

    Connections {
        target: sudokuPanel
        function onPanelCellClicked(index) {
            let val = index+1
            let  idx = sudokuGrid.model.index(focusedIndex, 0)
            sudokuGrid.currentIndex = focusedIndex;
            console.log("Panel cell clicked at index : " + idx);
            console.log("Focus is at index           : " + focusedIndex);
            console.log("idx is at index             : " + focusedIndex);
            sudokuGrid.model.setData(idx, val, SudokuModel.valueRole);

        }
    }

    Connections {
        target: settingsDialog
        function onGameStateChanged(msg) {
            SudokuModel.handleGameStateChanged(msg);
        }
    }

    Connections {
        target: SudokuModel
        function onLevelFailed() {
            console.log("Game failed - -- - - - - - -- - - ");
            levelFailPopup.open();
        }

        function onLevelWon() {
            console.log("Level won");
            levelWinPopup.open();
        }

        function onGameReset() {
            console.log("Gmae Reset")
            sudokuGrid.model = null
            sudokuGrid.model = SudokuModel
            focusedIndex = 0
            sudokuGrid.currentIndex = focusedIndex;

        }

    }

    Popup {
        id: levelFailPopup
        modal: true
        width: 300
        height: 200
        closePolicy: Popup.NoAutoClose
        anchors.centerIn: parent
        Column {
            anchors.centerIn: parent
            spacing: 10

            Text {
                text: "Game Failed"
                font.pixelSize: 20
            }

            Row {
                spacing: 10
                Button {
                    text: "Reset"
                    onClicked: {
                        levelFailPopup.close();
                        SudokuModel.handleGameStateChanged("reset");
                    }
                }

                Button {
                    text: "Exit"
                    onClicked: {
                        Qt.quit();
                    }
                }
            }
        }
    }

    Popup {
        id: levelWinPopup
        modal: true
        width: 300
        height: 200
        closePolicy: Popup.NoAutoClose
        anchors.centerIn: parent
        Column {
            anchors.centerIn: parent
            spacing: 10

            Text {
                text: "Level Won!"
                font.pixelSize: 20
            }

            Row {
                spacing: 10
                Button {
                    text: "Next Level"
                    onClicked: {
                        levelWinPopup.close();
                        SudokuModel.handleGameStateChanged("nextlevel");
                    }
                }

                Button {
                    text: "Exit"
                    onClicked: {
                        Qt.quit();
                    }
                }
            }
        }
    }
}
