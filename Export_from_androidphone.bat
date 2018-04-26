%cd%\adb\adb devices
%cd%\adb\adb wait-for-device
%cd%\adb\adb backup -f export_data.ab com.huami.watch.hmwatchmanager
java -jar %cd%\pgm\abe.jar unpack export_data.ab export_data.tar
