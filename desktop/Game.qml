import QtQuick 2.3
import QtQuick.Window 2.1
import QtQuick.Particles 2.0
import "./chance.js" as Chance

Rectangle
{
    id:root
    width: Screen.width/phi
    height: (Screen.height/phi)+headerOffset




    // INIT OPTIONS
    property int desiredGridSize: 20
    property int gameTimer : 100
    color: "#006994"


    property int headerOffset:main.headerOffset

    property int totalGridLength : Math.pow(desiredGridSize,2)
    property int pSize: 0
    property int tileWidth: 0
    property int tileHeight: 0
    property real phi: 1.618
    property bool init:true

    property alias appModel : appModel
//     property var tileObj : ({owner:{name:"",color:"black"},hasFish:false,stability:0,occupied:[0],fillColor:""})


    property var gameArray:[]
    property var gameLimits:({})

    property var xPos:[]
    property var yPos:[]
    property int hasFish: -1
    property int hasOcto: -1
    property var tileObj : ({owner:-1,hasFish:false,hasOcto:false,octoEffect:false,stability:0,occupied:[0],fillColor:""})
/* SHADER EFFECT WATER
    Image {
        id: sourceImg
        anchors.centerIn: parent
        source: "http://hardcoresurviving.files.wordpress.com/2010/02/sr500p.jpg"
        visible: false
    }

    ShaderEffect {
        anchors.fill: parent
        property variant source: sourceImg
        property real frequency: 1
        property real amplitude: 0.1
        property real time: 0.0
        NumberAnimation on time {
            from: 0; to: Math.PI*2; duration: 10000; loops: Animation.Infinite
        }
        fragmentShader: "
                        varying highp vec2 qt_TexCoord0;
                        uniform sampler2D source;
                        uniform lowp float qt_Opacity;
                        uniform highp float frequency;
                        uniform highp float amplitude;
                        uniform highp float time;
                        void main() {
                            highp vec2 texCoord = qt_TexCoord0;
                            texCoord.y = amplitude * sin(time * frequency + texCoord.x * 6.283185) + texCoord.y/.3;
                            gl_FragColor = texture2D(source, texCoord) * qt_Opacity;
                        }"
    }
*/

    ListModel
    {
        id: appModel
    }

    ListModel
    {
        id:playersModel
    }

    GameBoard
    {
       id:gameBoard
       focus:true
    }


    ///SERVER
//    Timer
//    {
//       running:false
//       interval:500
//       repeat: true
//       onTriggered:
//       {
//    //            console.log("root appmodel count",appModel.count)
//    //            appModel.append({fillColor:Chance.myChance.color({format:"hex"})})
////           appModel.get(random(0,appModel.count)).fillColor = Chance.myChance.color({format:"hex"})
//       }
//    }
    Timer
    {
          id:gameLoop
          running:true
          repeat:true
          interval:2500
          triggeredOnStart: true
          onTriggered:
          {
              moveFish()
              for (var i=0;i<100;i++)
              {
                  var x = random(1,350)
                  var y = random(1,350)
                  var z = random(1,3)
                  appModel.move(x,y,z)
              }
          }
    }

    function moveFish()
    {
       if (hasFish > -1) {appModel.get(hasFish).hasFish=false}
       hasFish=random(0,appModel.count)
       appModel.get(hasFish).hasFish=true

       if (hasOcto > -1) {appModel.get(hasOcto).hasOcto=false}
       hasOcto=random(0,appModel.count)
       appModel.get(hasOcto).hasOcto=true
    }




    Keys.onPressed: {
       switch(event.key) {
           case Qt.Key_Space: console.log(gameBoard.board.currentIndex == gameBoard.hasFish);
               break;
      }
    }

    function doInit()
    {
        tileWidth = (main.width) / desiredGridSize
        tileHeight = (main.height-headerOffset) / desiredGridSize
        pSize = tileHeight /2

//        console.log("tileobj",JSON.stringify(tileObj))
        for (var i = 0; i < totalGridLength; i++)
            appModel.append(tileObj)

        var i,j,x,y
        var modCheck = -1;
                gameArray = new Array(0);

        for (i=0;i<desiredGridSize;i++)
        {
//            console.log("pushing to x ",(i*tileWidth)+(tileWidth/2))-(pSize/2))
            xPos.push({x:Math.floor((i*tileWidth)+(tileWidth/2)-(pSize/2)),xCo:i})   //store as object the desired position of the center of the grid, offsetting for player size, and the coordinate
            yPos.push({y:Math.floor((i*tileHeight)+(tileHeight/2)-(pSize/2))+headerOffset,yCo:i})
        }
        console.log("POSs",JSON.stringify(xPos),JSON.stringify(yPos))
        for(i=0;i<totalGridLength;i++)
        {
            gameArray[i]={x:0,xCo:0,y:0,yCo:0}
        }

        function gridSet(start,totalGridLength,counter)
        //recursive function that constructs the grid array with preloaded position data and x/y cordinate set
        //counts through the one dimensional array which counts xpositions first an increments y only once per *desiredGridSize* iterations
        {
            if (counter == undefined) counter = 0 //counter is your "pure" coordinate indication to let you know which column you are in
            else counter++

            if (start < totalGridLength)
            {
    //            console.log("gameArray")
                for(var i = start,xCount =0;i<desiredGridSize+start;i++,xCount++)
                {
                    //TODO right here! need to link the increment to the Pos arrays
                    gameArray[i].x = xPos[xCount].x
                    gameArray[i].y = yPos[counter].y
                    gameArray[i].xCo = xPos[xCount].xCo
                    gameArray[i].yCo = yPos[counter].yCo
    //                console.log(i, JSON.stringify(gameArray[i]))
                }
    //            console.log("\n")
                gridSet(start+=desiredGridSize,totalGridLength,counter)
            }

        }
        gridSet(0,totalGridLength);

//set game movement limits these are the actual indices of the grid not the outside of the grid.
        gameLimits.up = 0
        gameLimits.left = 0
        gameLimits.right = desiredGridSize-1
        gameLimits.down = desiredGridSize-1


// old code for calculating movement limits
/*
        gameLimits.xRightLimits=new Array(0)
        gameLimits.xLeftLimits=new Array(0)
        gameLimits.yUpLimits=new Array(0)
        gameLimits.yDownLimits=new Array(0)
        for (j = desiredGridSize-1; j<totalGridLength;j+=desiredGridSize){gameLimits.xRightLimits.push(j)}
        for (j = totalGridLength - desiredGridSize; j<totalGridLength;j++){gameLimits.yDownLimits.push(j)}
        for (j = 0; j<desiredGridSize;j++){gameLimits.yUpLimits.push(j)}
        for (j = 0; j<gameLimits.xRightLimits.length;j++){gameLimits.xLeftLimits.push(gameLimits.xRightLimits[j]-(desiredGridSize-1))}
*/
            console.log(JSON.stringify(gameArray))
//            console.log(JSON.stringify(gameLimits,null,1))
//            console.log(JSON.stringify(yLimit,null,1))
            console.log("init complete")
    }
    Component.onCompleted: doInit()
}

