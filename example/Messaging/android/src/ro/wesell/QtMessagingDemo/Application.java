package ro.wesell.QtMessagingDemo;


//import com.google.firebase.iid.FirebaseInstanceId;
//import com.google.firebase.messaging.FirebaseMessaging;
//import com.google.firebase.FirebaseApp;
////import com.firebase.client.Firebase;
import java.util.Set;

import org.qtproject.qt.android.bindings.QtApplication;
import org.qtproject.qt.android.bindings.QtActivity;
//import android.support.v7.app.AppCompatActivity;

import android.util.*;
import android.util.Log;
import android.app.NotificationManager;
import android.app.NotificationChannel;

// Messaging support
import android.os.Bundle;
import android.content.Intent;
import android.os.Build;
import com.google.firebase.messaging.MessageForwardingService;
import org.qtproject.qt.android.bindings.QtActivity;



public class Application extends QtActivity{
    private static final String TAG = "MainActivity";
    private static String pushNotificationID;
    public static Application m_instance = null;

    public static String getPNToken(){
        return pushNotificationID;
    }
    public static String SearchForToken(){
//        m_instance.pushNotificationID = FirebaseInstanceId.getInstance().getToken();
        Log.d(TAG, "InstanceID token: " + m_instance.pushNotificationID);
        return m_instance.pushNotificationID;
    }
    public Application()
        {
//            FirebaseApp.initializeApp(this);;
            Log.d(TAG, "MyActivity constructor called");
            m_instance = this;
            // Bundle extras = getIntent().getExtras();

            // if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            //     String channelId = "FirebaseAppChannel";
            //     String channelName = "Demo Channel";
            //     String channelDescription = "Receiving notifications while app is in background";
            //     int importance = NotificationManager.IMPORTANCE_DEFAULT;
            //     NotificationChannel channel = new NotificationChannel(channelId, channelName, importance);
            //     channel.setDescription(channelDescription);

            //     // Register the channel with the system
            //     NotificationManager notificationManager = getSystemService(NotificationManager.class);
            //     notificationManager.createNotificationChannel(channel);
            // }

//            SearchForToken();
        }

    /**
           * Messaging example
           */
        // The key in the intent's extras that maps to the incoming message's message ID. Only sent by
        // the server, GmsCore sends EXTRA_MESSAGE_ID_KEY below. Server can't send that as it would get
        // stripped by the client.
        private static final String EXTRA_MESSAGE_ID_KEY_SERVER = "message_id";

        // An alternate key value in the intent's extras that also maps to the incoming message's message
        // ID. Used by upstream, and set by GmsCore.
        private static final String EXTRA_MESSAGE_ID_KEY = "google.message_id";

        // The key in the intent's extras that maps to the incoming message's sender value.
        private static final String EXTRA_FROM = "google.message_id";

    /**
           * Workaround for when a message is sent containing both a Data and Notification payload.
           *
           * When the app is in the foreground all data payloads are sent to the method
           * `::firebase::messaging::Listener::OnMessage`. However, when the app is in the background, if a
           * message with both a data and notification payload is receieved the data payload is stored on
           * the notification Intent. NativeActivity does not provide native callbacks for onNewIntent, so
           * it cannot route the data payload that is stored in the Intent to the C++ function OnMessage. As
           * a workaround, we override onNewIntent so that it forwards the intent to the C++ library's
           * service which in turn forwards the data to the native C++ messaging library.
           */

        @Override
          protected void onNewIntent(Intent intent) {
            // If we do not have a 'from' field this intent was not a message and should not be handled. It
            // probably means this intent was fired by tapping on the app icon.
            Bundle extras = intent.getExtras();
            // if (extras != null && !extras.isEmpty()) {
            //     // Get all the keys and their corresponding values in the data payload
            //     Set<String> keys = extras.keySet();
            //     for (String key : keys) {
            //         Log.d(TAG, "Key: " + key + ", Value: " + extras.getString(key));
            //     }
            // }
    
            String from = extras.getString(EXTRA_FROM);
            String messageId = extras.getString(EXTRA_MESSAGE_ID_KEY);
            if (messageId == null) {
              messageId = extras.getString(EXTRA_MESSAGE_ID_KEY_SERVER);
            }
            if (from != null && messageId != null) {
              Intent message = new Intent(this, MessageForwardingService.class);
              message.setAction(MessageForwardingService.ACTION_REMOTE_INTENT);
              message.putExtras(intent);
              message.setData(intent.getData());
              MessageForwardingService.enqueueWork(this, message);
            }
            setIntent(intent);
          }


        // @Override
        // protected void onNewIntent(Intent intent) {
        //     // If we do not have a 'from' field this intent was not a message and should not be handled. It
        //     // probably means this intent was fired by tapping on the app icon.
        //     Log.d(QtApplication.QtTAG,"New intent is here...");
        //     if (intent.getExtras() == null) {
        //         }else{
        //     Bundle extras = intent.getExtras();
        //     String from = extras.getString(EXTRA_FROM);
        //     String messageId = extras.getString(EXTRA_MESSAGE_ID_KEY);

        //     if (messageId == null) {
        //         messageId = extras.getString(EXTRA_MESSAGE_ID_KEY_SERVER);
        //     }

        //     if (from != null && messageId != null) {
        //         Intent message = new Intent(this, MessageForwardingService.class);
        //         message.setAction(MessageForwardingService.ACTION_REMOTE_INTENT);
        //         message.putExtras(intent);
        //         startService(message);
        //     }
        // }
        //     setIntent(intent);

        // }

}
