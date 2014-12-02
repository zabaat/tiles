import QtQuick 2.3
import QtQuick.Window 2.0
import "chance.js" as Chance

Rectangle
{
    id:main
    property real phi: 1.618
    width:Screen.width/phi
    height:Screen.height/phi
    function random(min,max)     {     return Math.random() * (max - min) - min                }
    function get_random_color() {     var r = Math.random().toPrecision(1);         var g = Math.random().toPrecision(1);         var b = Math.random().toPrecision(1);         var str = Qt.rgba(r,g,b,1);         str = str.toString();         return str   }


    Loader
    {
        id:window
        focus:true
    }

    Timer
    {
        id:stupidPieceOfCrapTimerThatOnlyExistsBecauseTheProgrammersAtDigiAreLazyBastards
        running:false
        interval:1000
        onTriggered: window.source= Qt.resolvedUrl("Game.qml")
    }

    Component.onCompleted: {stupidPieceOfCrapTimerThatOnlyExistsBecauseTheProgrammersAtDigiAreLazyBastards.start()}
 }

