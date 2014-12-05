import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Particles 2.0
import "chance.js" as Chance

Item{
    width: main.width
    height: main.height
    property real phi: 1.618
    property alias board : board
    property real tileHeight : root.tileHeight
    property real tileWidth : root.tileWidth
    focus:true

    // TO BE REPLACED
    property int numPlayers:2
    property var pName:([ "Brett","Chu"])
    property var pColor: (["#006600","#660066"])
    property var octoArray:([])
    property var playerObj:({pName:"",pColor:"black",pId:0,tilesOwned:0,direction:"right",position:0,x:0,y:0})
    //


    GridView {
        id:board
        anchors.fill: parent
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
           width:0
           height:0
//           color:"blue"
           color:"transparent"
           border.color: "black"
           border.width: 1
           radius:1
           property int owner: 0

           Behavior on width        {NumberAnimation{duration:100}}
           Behavior on height       {NumberAnimation{duration:100}}
           Behavior on color          {ColorAnimation {duration:1000}}
           Component.onCompleted: {width=tileWidth;height=tileHeight;}

           Tile
           {
               id:tile
               color:fillColor
               visible: fillColor ==""? false:true
               decayTimer.running:false
               onColorChanged:
               {
                   decayTimer.running= true
               }
           }
           Image
           {
                id:imgFish
                  source:"./assets/fish.png"
                  anchors.centerIn: parent
                  visible: hasFish
           }
           Image
           {
                id:imgOcto
                source:"./assets/octo.png"
                anchors.centerIn: parent
                visible: hasOcto
           }
            SequentialAnimation{
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
            Timer{
                running:octoEffect
                interval:pAnim.durationTime
                onTriggered: octoEffect = false
            }

           MouseArea
           {
               anchors.fill: parent
               onClicked: {grow.start(); tile.decayTimer.running=true; console.log(JSON.stringify(tile.color))}
           }
           Timer
           {
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

    ListView{
        model:playersModel
        delegate:playersDelegate
        anchors.verticalCenter: parent.verticalCenter
        anchors.top:parent.top
        width:120
    }


    Component{
        id:playersDelegate

            Rectangle{
                height:10
                width:40
                color:pColor

                Text{
                    id:name
                    color:"white"
                    text:pName
                    font.pointSize: 8
                }
                Text{
                    anchors.left:name.right
                    anchors.leftMargin:5
                    font.pointSize: 8
                    color:"white"
                    text:tilesOwned
                }
        }
    }



    function playerLogic(playerObj){
        //update actual position on map with new coordinates from happy array at the beginning
        var xy = gridConvert(this.position)
        if (xy.x) this.x = xy.x
        if (xy.y) this.y = xy.y
        var clr = this.color.toString()
//        console.log("THIS COLOR",this.color,appModel.get(this.position).fillColor)
//function fullColorString(clr, a) { return "#" + ((Math.ceil(a*255) + 256).toString(16).substr(1, 2) + clr.toString().substr(1, 6)).toUpperCase() }
        appModel.get(this.position).fillColor =   clr

        if (hasOcto == this.position) {
            octoGet(this,clr)

        }
        if (hasFish == this.position) {


        }

    }

    function playerInit(playerObj){
        //this function runs at the Component.onCompleted stage
        this.position = Qt.binding(function(){return playersModel.get(this.pId).position})
        this.x = Qt.binding(function(){return playersModel.get(this.pId).x})
        this.y = Qt.binding(function(){return playersModel.get(this.pId).y})
        this.color = Qt.binding(function(){return playersModel.get(this.pId).pColor})
    }

    function octoGet(playerObj,clr){
//        console.log(JSON.stringify(octoArray),playerObj.position)
        appModel.get(playerObj.position).octoEffect = true
        for (var i = 0; i < octoArray.length;i++){
               if (appModel.get(playerObj.position+octoArray[i])){
                   appModel.get(playerObj.position+octoArray[i]).fillColor = clr
               }
        }

    }

    Rectangle
    {
        id:player1
        x:50
        y:50
        color:"#006600"
        height:pSize
        width:pSize
        property int position:0
        property int pId:0
        onPositionChanged:
        {
            //TODO SERVER
            playerLogic(this)
        }
        Component.onCompleted:
        {
            playerInit(this)
        }

        Behavior on x {NumberAnimation{duration:playerLoop.interval}}
        Behavior on y {NumberAnimation{duration:playerLoop.interval}}
    }

    Rectangle
    {
        id:player2
        x:0
        y:0
        color:"#660066"
        height:pSize
        width:pSize
        property int position:0
        property int pId:1
        onPositionChanged:
        {
//            appModel.get(position).fillColor =   "#660066"
            //TODO SERVER
            playerLogic(this)
        }
        Component.onCompleted:
        {
            playerInit(this)
        }

        Behavior on x {NumberAnimation{duration:playerLoop.interval}}
        Behavior on y {NumberAnimation{duration:playerLoop.interval}}
    }

        Keys.onPressed: {
            switch(event.key) {
            case Qt.Key_Left: {playersModel.get(0).direction="left";console.log("left")};
                break;
            case Qt.Key_Right: {playersModel.get(0).direction="right";console.log("right")}
                break;
            case Qt.Key_Up: {playersModel.get(0).direction="up";console.log("up")}
                break;
            case Qt.Key_Down: {playersModel.get(0).direction="down";console.log("down")}
                break;
            // P2
            case Qt.Key_A: {playersModel.get(1).direction="left";console.log("left")};
                break;
            case Qt.Key_D: {playersModel.get(1).direction="right";console.log("right")}
                break;
            case Qt.Key_W: {playersModel.get(1).direction="up";console.log("up")}
                break;
            case Qt.Key_S: {playersModel.get(1).direction="down";console.log("down")}
                break;
            }
        }

        function gridConvert(linePos)
        {
            return root.gameArray[linePos]
        }

        function playerMove(playerObj)
        {
            if (playerObj.direction == "stop") return //no reason to evaluate anything if you aren't moving
            var returnInt = 0;
            var currentPos = playerObj.position

            var newMovement = checkBounds(playerObj)
            if (newMovement == 0){playerObj.direction="stop"} //stop if you can't move any more

//            console.log("old position ",playerObj.position)
            playerObj.position += newMovement
//            console.log("new position",playerObj.position)



//            else console.log("y ",typeof y)

//            console.log("player pos moved to x:",playerObj.x,"y:",playerObj.y)
//            return returnInt;
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

    Timer
    {
        id:playerLoop
        interval:100
        repeat:true
        running:true
        onTriggered:
        {
            var xy,playerPos
//            playerPos = players.get(0).position = player1.position
            for (var i=0 ;i <numPlayers;i++)
            {
                playerMove(playersModel.get(i))
//                console.log("*****player info*****",(i+1),JSON.stringify(players.get(i)),"\n")
           }

//           for (var a in t)
        }
    }

    function init()
    {
        octoMapper();
        for (var i =0; i < numPlayers; i++)
        {
            playersModel.append(playerObj) //TODO get this from server perhaps? or init of the thing
            playersModel.get(i).pName = pName[i];
            playersModel.get(i).pColor = pColor[i];
            playersModel.get(i).position = positionMapper(i);
            playersModel.get(i).pId = i
            console.log("player",JSON.stringify(playersModel.get(i)))
        }

        console.log("GRID",JSON.stringify(gridConvert(14)))

        function positionMapper(i)
        {
            switch(numPlayers)
            {
            case 2:
                if (i==0)return 0
                else if (i==1)return totalGridLength-1
                break;

            case 4:
                if (i==0)return 0
                else if (i==1)return (totalGridLength * 1/4)-1
                else if (i==2)return (totalGridLength * 3/4)-1
                else if (i==3)return (totalGridLength-1)
                break;
            }
        }
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
        console.log("board init complete")
    }

    Component.onCompleted: init()
}

