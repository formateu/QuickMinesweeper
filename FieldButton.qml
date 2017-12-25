import QtQuick 2.0
import QtQuick.Layouts 1.3

Rectangle {
    id: fieldButton
    property double cellSize: 100
    width: cellSize
    height: width
    color: "lightgray"
    Layout.fillHeight: true
    Layout.fillWidth: true
    antialiasing: true
    property alias img: btnImg
    property alias txt: cnt
    //game logic
    property bool mine: false
    property int xPos: 0
    property int yPos: 0
    property int neighbourMines: 0

    Text {
        id: cnt
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        //color: "lightgray"
        font.pixelSize: 0.8 * parent.height
        text: +neighbourMines
        visible: false
    }

    Image {
        id: btnImg
        anchors.fill: parent
        //smooth: true <- set by default
    }

    states: [
        State {
            name: "discoveredMine"
            PropertyChanges { target: fieldButton; color: "red" }
            PropertyChanges { target: btnImg; source: "mine.png" }
        },
        State {
            name: "flag"
            PropertyChanges { target: btnImg; source: "flag.png"}
        },
        State {
            name: "discovered"
            PropertyChanges {
                target: fieldButton
                txt.visible: neighbourMines ? true : false
                color: "white"
            }
        }
    ]

    transitions: [
        Transition {
            PropertyAnimation {
                properties: "color, img.source, txt";
                easing.type: Easing.InSine;
                duration: 100
            }
        }
    ]
}
