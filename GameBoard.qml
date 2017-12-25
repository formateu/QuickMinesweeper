import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

GridLayout {
    id: fieldGrid
    columns: 10
    rowSpacing: 1
    columnSpacing: rowSpacing
    rows: columns
    property int currIndex: 0
    antialiasing: true
    //anchors.fill: parent

    readonly property var colorEnum: {
        1 : "blue",
        2 : "green",
        3 : "red",
        4 : "midnightblue",
        5 : "darkred",
        6 : "darkcyan",
        7 : "black",
        8 : "gray"
    }

    property int minesCnt: 0
    property int minesRemaining: 0
    property int flagCount: 0
    property int fieldsRemaining: 0

    ResultDialog {
        id: gameOverPopup
        title: "Game Over"
        contentItem: Text {
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "darkred"
            font.pixelSize: 0.1 * gameOverPopup.height
            text: "You have lost!"
        }
    }

    ResultDialog {
        id: gameWinPopup
        title: "Congratulations!!"
        contentItem: Text {
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "green"
            font.pixelSize: 0.1 * gameOverPopup.height
            text: "Contratulations!!\n You WIN!!!"
        }
    }

    Repeater {
        id: repeater
        model: columns * columns
        onItemAdded: {
            var neigbours = itemAt(index).neighbourMines;
            //some chance, unknown distribution
            // TODO:
            // use random-js
            var isMine = Math.floor(Math.random()*10);
            if (isMine < 3) {
                itemAt(index).mine = true;
                ++minesCnt;
                ++minesRemaining;
            }
            itemAt(index).xPos = index % columns;
            itemAt(index).yPos = index / columns;
        }

        FieldButton {
            id: fieldButton
            MouseArea {
                id: mouseArea
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                anchors.fill: parent
                onClicked: {
                    if (fieldButton.state == '' && mouse.button & Qt.LeftButton) {
                        if (fieldButton.mine) {
                            fieldButton.state = 'discoveredMine';
                            repeater.gameOver();
                        } else {
                            fieldButton.state = 'discovered';
                            --fieldsRemaining;

                            if (fieldButton.neighbourMines === 0) {
                                repeater.recursiveReveal(xPos, yPos);
                            }

                            if (!fieldsRemaining && !minesRemaining) {
                                repeater.gameWin();
                            }
                        }
                    } else if (mouse.button & Qt.RightButton) {
                        flipFlag();
                    }
                }

                function flipFlag() {
                    if (fieldButton.state === '') {
                        if (repeater.canPutFlag()) {
                            fieldButton.state = 'flag';
                            repeater.flagged(fieldButton.mine);

                        }
                    } else if (fieldButton.state === 'flag') {
                        fieldButton.state = '';
                        repeater.unFlagged(fieldButton.mine);
                    }
                }
            }
        }

        Component.onCompleted: {
            fieldsRemaining = model - minesRemaining;
            flagCount = minesRemaining;

            for (var x = 0; x < columns; ++x) {
                for (var y = 0; y < rows; ++y) {
                    var neighbours = surroundings(x, y, getFieldBomb);
                    var minesCnt = 0;

                    Object.keys(neighbours).forEach(function(key) {
                        if (neighbours[key] === true) ++minesCnt;
                    });

                    if (minesCnt) {
                        var index = x + y*columns;
                        itemAt(index).neighbourMines = minesCnt;
                        itemAt(index).txt.color = colorEnum[minesCnt];
                    }
                }
            }
        }

        function inScope(x, y) {
            return x >= 0 && x < columns && y >= 0 && y < rows;
        }

        function getFieldProperty(x, y, prprty) {
            return inScope(x, y)
                    ? itemAt(x + y*columns)[prprty]
                    : undefined;
        }

        function getFieldBomb(x, y) { return getFieldProperty(x, y, 'mine'); }

        function getBombCount(x, y) {
            return {
                'x' : x,
                'y' : y,
                'mineCount' : getFieldProperty(x, y, 'neighbourMines'),
                'state' : getFieldProperty(x, y, 'state'),
                'mine' : getFieldBomb(x, y)
            }
        }

        function surroundings(x, y, func) {
            return {
                'up' :        func(x, y-1),
                'upRight' :   func(x+1, y-1),
                'right' :     func(x+1, y),
                'downRight' : func(x+1, y+1),
                'down' :      func(x, y+1),
                'downLeft' :  func(x-1, y+1),
                'left' :      func(x-1,  y),
                'upLeft' :    func(x-1, y-1)
            }
        }

        function recursiveReveal(x, y) {
            var neighbours = surroundings(x, y, getBombCount);
            var stack = new Array();

            Object.keys(neighbours).forEach(function(key) {
                var curr = neighbours[key];
                if (curr['state'] === '' && curr['mine'] === false) {
                    if (curr['mineCount'] === 0) {
                        stack.push(key);
                    }

                    var index = curr['x'] + curr['y']*columns;
                    itemAt(index).state = 'discovered';
                    --fieldsRemaining;
                }
            });

            stack.forEach(function(key) {
                recursiveReveal(neighbours[key]['x'], neighbours[key]['y']);
            });
        }

        function gameOver() {
            fieldGrid.enabled = false;
            gameOverPopup.open();
        }
        function gameWin() { gameWinPopup.open(); }
        function canPutFlag() { return Boolean(flagCount); }

        function flagged(isMine) {
            --flagCount;

            if (isMine) {
                --minesRemaining;
                if (!minesRemaining && !fieldsRemaining) gameWin();
            }
        }

        function unFlagged(isMine) {
            ++flagCount;
            if (isMine) ++minesRemaining;
        }
    }
}
