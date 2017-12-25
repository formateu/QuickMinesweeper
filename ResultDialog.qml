import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
//import QtQuick.Dialogs 1.3

Dialog {
    id: resultDialog
    background: Rectangle {
        id: opacityBox
        anchors.fill: parent
        //color: "black"
        opacity: 0
        height: root.height
        width: root.width
        Layout.fillHeight: true
        Layout.fillWidth: true

        OpacityAnimator {
            id: opacityAnimation
            target: opacityBox
            from: 0
            to: 0.9
            duration: 200
            running: false
            easing.type: Easing.OutQuad
        }

        onVisibleChanged: {
            if(visible === true){
                opacityAnimation.running = true
            } else {
                opacity = 0;
                opacityAnimation.running = false
            }
        }
    }
    DialogButtonBox { alignment: "AlignVCenter" }
    standardButtons: Dialog.Close
    onRejected: resultDialog.close()
    modal: true
    focus: true
    width: parent.height /2
    height: width
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    title: "Game Over"
    Text {
        id: textContent
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "darkred"
        font.pixelSize: 0.1 * resultDialog.height
        text: "You have lost !"
    }
    closePolicy: Popup.NoAutoClose
}
