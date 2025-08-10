class ErrorMessages {
  static const Map<String, String> errorMessageMap = {
    'invalid-email': "Invalid email address.",
    'user-disabled': "This account has been disabled.",
    'user-not-found': "Invalid email or password.",
    'wrong-password': "Invalid email or password.",
    'email-already-in-use': "The email address is already in use by another account.",
    'weak-password': "The password is too weak.",
    'operation-not-allowed': "This operation is not allowed. Please try again later.",
    'network-request-failed': "A network error occurred. Please check your internet connection.",
    'user-mismatch': "The supplied credentials do not correspond to the previously signed in user.",
    'requires-recent-login': "This operation is sensitive and requires recent authentication. Log in again before retrying this request.",
    'provider-already-linked': "This account is already linked to the given provider.",
    'credential-already-in-use': "This credential is already associated with a different user account.",
    'invalid-credential': "The supplied auth credential is malformed or has expired.",
    'user-token-expired': "The user's credential is no longer valid. The user must sign in again.",
    'user-not-verified': "The user has not been verified. Please verify your email address.",
    'missing-verification-id': "The phone auth credential was created with an empty verification ID.",
    'quota-exceeded': "The project's quota for this operation has been exceeded.",
    'app-not-authorized': "The app is not authorized to use Firebase Authentication. Please check your Firebase project configuration.",
    'captcha-check-failed': "The reCAPTCHA response token provided is either invalid, expired, or already used.",
    'web-storage-full': "The browser's web storage quota has been exceeded.",
    'too-many-requests': "We have blocked all requests from this device due to unusual activity. Try again later.",
  };

  static String getErrorMessage(String code) {
    return errorMessageMap[code] ?? "An unknown error occurred. Please try again later.";
  }
}
