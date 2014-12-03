//import QtQuick 2.3
//import QtQuick.Window 2.0

//Rectangle {
//    id:main
//    width: Screen.width/3
//    height: Screen.height/2
//    focus: true;


//    Text {
//        anchors.centerIn: parent
//        text: "Hello World"
//    }


////    Grid
////    {
////        id:grid
//////        property alias rectColor:repeater.rect.color
////        anchors.centerIn: parent
////        x: 5;
////        y: 5
////        rows: 5;
////        columns: 5;
////        spacing: 10
////        Repeater
////        {
////            id:repeater
////            model: 25

////            Rectangle
////            {
////                id:rect
////                width: 70;
////                height: 70
////                color: "lightgreen"
////                ColorAnimation on color { to: "black"; duration: 500 }

////                MouseArea {
////                    anchors.fill: parent
////                    onClicked:
////                    {
////                        rect.color = "green"
////                    }
////                }

////                Text
////                {
////                    id:text2
////                    text: index
////                     font.pointSize: 30
////                     anchors.centerIn: parent }
////                }


////        }
////    }
//    property int emptyBlock: 16;

//    property int posX: 0;
//    property int posY: 0;

//    Grid
//    {
//        id: grid;
//        anchors.centerIn: parent
//        width: parent.width*.9;
//        height: parent.height*.9;
//        rows: 4;
//        columns: 4;
//        spacing: 10;

//        Repeater {
//            id: beforeTheItem
//            model: main.posX + parent.columns * main.posY
//            Rectangle {
//                width: 118; height: 118; color: "transparent";
//            }
//        }

//        Rectangle {
//            id:theItem
//            width: 118; height: 118; color: "darkblue";
//        }
//    }
////    Keys.onPressed: {
////        // To avoid flickering, the item is hidden before the change
////        // and made visible again after
//////        theItem.visible = false;
////        switch(event.key) {
////        case Qt.Key_Left: if(posX > 0) posX--;
////            break;
////        case Qt.Key_Right: if(posX < grid.columns - 1) posX++;
////            break;
////        case Qt.Key_Up: if(posY > 0) posY--;
////            break;
////        case Qt.Key_Down: if(posY < grid.rows - 1) posY++;
////            break;
////        }
////        theItem.visible = true;
////    }




//    Component {
//        id: appDelegate

//        Item {
//            width: 100; height: 100

//            Image {
//                id: myIcon
//                y: 20; anchors.horizontalCenter: parent.horizontalCenter
//                source: icon
//            }
//            Text {
//                anchors { top: myIcon.bottom; horizontalCenter: parent.horizontalCenter }
//                text: name
//            }
//        }
//    }

//    Component
//    {
//        id: appHighlight
//        Rectangle { width: 80; height: 80; color: "lightsteelblue" }
//    }

////    Timer
////    {
////        property real r:0
////        property real g:0
////        property real b:0
////        property real a:0
////        onAChanged: if (a > .3) a=.3

////        id: colorTimer
////        interval:1000
////        running:true
////        repeat:true
////        onTriggered:
////        {
////            grid.repeater.model++
////        }
////    }
//}

