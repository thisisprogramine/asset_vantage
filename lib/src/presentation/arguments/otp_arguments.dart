class OtpArguments {
  final String mobile;
  final String code;

  const OtpArguments({
    required this.mobile,
    this.code = '91'
  });
}