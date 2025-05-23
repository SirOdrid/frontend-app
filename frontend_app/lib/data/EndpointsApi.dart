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

  // BOARDGAME - ENDPOINTS
  static const String endpointBaseBoardgame = "/boardgame";
  static const String endpointAllBoardgames = "$endpointBaseBoardgame/all";
  static const String endpointSearchBoardgameInBgg = "$endpointBaseBoardgame/search-bgg"; 
  static const String endpointSearchBoardgameLocal = "$endpointBaseBoardgame/search"; 
}