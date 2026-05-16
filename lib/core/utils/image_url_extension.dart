/// Extension to ensure image URLs use HTTPS protocol.
/// Fixes Android cleartext traffic restrictions and iOS ATS requirements.
extension ImageUrlFix on String {
  String toHttps() {
    if (startsWith('http://')) {
      return replaceFirst('http://', 'https://');
    }
    return this;
  }
}
