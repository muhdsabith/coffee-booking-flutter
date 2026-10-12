import 'dart:io';
void main() {
  final source = Directory('branding/android');
  for (final file in source.listSync(recursive: true).whereType<File>()) {
    final relative = file.path.substring(source.path.length + 1);
    final destination = File('android/app/src/main/res/$relative');
    destination.parent.createSync(recursive: true);
    file.copySync(destination.path);
  }
  final manifest = File('android/app/src/main/AndroidManifest.xml');
  if (manifest.existsSync()) {
    manifest.writeAsStringSync(manifest.readAsStringSync().replaceAll(
      RegExp(r'android:label="[^"]*"'), 'android:label="Brew &amp; Go"'));
  }
}
