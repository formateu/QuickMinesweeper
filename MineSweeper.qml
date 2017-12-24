import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.2

ApplicationWindow {
    id: root
    visible: true
    minimumHeight: Screen.desktopAvailableHeight/4
    minimumWidth: minimumHeight
    height: minimumHeight
    width: minimumHeight
    maximumHeight: width*16/9
    maximumWidth: height*2.2
    color: "#000000" //revealed color
    title: qsTr("Minesweeper QtQuick")

    StackView {
        id: stack
        initialItem: board
        anchors.fill: parent

        Component {
            id: board
            GameBoard{}
        }
    }
}
