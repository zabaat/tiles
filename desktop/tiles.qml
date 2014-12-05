import QtQuick 2.3
import QtQuick.Window 2.0
import "chance.js" as Chance
import "./lib/zLib/SocketIo"
import ""

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

    SocketIO
        {
            id:socketHandler   //local id to use for the this object
             uri: "ws://10.0.0.121:1337"  //server address and port. use wss: for secure sockets (note, this doesn't necessarily guarantee the connection is encrypted

             ///////// PUT YOUR event message SUBSCRIPTIONS here
             eventFunctions: [{type:"on",eventName:"tiles",cb:function (msg) {handleUserModel(msg)}}]
                // one object that includes
                //type: (on / once) on: always fires, once: dies after firing once
                // eventName: (name of event from sails server, usually the model
                // cb: (function) pass the function in here that you want to fire when this event happens

             function handleUserModel(message)
             {
                 //console.log("handleUserModel:message ",JSON.stringify(message,null,2))   //if you want to see the message
                 var verb = message.verb   //verb is the case type for sails to find out what happened
                     switch (verb)
                     {
                         case "update":
                             console.log("update from tiles model",JSON.stringify(message,null,1))
                             break;
                     }
             }

             Component.onCompleted: {socketHandler.connect();  }  //recommended to put this here
        }

    Rectangle
    {
        anchors.top:parent.top
        anchors.right:parent.right
        height:20
        width:20
        color:"blue"

        MouseArea
        {
            anchors.fill:parent
            onClicked:{socketHandler.getReq("/tiles",function (obj) {getCbTuna(obj)})}
        }
    }
            function getCbTuna(obj)
            {
                for (var o in obj)
                {
                    console.log(o,obj[o])
                }
            }
 }

