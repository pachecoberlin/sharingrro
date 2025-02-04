rm Overlay.flata
rm carlauncher.apk.u
rm carlauncher.apk

aapt2 compile -v --dir res/ -o Overlay.flata
aapt2 link -v --no-resource-removal \
-I ~/Android/Sdk/platforms/android-35/android.jar \
--manifest AndroidManifest.xml \
-o carlauncher.apk.u Overlay.flata
zipalign 4 carlauncher.apk.u carlauncher.apk
printf 'android' | jarsigner -keystore ~/.android/debug.keystore  carlauncher.apk androiddebugkey

adb connect 192.168.0.50
adb root
adb shell cmd overlay disable de.pacheco.rro.car.carlauncher
adb shell pm uninstall de.pacheco.rro.car.carlauncher
adb remount
adb shell  mount -o remount,rw /
adb push carlauncher.apk product/overlay
adb shell cmd overlay enable de.pacheco.rro.car.carlauncher
adb shell cmd overlay list
# adb reboot