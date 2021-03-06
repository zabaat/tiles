import QtQuick 2.3
import QtQuick.Window 2.0
import "../lib/chance.js" as Chance
import "../lib/zLib/SocketIo"


/*wishlist:
particles interaction
rotation of tiles when crossing them
grid overlay for non tile objects
Camera for level detection - drawing from picture analysis
a*


  */


Rectangle
{
    id:main
    property real phi: 1.618
    property int headerOffset:50
    width:Screen.width/phi
    height: (Screen.height/phi)+headerOffset
//    width:Screen.width/phi
//    height: (Screen.height/phi)+headerOffset
    function random(min,max)     {     return Math.random() * (max - min) - min }
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
//             uri: "ws://10.0.0.121:1337"  //server address and port. use wss: for secure sockets (note, this doesn't necessarily guarantee the connection is encrypted

             ///////// PUT YOUR event message SUBSCRIPTIONS here
             eventFunctions: [{type:"on",eventName:"tiles",cb:function (msg) {handleUserModel(msg)}}]
                // one object that includes
                //type: (on / once) on: always fires, once: dies after firing once
                // eventName: (name of event from sails server, usually the model
                // cb: (function) pass the function in here that you want to fire when this event happens

             function handleUserModel(message)
             {
                 var verb = message.verb   //verb is the case type for sails to find out what happened
                     switch (verb)
                     {
                         case "update":
                             console.log("update from tiles model",JSON.stringify(message,null,1))
                             break;
                     }
             }

//             Component.onCompleted: {socketHandler.connect();  }  //recommended to put this here
        }

    Rectangle
    {
        anchors.top:parent.top
        anchors.right:parent.right
        height:10
        width:10
        color:"steelblue"

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

            function getNewObject(name,parent,qmlArgs) //qml args must be object that contains string formatted "property":"value"
            {
                var cmp =  Qt.createComponent(name)
                if(cmp.status == Component.Ready)
                    if (qmlArgs !=null) {return cmp.createObject(parent,qmlArgs)}
                    else
                        return cmp.createObject(parent)
                else
                {
                    console.log("getNewObject error: ",name,cmp.errorString())
                    return null
                }
            }


 }

