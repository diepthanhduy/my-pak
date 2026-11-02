/// Hands a phone number over to the platform dialer / SMS app.
abstract interface class PhoneLauncher {
  /// Starts a call to [phone]. Returns false if nothing could handle it.
  Future<bool> startCall(String phone);

  /// Opens the SMS composer for [phone] prefilled with [body].
  /// Returns false if nothing could handle it.
  Future<bool> openSms(String phone, String body);
}
