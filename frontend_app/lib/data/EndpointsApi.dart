abstract class EndpointsApi {

  static const String baseUrl = "http://localhost:8080/tc_api/v1";

  // USER - ENDPOINTS
  static const String endpointBaseUser = "/user";
  static const String endpointRegistry = "$endpointBaseUser/new";
  static const String endpointLogin = "$endpointBaseUser/login";
  static const String endpointPasswordRecovery = "$endpointBaseUser/recovery";

  // COUNTRY - ENDPOINTS
  static const String endpointBaseCountry = "/country";
  static const String endpointAllCountries = "$endpointBaseCountry/all";

  // USER_TYPE - ENDPOINTS
  static const String endpointBaseUserType = "/user_type";
  static const String endpointAllUserTypes = "$endpointBaseUserType/all";

  

}