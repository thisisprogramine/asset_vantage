
class ApiConstants {
  ApiConstants._();
  static const Map<String, String> BASE_URL_PROD = {
    "base_login": "https://zcfi0gttb8.execute-api.us-east-1.amazonaws.com/prod/v1/",
    "base_us": "https://zcfi0gttb8.execute-api.us-east-1.amazonaws.com/prod/v1/",
    "base_ind": "https://85lardrq99.execute-api.ap-south-1.amazonaws.com/prod/v1/",
    "base_sgt": "https://znpwf1d5la.execute-api.ap-southeast-1.amazonaws.com/prod/v1/",
    "base_uat_us": "https://xinaw6n1a1.execute-api.us-west-1.amazonaws.com/uat/v1/",
    "base_uat_ind": "https://9z9ur1p8yk.execute-api.ap-south-1.amazonaws.com/uat/v1/",
    "base_dev_insight": "https://ic6100jwwf.execute-api.ap-south-1.amazonaws.com/dev/v1/",
    "base_dev_sso": "https://ic6100jwwf.execute-api.ap-south-1.amazonaws.com/dev/v1/",
    "base_dev_poc": "https://cbxj8huxx1.execute-api.ap-south-1.amazonaws.com/prod/v1/",
    "base_dev_qa": "https://ic6100jwwf.execute-api.ap-south-1.amazonaws.com/dev/v1/",
  };

  static const Map<String, String> BASE_URL_PROD_REPORTS = {
    "base_us": "https://y3uklontvsdy7amote7okbpcbm0zvpbb.lambda-url.us-east-1.on.aws",
    "base_ind": "https://b2czujlnpi2k36xgiahqsxtip40nzakg.lambda-url.ap-south-1.on.aws",
    "base_sgt": "https://ntkokzpvgbahco2b7wyjjh7ike0ooqrq.lambda-url.ap-southeast-1.on.aws",
    "base_uat_us": "https://5xk5ohwp37zony3ddk5vnazf2e0pxhfb.lambda-url.us-west-1.on.aws",
    "base_uat_ind": "https://ogdd266kmiha5p46fczv34xkoy0bkrzr.lambda-url.ap-south-1.on.aws",
    "base_dev_insight": "https://sybzmdvgrn2zd7rvfoeseolgjm0hhpjn.lambda-url.ap-south-1.on.aws",
    "base_dev_sso": "https://ic6100jwwf.execute-api.ap-south-1.amazonaws.com/dev/v1/",
    "base_dev_poc": "https://nospdnjec6h74dkynwfdcin54a0mllue.lambda-url.ap-south-1.on.aws",
    "base_dev_qa": "https://nospdnjec6h74dkynwfdcin54a0mllue.lambda-url.ap-south-1.on.aws",
  };

  static const Map<String, String> CHATBOT_BASE_URL = {
    "base_login": "ws://3.111.185.194:8010/ws/mob/bot",
    "base_us": "ws://3.111.185.194:8010/ws/mob/bot",
    "base_ind": "ws://3.111.185.194:8010/ws/mob/bot",
    "base_sgt": "ws://3.111.185.194:8010/ws/mob/bot",
    "base_uat_us": "ws://3.111.185.194:8010/ws/mob/bot",
    "base_uat_ind": "ws://18.60.138.40:8010/ws/mob/bot",
    "base_dev_insight": "ws://3.108.71.114:8010/ws/mob/bot",
    "base_dev_poc": "ws://3.111.185.194:8010/ws/mob/bot",
    "base_dev_qa": "ws://3.111.185.194:8010/ws/mob/bot",
  };
  static const String BASE_URL_DEV = 'https://cbxj8huxx1.execute-api.ap-south-1.amazonaws.com/prod/v1/';

  static const bool isProd = true;

}
