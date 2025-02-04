rm Overlay.flata
rm systemuirro.apk.u
rm systemuirro.apk

aapt2 compile -v --dir res/ -o Overlay.flata
aapt2 link -v --no-resource-removal \
-I ~/Android/Sdk/platforms/android-35/android.jar \
--manifest AndroidManifest.xml \
-o systemuirro.apk.u Overlay.flata
zipalign 4 systemuirro.apk.u systemuirro.apk
printf 'android' | jarsigner -keystore ~/.android/debug.keystore  systemuirro.apk androiddebugkey

adb connect 192.168.0.50
adb root
adb shell cmd overlay disable de.pacheco.rro.systemui
adb shell pm uninstall de.pacheco.rro.systemui
adb remount
adb shell  mount -o remount,rw /
adb push systemuirro.apk product/overlay
adb shell cmd overlay enable de.pacheco.rro.systemui
adb shell cmd overlay list
# adb reboot