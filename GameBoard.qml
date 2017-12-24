import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

GridLayout {
    id: fieldGrid
    columns: 10
    rowSpacing: 1
    columnSpacing: rowSpacing
    rows: columns
    antialiasing: true

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

//    WinPopup {}
    GameOverPopup {
        id: gameOverPopup
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
            if (isMine < 2) { itemAt(index).mine = true; }
            itemAt(index).xPos = index % columns;
            itemAt(index).yPos = index / columns;
            itemAt(index).revealNeighbours.connect(recursiveReveal);
            itemAt(index).gameOver.connect(gameOver);
        }
        FieldButton {}

        Component.onCompleted: {
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

        function inScope(x, y) { return x >= 0 && x < columns && y >= 0 && y < rows; }
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
            var stack = Array();
            Object.keys(neighbours).forEach(function(key) {
                var curr = neighbours[key];
                if (inScope(curr['x'], curr['y']) && curr['state'] === '' && curr['mine'] === false && curr['mineCount'] === 0) {
                    stack.push(key);
                    var index = curr['x'] + curr['y']*columns;
                    itemAt(index).state = 'discovered';
                }
            });
            console.log(stack);
            //TODO: fix this :) => recursiveReveal will be done
            for (var key in stack) {
                console.log(key);
                recursiveReveal(neighbours[stack[key]]['x'], neighbours[stack[key]]['y']);
            }
        }

        function gameOver() {
            gameOverPopup.visible = true;
            repeater.visible = false;
        }
    }
}
