import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Particles 2.0
import "../lib/chance.js" as Chance

Item{
    width: main.width
    height: main.height+50
    property real phi: 1.618
    property alias board : board
    property real tileHeight : root.tileHeight
    property real tileWidth : root.tileWidth
    focus:true
    property alias pContainer:playerContainer

    // TO BE REPLACED
    property var octoArray:([])
    //

    GridView {
        id:board
        anchors.top:parent.top
        anchors.topMargin: 50
        anchors.right:parent.right
        anchors.left:parent.left
        anchors.bottom: parent.bottom
//        anchors.fill: parent
        cellWidth: tileWidth;
        cellHeight: tileHeight;
        model: root.appModel
        delegate: appDelegate
//        header:headerComponent
        add: Transition {
                NumberAnimation { properties: "x,y"; from: random(1000,1500); duration: 300 }
            }
    }

    Component {
        id: appDelegate
        Rectangle
        {
            id:container
            width:0
            height:0
            color:"black"
            border.color : "black"
            border.width : 1
            radius : 1
            property int owner : 0
            onOwnerChanged:console.log("own",owner)

            Behavior on width        {NumberAnimation{duration:750}}
            Behavior on height       {NumberAnimation{duration:750}}
//            Behavior on color          {ColorAnimation {duration:1000}}
            Component.onCompleted: {width=tileWidth;height=tileHeight;} //set render height /width

           Tile
           {
               id:tile
               color:fillColor
               visible: fillColor ==""? false:true
               opacity:.8
//               particleGroup:index
//               decayTimer.running:false
               onColorChanged:
               {

//                    console.log("Tile color Change",index,fillColor,color)
//                   var derp1 = appModel.get(index)
//                   var derp = appModel.get(index).fillColor
//                    console.log("Tile color Change",index,fillColor,color)
               }
           }
           Image {
                id:imgFish
                  source:"../assets/fish.png"
                  anchors.centerIn: parent
                  visible: hasFish
           }
           Image {
                id:imgOcto
                source:"../assets/octo.png"
                anchors.centerIn: parent
                visible: hasOcto
           }
            SequentialAnimation {
                id:pAnim
                running:octoEffect
                property int durationTime:600
                NumberAnimation{
                    target:imgOcto
                    properties:"scale"
                    from:1
                    to:2
                    duration:pAnim.durationTime*2/3
                }
                NumberAnimation{
                    target:imgOcto
                    properties:"scale"
                    from:2
                    to:1
                    duration:pAnim.durationTime*1/3
                }
           }
            Timer {
                running:octoEffect
                interval:pAnim.durationTime
                onTriggered: octoEffect = false
            }

           MouseArea {
               anchors.fill: parent
               onClicked: {grow.start();}
           }
           Timer {
               id:grow
               running:false
               repeat: true
               interval:50
               onTriggered:
               {
                   parent.border.width += 1
                   if (parent.border.width >= parent.width/10){grow.stop()}
               }
           }
        }
    }

    ListView {
        id:scoreView
        model:playersModel
        delegate:playersDelegate
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top:parent.top
        width:main.width
        orientation: ListView.Horizontal
        spacing: 10

        Component{
            id:playersDelegate
                Rectangle{
                    height:50
                    width:235
                    color:pColor
            Row{
                spacing:20
                    Text{
                        id:name
                        color:"white"
                        text:pName
                        font.pointSize: 16
                    }
                    Text{
                        font.pointSize: 16
                        color:"white"
                        text:tilesOwned
                    }
                }
            }
        }
    }

    Rectangle { // game countdown timer
    anchors.top:parent.top
    anchors.right:parent.right
    anchors.rightMargin: 150
    Row{
        spacing:25
        Text
        {
            text:"Time"
            color:"white"
            font.pointSize: 14
        }

        Text
        {
            id:time
            property int timer1: root.gameTimer
            property int timer2: 0
            color:"white"
            text:timer1+":"+timer2+"0"
            font.pointSize: 14
            Behavior on font.pointSize{ NumberAnimation{duration:1000;}}
        }

        Timer
        {
            id:clockTimer
            interval:100
            running:true
            repeat: true
            onTriggered:
            {
                time.timer2-=1
                if (time.timer2<=-1)
                {
                    time.timer2=9
                    time.timer1-=1
                    if(time.timer1<=5)
                    {
                        time.color="red";time.font.pointSize=40
//                        appDelegate.color= "red"
                    }
                    if(time.timer1<=0) //game is over
                    {
                        gameOverRect.visible=true;
                        clockTimer.stop();
                        time.timer2=0;
                        playerLoop.stop()

                        var min = {}
                        var max = {}
                        min.val = 999999, max.val =-999999;
                        for( var i =0; i < playersModel.count; i++) {
                            if( playersModel.get(i).tilesOwned < min.val)
                            {
                                min.name = playersModel.get(i).pName;
                                min.val = playersModel.get(i).tilesOwned;
                            }
                            if( playersModel.get(i).tilesOwned > max.val)
                            {
                                max.name = playersModel.get(i).pName;
                                max.val = playersModel.get(i).tilesOwned;
                                max.color = playersModel.get(i).pColor
                            }
                        }
                        gameOverRect.winnerName = max.name;
                        gameOverRect.winnerColor =max.color;
                    }
                }
            }
        }
    }
}

    Rectangle {
        id:gameOverRect
        anchors.fill:parent
        visible:false
        opacity:.6
        property string winnerColor:"#AA4217"
        color:winnerColor
        anchors.topMargin:50
        anchors.top:parent.top
        property string winnerName:""

        Text
        {
            id:zbbda
            anchors.centerIn: parent
            text: "GAME OVER"
            font.pointSize: 72
        }

        Text
        {
            text:"the winner was "+gameOverRect.winnerName
            font.pointSize: 24
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:parent.top
            anchors.topMargin: 150
        }

        Text
        {
            text:"click to continue"
            font.pointSize: 16
            anchors.top:zbbda.bottom
            anchors.topMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
        }

        MouseArea
        {
            anchors.fill:parent
            onClicked: {gameOver.visible!=gameOver.visible;restartGame()}
        }
    }

    Item
    {
        id:playerContainer
    }

    Timer
    {
        id:playerLoop
        interval:90
        repeat:true
        running:true
        onTriggered:
        {
            var xy,playerPos
            for (var i=0 ;i <numPlayers;i++)
            {
                var derp = playersModel.get(i)
                playerMove(playersModel.get(i))
           }
        }
    }

    function octoGet(playerObj,clr){
        var derp = playerObj
        var derp2=clr
        appModel.get(playerObj.position).octoEffect = true
        for (var i = 0; i < octoArray.length;i++){
               if (appModel.get(playerObj.position+octoArray[i])){
                   appModel.get(playerObj.position+octoArray[i]).fillColor = clr
               }
        }
    }

        Keys.onPressed: { //player movement keys
            switch(event.key) {
            case Qt.Key_Left: {playersModel.get(0).direction="left";};
                break;
            case Qt.Key_Right: {playersModel.get(0).direction="right";}
                break;
            case Qt.Key_Up: {playersModel.get(0).direction="up";}
                break;
            case Qt.Key_Down: {playersModel.get(0).direction="down";}
                break;
            // P2
            case Qt.Key_A: {playersModel.get(1).direction="left";};
                break;
            case Qt.Key_D: {playersModel.get(1).direction="right";}
                break;
            case Qt.Key_W: {playersModel.get(1).direction="up";}
                break;
            case Qt.Key_S: {playersModel.get(1).direction="down";}
                break;
            //P3
            case Qt.Key_G: {playersModel.get(2).direction="left";};
                break;
            case Qt.Key_J: {playersModel.get(2).direction="right";}
                break;
            case Qt.Key_Y: {playersModel.get(2).direction="up";}
                break;
            case Qt.Key_H: {playersModel.get(2).direction="down";}
                break;
            //P4
            case Qt.Key_7: {playersModel.get(3).direction="left";}
                break;
            case Qt.Key_0: {playersModel.get(3).direction="right";}
                break;
            case Qt.Key_8: {playersModel.get(3).direction="up";}
                break;
            case Qt.Key_9: {playersModel.get(3).direction="down";}
                break;
            }
        }



        function playerMove(playerObj)
        {
            if (playerObj.direction == "stop") return //no reason to evaluate anything if you aren't moving
            var returnInt = 0;
            var currentPos = playerObj.position
            var newMovement = checkBounds(playerObj)
            if (newMovement == 0){playerObj.direction="stop"} //stop if you can't move any more

            else
            {
                playerObj.position += newMovement
                var xy = root.gridConvert(playerObj.position)
                playerObj.x = xy.x
                playerObj.y = xy.y
                var clr = playerObj.pColor
                appModel.get(playerObj.position).fillColor = clr
                if (hasOcto == playerObj.position) {octoGet(playerObj,clr)}
                if (hasFish == playerObj.position) {        }
            }

            // tilesOwned changer - changes the count for the tiles that you own
            var newTileObj = appModel.get(playerObj.position)
            if (newTileObj.owner > -1){playersModel.get(newTileObj.owner).tilesOwned--}
            appModel.get(playerObj.position).owner = playerObj.pId
            playersModel.get(playerObj.pId).tilesOwned++
        }

    function checkBounds(playerObj)
    //checks if your player is sitting at the edge of the map and if his next movement will take him off.
    //returns the amount he should move (0 if he is at edge and next move would send him to his fate)
    {
        var storedMovement = 0
        var limitCheckerObj,i
        var coordinates =gridConvert(playerObj.position)
        var pertinentCoordinate //used for comparing in the switch statement
//        console.log("COORDINATES WORK?",xCoordinate,yCoordinate)
        switch(playerObj.direction)
        {
            case "up":
                storedMovement -= desiredGridSize
                limitCheckerObj = gameLimits.up
                pertinentCoordinate = coordinates.yCo
                if(pertinentCoordinate-1 < limitCheckerObj) {
                    console.log("Limit found",playerObj.direction,limitCheckerObj)
                    return 0;
                }
                return storedMovement
                break;
            case "down":
                storedMovement += desiredGridSize
                limitCheckerObj = gameLimits.down
                pertinentCoordinate = coordinates.yCo
                if(pertinentCoordinate+1 > limitCheckerObj) {
                    console.log("Limit found",playerObj.direction,limitCheckerObj)
                    return 0;
                }
                return storedMovement;
                break;
            case "left":
                storedMovement -= 1
                limitCheckerObj = gameLimits.left
                pertinentCoordinate = coordinates.xCo
                if(pertinentCoordinate-1 < limitCheckerObj) {
                    console.log("Limit found",playerObj.direction,limitCheckerObj)
                    return 0;
                }
                return storedMovement
                break;
            case "right":
                storedMovement += 1
                limitCheckerObj = gameLimits.right
                pertinentCoordinate = coordinates.xCo
                if(pertinentCoordinate+1 > limitCheckerObj) {
                    console.log("Limit found",playerObj.direction,limitCheckerObj)
                    return 0;
                }
                return storedMovement;
                break;
            case "stop":
                break;
            default:
                console.log("no direction")
                break;
        }
    }



    function init()
    {

//        console.log("GRID",JSON.stringify(gridConvert(14)))

        function octoMapper(){
//            octoArray = new Array(0)
            var dsg=desiredGridSize
            octoArray.push((-dsg*2)-2)
            octoArray.push(-dsg*2)
            octoArray.push((-dsg*2)+2)
            octoArray.push(-2)
            octoArray.push(+2)
            octoArray.push((dsg*2)-2)
            octoArray.push(dsg*2)
            octoArray.push((dsg*2)+2)
            octoArray.push(-dsg-1)
            octoArray.push(-dsg)
            octoArray.push(-dsg+1)
            octoArray.push(-1)
            octoArray.push(1)
            octoArray.push(dsg-1)
            octoArray.push(dsg)
            octoArray.push(dsg+1)
        }

        octoMapper();

        console.log("board init complete")
    }
    Component.onCompleted: init()
}
