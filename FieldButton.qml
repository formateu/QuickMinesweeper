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
    property alias img: btnImg
    property alias txt: cnt
    //game logic
    property bool mine: false
    property int xPos: 0
    property int yPos: 0
    property int neighbourMines: 0
    signal revealNeighbours(int xPos, int yPos)
    signal gameWon()
    signal gameOver()

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

    MouseArea {
        id: mouseArea
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.fill: parent
        onClicked: {
            if (fieldButton.state == '' && mouse.button & Qt.LeftButton) {
                if (fieldButton.mine) {
                    fieldButton.state = 'discoveredMine';
                    fieldButton.gameOver();
                } else {
                    fieldButton.state = 'discovered';
                    fieldButton.revealNeighbours(xPos, yPos);
                }
            } else if (mouse.button & Qt.RightButton) {
                flipFlag();
            }
        }

        function flipFlag() {
            if (fieldButton.state == '') {
                fieldButton.state = 'flag';
            } else if (fieldButton.state == 'flag') {
                fieldButton.state = '';
            }
        }
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
                easing.type: Easing.InExpo;
                duration: 100
            }
        }
    ]
}
