rm Overlay.flata
rm myoverlays.apk.u
rm myoverlays.apk

aapt2 compile -v --dir res/ -o Overlay.flata
aapt2 link -v --no-resource-removal \
-I ~/Android/Sdk/platforms/android-35/android.jar \
--manifest AndroidManifest.xml \
-o myoverlays.apk.u Overlay.flata
zipalign 4 myoverlays.apk.u myoverlays.apk
printf 'android' | jarsigner -keystore ~/.android/debug.keystore  myoverlays.apk androiddebugkey

adb connect 192.168.0.50
adb root
adb shell cmd overlay disable de.pacheco.rro
adb shell pm uninstall de.pacheco.rro
adb remount
adb shell  mount -o remount,rw /
adb push myoverlays.apk product/overlay
adb shell cmd overlay enable de.pacheco.rro
adb shell cmd overlay list
# adb reboot