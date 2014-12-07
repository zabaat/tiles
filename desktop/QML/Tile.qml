import QtQuick 2.3
import QtQuick.Particles 2.0

///SPARKLER
Rectangle {
    anchors.fill: parent
    color: "black"
    property string particleGroup:""
    property alias decayTimer:decay
    Behavior on color {ColorAnimation{duration:1000}}

    ParticleSystem {
        width:parent.width+15
        height:parent.width+15
        anchors.centerIn: parent
        ImageParticle {
//            groups: ["stars"]
            groups:particleGroup
            anchors.fill: parent
            source: "qrc:///particleresources/star.png"
            Component.onCompleted: console.log(groups)
        }
        Emitter {
            id:emitter
//            group: "stars"
            group:particleGroup
            emitRate: 50
            lifeSpan: 2400
            size: 8
            sizeVariation: 4
            anchors.fill: parent
            Behavior on emitRate {NumberAnimation{duration:500}}
        }
    }
//        Turbulence {
//            anchors.fill: parent
//            strength:4
//        }



        // ![0]
//        ImageParticle {
//            anchors.fill: parent
//            source: "qrc:///particleresources/star.png"
//            alpha: 0
//            alphaVariation: 0.2
//            colorVariation: 1.0
//        }
        // ![0]

//            Emitter {
//                anchors.centerIn: parent
//                emitRate: 400
//                lifeSpan: 2400
//                size: 48
//                sizeVariation: 8
//                velocity: AngleDirection {angleVariation: 180; magnitude: 60}
//            }


        Timer
        {
            id:decay
            running:true
            repeat:false
            interval:100
            onTriggered: {
                emitter.emitRate = 0
//                interval= interval/1.5
            }
            onRunningChanged: {
//                if (!running){emitter.visible=false;emitter.emitRate=20}
//                else{emitter.visible=true;}
            }
        }


}
