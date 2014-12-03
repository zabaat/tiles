import QtQuick 2.3
import QtQuick.Particles 2.0

///SPARKLER
Rectangle {
    anchors.fill: parent
    color: "black"
    property alias decayTimer:decay
    Behavior on color {ColorAnimation{duration:1000}}

    ParticleSystem {
        anchors.fill: parent
        ImageParticle {
            groups: ["stars"]
            anchors.fill: parent
            source: "qrc:///particleresources/star.png"
        }
        Emitter {
            id:emitter
            group: "stars"
            emitRate: 50
            lifeSpan: 2400
            size: 8
            sizeVariation: 4
            anchors.fill: parent
            Behavior on emitRate {NumberAnimation{duration:500}}
        }

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

        Turbulence {
            anchors.fill: parent
            strength:4
        }
        Timer
        {
            id:decay
            running:false
            repeat:false
            interval:1000
            onTriggered:
            {
                emitter.emitRate -= emitter.emitRate/4
                interval= interval/1.5
            }
            onRunningChanged: {
                if (!running){emitter.visible=false;emitter.emitRate=50}
                else{emitter.visible=true;}
            }
        }

    }
}
