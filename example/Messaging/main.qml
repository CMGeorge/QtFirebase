import QtQuick
import QtQuick.Controls
import ro.wesell.firebase

ApplicationWindow{
    property string message:""
    property string newData:""
    visible: true
    header: TabBar{}

    FirebaseMessaging{
        id: messaging
        onReadyChanged: {
            console.log("Messaging.ready", ready)
        }
        onTokenChanged: {
            console.log("Messaging.token", token)
            console.debug("New Tokent ",messaging.token )
            console.error("CHANGED!!!!");
        }
        onDataChanged: {
            console.log("Messaging.data", JSON.stringify(data))
            newData = JSON.stringify(data);
        }
        onMessageReceived: {
            console.log("onMessageReceived","Messaging.data", JSON.stringify(data))
            message = JSON.stringify(data)
            var _notification = data;
            var _notificationKeys  = Object.keys(_notification);
            if (_notificationKeys.includes("launchnotification") && _notification.launchnotification===true){
                console.debug("We are from notification")
            }else{
                console.debug("We are from message")
            }
        }

        onSubscribed: {
            console.log("Messaging::onSubscribed", topic)
        }
        onUnsubscribed: {
            console.log("Messaging::onUnsubscribed", topic)
        }

        onError: {
            console.error('Messaging::error',code, message);
        }
    }
    Label{
        anchors.fill: parent
        verticalAlignment: Qt.AlignVCenter
        wrapMode: Label.WordWrap
        text:qsTr("Token: %1<br>Message: %2<br>New data: %3").arg(messaging.token).arg(message).arg(newData)
        color: "black"
    }
}

