import QtQuick 2.3
import QtQuick.Particles 2.0

Rectangle
{
    id:x
    x:50
    y:50
    border.color: "white"
    border.width: 2
    color:"transparent"
    height:pSize
    width:pSize
    property int position:1
    property int pId:0
    property alias particleSystem:particleSystem

    onPositionChanged:
    {
        //TODO SERVER
        playerLogic(this)
        console.log("player position changed")
    }
    Component.onCompleted:
    {
        playerInit(this)
        emitter.emitRate = Qt.binding(function() {return appModel.get(pId).tilesOwned})
    }

    Behavior on x {NumberAnimation{duration:playerLoop.interval}}
    Behavior on y {NumberAnimation{duration:playerLoop.interval}}

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
            emitRate: tilesOwned
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


}
