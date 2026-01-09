import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'dart:developer' as developer;

class CallService {
  static final CallService _instance = CallService._internal();
  factory CallService() => _instance;
  CallService._internal();

  final JitsiMeet _jitsiMeet = JitsiMeet();

  Future<void> startCall({
    required String roomName,
    required String displayName,
    bool isAudioMuted = false,
    bool isVideoMuted = true,
  }) async {
    try {
      var options = JitsiMeetConferenceOptions(
        room: roomName,
        configOverrides: {
          "startWithAudioMuted": isAudioMuted,
          "startWithVideoMuted": isVideoMuted,
          "subject": "Laijau Call",
        },
        featureFlags: {
          "unsaferoomwarning.enabled": false,
          "ios.recording.enabled": false,
        },
        userInfo: JitsiMeetUserInfo(
          displayName: displayName,
        ),
      );

      await _jitsiMeet.join(options);
    } catch (e) {
      developer.log('Error starting call', error: e, name: 'CallService');
      rethrow;
    }
  }

  Future<void> hangUp() async {
    try {
      await _jitsiMeet.hangUp();
    } catch (e) {
      developer.log('Error hanging up', error: e, name: 'CallService');
     
    }
  }
  
  void setAudioMuted(bool muted) {
    _jitsiMeet.setAudioMuted(muted);
  }

  void setVideoMuted(bool muted) {
    _jitsiMeet.setVideoMuted(muted);
  }
}
