import QtQuick 2.3
import QtQuick.Particles 2.0

Rectangle
{
    x:50
    y:50
    border.color: "white"
    border.width: 2
    color:"transparent"
    height:25
    width:25

    property int position:1
    property int pId:0
    property alias particleSystem:particleSystem
    property var playerModelRef:null
    property int speed: 100
    onPositionChanged:
    {
        //TODO SERVER
//        playerLogic(this)
//        console.log("player position changed")
    }
    Component.onCompleted:
    {
//        console.log("player init: ",pId,rootRef.color)
        playerInit(this)
//        emitter.emitRate = Qt.binding(function() {return appModel.get(pId).tilesOwned})
    }

    Behavior on x {NumberAnimation{duration:speed}}
    Behavior on y {NumberAnimation{duration:speed}}

    ParticleSystem {
        id:particleSystem
        enabled:true
        width:parent.width+50
        height:parent.width+50
        anchors.centerIn: parent
        ImageParticle {
            groups: ["stars"]
            anchors.fill: parent
            source: "qrc:///particleresources/star.png"
        }
        Emitter {
            id:emitter
            group: "stars"
            emitRate: 0
            lifeSpan: 2400
            size: 10
            sizeVariation: 5
            anchors.fill: parent
//                Behavior on emitRate {NumberAnimation{duration:500}}         
        }
                Turbulence {
                    anchors.fill: parent
                    strength:4
                }
    }

//    function playerLogic(playerObj){
        //update actual position on map with new coordinates from happy array at the beginning
//        if (rootRef != null){
//            var xy = rootRef.gridConvert(this.position)
//            if (xy.x) this.x = xy.x
//            if (xy.y) this.y = xy.y
//        }
//        var clr = this.color.toString()

//        rootRef.appModel.get(this.position).fillColor =   clr

//        if (hasOcto == this.position) {octoGet(this,clr)}
//        if (hasFish == this.position) {        }

//    }

    function playerInit(playerObj){
        //this function runs at the Component.onCompleted stage
//        console.log("playerInitFun - ",this)
        console.log("playerInitFun - ",this.pId)
        console.log("playerInitFun - ",this.playerModelRef.pColor)
        this.position = Qt.binding(function(){return this.playerModelRef.position})
        this.x = Qt.binding(function(){return this.playerModelRef.x})
        this.y = Qt.binding(function(){return this.playerModelRef.y})
        this.color = Qt.binding(function(){return this.playerModelRef.pColor})
    }
}
