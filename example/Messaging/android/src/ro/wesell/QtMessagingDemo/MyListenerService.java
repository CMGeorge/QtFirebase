package ro.wesell.QtMessagingDemo;

import com.google.firebase.messaging.cpp.ListenerService;
import com.google.firebase.messaging.RemoteMessage;

import android.util.Log;

public class MyListenerService extends ListenerService {
    private static final String TAG = "MyListenerService";
    @Override
    public void onCreate() {
        super.onCreate();
        // Initialize your variables here
    }
    @Override
    public void onMessageReceived(RemoteMessage message) {
      Log.d(TAG, "A message has been received.");
      // Do additional logic...
      super.onMessageReceived(message);
    }
    @Override
    public void onDeletedMessages() {
      Log.d(TAG, "Messages have been deleted on the server.");
      // Do additional logic...
      super.onDeletedMessages();
    }

    @Override
    public void onMessageSent(String messageId) {
      Log.d(TAG, "An outgoing message has been sent.");
      // Do additional logic...
      super.onMessageSent(messageId);
    }

    @Override
    public void onSendError(String messageId, Exception exception) {
      Log.d(TAG, "An outgoing message encountered an error.");
      // Do additional logic...
      super.onSendError(messageId, exception);
    }
}
