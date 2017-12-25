import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 1.4

ApplicationWindow {
    id: root
    visible: true
    minimumHeight: Screen.desktopAvailableHeight/2
    minimumWidth: minimumHeight
    height: minimumHeight
    width: minimumHeight
    maximumHeight: width*16/9
    maximumWidth: height*2.2
    color: "#000000" //revealed color
    title: qsTr("Minesweeper QtQuick")

    menuBar: MenuBar {
        Menu {
            title: "Game"
            MenuItem {
                text: "New Game...";
                onTriggered: {
                    stack.pop(board);
                    stack.push({item: board});
                }
            }
            Menu {
                title: "Size..."
                MenuItem {
                    text: "10x10";
                    onTriggered: {
                        stack.pop(board);
                        stack.push({item: board, properties: {columns: 10}});
                    }
                }
                MenuItem {
                    text: "13x13";
                    onTriggered: {
                        stack.pop(board);
                        stack.push({item: board, properties: {columns: 13}});
                    }
                }
                MenuItem {
                    text: "19x19";
                    onTriggered: {
                        stack.pop(board);
                        stack.push({item: board, properties: {columns: 19}});
                    }
                }
            }

            MenuItem { text: "Close"; onTriggered: root.close() }
        }
    }

    StackView {
        id: stack
        initialItem: board
        anchors.fill: parent
        antialiasing: true
//        delegate: StackViewDelegate {

//        }

        Component { id: board; GameBoard {} }
    }
}
