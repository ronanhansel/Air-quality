package com.rh.air_quality

import android.os.Bundle
import com.pusher.pushnotifications.PushNotifications
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override
    fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        PushNotifications.start(applicationContext, "f800f676-a0af-4fee-be95-06a8d254a474");
        PushNotifications.addDeviceInterest("hello");
    }
}
