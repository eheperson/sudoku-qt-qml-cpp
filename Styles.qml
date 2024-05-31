// Styles.qml
import QtQuick 2.15

pragma Singleton

QtObject {
    property color textColor: "#e0e0e0"
    property color cellTextColor: "#cccccc"  // Color for cell text
    property color cellBackgroundColor: "#2c2c2c"
    property color cellBorderColor: "#1a1a1a"
    property color boldCellBorderColor: "#ff4500"
    property color overallBackgroundColor: "#5b5b5b"
    property color buttonBackgroundColor: "#007acc"
    property color buttonTextColor: "#dcdcdc"  // Changed to a less bright color
    property color generalTextColor: "#dcdcdc"
    property color buttonBorderColor: "#005f99"
    property color cellDisabledColor: "#555555"  // Color for disabled cells (read-only)
    property color cellInvalidColor: "#ff4d4d"  // Color for invalid cells
    property color cellActiveColor: "#4caf50"

    property var colorPalette: [
        "#FFFFFF", // default for empty cell
        "#DCEDC8", // color for 1
        "#F8BBD0", // color for 2
        "#E1BEE7", // color for 3
        "#D1C4E9", // color for 4
        "#C5CAE9", // color for 5
        "#BBDEFB", // color for 6
        "#B2DFDB", // color for 7
        "#C8E6C9", // color for 8
        "#FFCDD2"  // color for 9
    ]
}
