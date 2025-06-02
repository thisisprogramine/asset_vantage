class Token {
  String? token;
  String? region;
  String? awssession;
  String? challenge;
  String? mfaawssession;
  String? mfachallenge;
  int? statusCode;
  String? message;

  Token({this.token,this.awssession,this.challenge});

  Token.fromJson(Map<String, dynamic> json) {
    token = json['loginResponse'] != null ? json['loginResponse']['token'] : null;
    region = json['region'];
    awssession = json['awssession'];
    challenge = json['challenge'];
    statusCode = json['statusCode'];
    message = json['message'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['region'] = this.region;
    data['awssession'] = this.awssession;
    data['challenge'] = this.challenge;

    return data;
  }
}