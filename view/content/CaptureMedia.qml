import QtQuick
import QtMultimedia

CaptureSession {
    id: root

    screenCapture: ScreenCapture {
        active: false
    }

    windowCapture: WindowCapture {
        active: false
    }

    recorder: MediaRecorder {
        // outputLocation: "/storage/emulated/0/Android/data/org.qtproject.SonixBeauty/files/Movies"
        // outputLocation: "F:\\DevelopFiles\\SonixBeautyStudio\\video"
        quality: MediaRecorder.HighQuality
        mediaFormat {
            fileFormat: MediaFormat.MPEG4
            audioCodec: MediaFormat.AudioCodec.AAC
            videoCodec: MediaFormat.VideoCodec.H265
        }
    }
}
