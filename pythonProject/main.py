import pyrebase
import requests
import json
from pusher_push_notifications import PushNotifications

firebaseConfig = {
    'apiKey': "AIzaSyAsYne7Q_5YyqQ012_e13oFjUCvnh2ZrSc",
    'authDomain': "airify-b9e29.firebaseapp.com",
    'databaseURL': "https://airify-b9e29.firebaseio.com",
    'projectId': "airify-b9e29",
    'storageBucket': "airify-b9e29.appspot.com",
    'messagingSenderId': "831440394912",
    'appId': "1:831440394912:web:7092a3143b601e83a907c5",
    'measurementId': "G-FQGPPP675Z"
}
firebase = pyrebase.initialize_app(firebaseConfig)

db = firebase.database()
beams_client = PushNotifications(
    instance_id='f800f676-a0af-4fee-be95-06a8d254a474',
    secret_key='4FB41C68E36B684C59D679ABA4A0803363C2AE1D794BACA6F8CDD9EBB8FEB845',
)


def stream_handler(message):
    print(message)
    if message['data'] > 200:
        serverToken = 'AAAAwZW1mqA:APA91bEoA3eTrSYqk_TzGfDqL3zs8NijKvRuVCXt0cFyPlc1q1Y2X2iCxktKVtVtk8BRGq7NZ03WKc-esU1jmI68fsp4JuMPRohPDm4bjq4WunQeBgdFI3M3ItLsZv7r_oSl0_KnL7cC'
        deviceToken = 'fMJAruTgShe3lkqnsprSJy:APA91bEP97Y6TSW_wHBWyd2TPu9K2bQRd1tiir7s0vWPgaxNptMRMKqz9iFQ4baihVIlyxkzzvbTKxkUrW_Y75XrsdITYenVW1H5zNy6Q1OCz5mukuEse_pA-XEl9ZT8kSmcloHBthA-'

        headers = {
            'Content-Type': 'application/json',
            'Authorization': 'key=' + serverToken,
        }

        body = {
            'notification': {'title': 'DANGEROUS',
                             'body': 'GAS  level is dangerously high!'
                             },
            'to':
                deviceToken,
            'priority': 'high',
        }
        response = requests.post("https://fcm.googleapis.com/fcm/send", headers=headers, data=json.dumps(body))
        print(response.status_code)

        print(response.json())


my_stream = db.child("5").stream(stream_handler, None)
