abstract class EndpointsApi {

  static const String baseUrl = "http://localhost:8080/tc_api/v1";

  // USER - ENDPOINTS
  static const String endpointBaseUser = "/user";
  static const String endpointRegistry = "$endpointBaseUser/new";
  static const String endpointLogin = "$endpointBaseUser/login";
  static const String endpointPasswordRecovery = "$endpointBaseUser/recovery";
  static const String endpointSearchUsers = "$endpointBaseUser/search";

  // COUNTRY - ENDPOINTS
  static const String endpointBaseCountry = "/country";
  static const String endpointAllCountries = "$endpointBaseCountry/all";

  // USER_TYPE - ENDPOINTS
  static const String endpointBaseUserType = "/user_type";
  static const String endpointAllUserTypes = "$endpointBaseUserType/all";

  // USER_ASSOCIATE - ENDPOINTS
  static const String endpointBaseUserAssociate = "/user_associate";
  static const String endpointAddAssociation = "$endpointBaseUserAssociate/new";
  static const String endpointDeleteAssociation = endpointBaseUserAssociate;
  static const String endpointAllAssociations = "$endpointBaseUserAssociate/all_associations";
  static const String endpointAllAssociates = "$endpointBaseUserAssociate/all_associated";

  // BOARDGAME - ENDPOINTS
  static const String endpointBaseBoardgame = "/boardgame";
  static const String endpointAllBoardgames = "$endpointBaseBoardgame/all";
  static const String endpointSearchBoardgameInBgg = "$endpointBaseBoardgame/search-bgg"; 
  static const String endpointSearchBoardgameLocal = "$endpointBaseBoardgame/search"; 

  // COLLECTION - ENDPOINTS
  static const String endpointBaseCollection = "/collection";
  static const String endpointAddCollection = "$endpointBaseCollection/$endpointBaseUser";
  static const String endpointDeleteCollection = "$endpointBaseCollection/$endpointBaseUser";
  static const String endpointGetCollectionByUser = "$endpointBaseCollection/all$endpointBaseUser";

  // SESSION - ENDPOINTS
  static const String endpointBaseSession = "/session";
  static const String endpointAddSession = "$endpointBaseSession/new";
  static const String endpointEditSession = endpointBaseSession;
  static const String endpointDeleteSession = endpointBaseSession;
  static const String endpointGetSessionsByUser = "$endpointBaseSession/all$endpointBaseUser";

  // MEETING - ENDPOINTS
  static const String endpointBaseMeeting = "/meeting";
  static const String endpointAddMeeting = "$endpointBaseMeeting/new";
  static const String endpointDeleteMeeting = endpointBaseMeeting;
  static const String endpointGetMeetingsByUser = "$endpointBaseMeeting/all$endpointBaseUser";
  static const String endpointGetMeetingsBySession = "$endpointBaseMeeting/all$endpointBaseSession";

  // PACK - ENDPOINTS
  static const String endpointBasePack = "/pack";
  static const String endpointAddPack = "$endpointBasePack/new";
  static const String endpointDeletePack = endpointBasePack;
  static const String endpointGetPacksByUser = "$endpointBasePack/all$endpointBaseUser";

  // BOARDGAME_PACK - ENDPOINTS
  static const String endpointBaseBoardgamePack = "/boardgame_pack";

  // STOCK - ENDPOINTS
  static const String endpointBaseStock = "/stock";
  static const String endpointAddStock = "$endpointBaseStock/new";
  static const String endpointEditStock = endpointBaseStock;
  static const String endpointDeleteStock = endpointBaseStock;
  static const String endpointGetStockByUser = "$endpointBaseStock/all$endpointBaseUser";

  // LOAN - ENDPOINTS
  static const String endpointBaseLoan = "/loan";
  static const String endpointAddLoan = "$endpointBaseLoan/new";
  static const String endpointEditLoan = endpointBaseLoan;
  static const String endpointDeleteLoan = endpointBaseLoan;
  static const String endpointGetLoansByStock = "$endpointBaseLoan/all$endpointBaseStock";
  static const String endpointGetLoansByUser = "$endpointBaseLoan/all$endpointBaseUser";

  // LOAN_STATE - ENDPOINTS
  static const String endpointBaseLoanState = "/loan_state";
  static const String endpointAllLoanStates = "$endpointBaseLoanState/all";

  // ANALYTICS - ENDPOINTS
  static const String endpointBaseAnalytics = "/analytics";
  static const String endpointBoardgamesStats = "$endpointBaseAnalytics/activity/$endpointBaseUser";
  static const String endpointTopGenresByUser = "$endpointBaseAnalytics/genres/$endpointBaseUser";
  static const String endpointUnplayedPoupularBoardgames = "$endpointBaseAnalytics/unplayed/$endpointBaseUser";
  static const String endpointUsageBoardgames = "$endpointBaseAnalytics/usage/$endpointBaseUser";
  static const String endpointBoardgamesOwnershipStats = "$endpointBaseAnalytics/associate_compose/$endpointBaseUser";
  static const String endpointBoardgamesPlayStats = "$endpointBaseAnalytics/associate_boardgames/$endpointBaseUser";
  static const String endpointBoardgamesLoanStats = "$endpointBaseAnalytics/loan_activity/$endpointBaseUser";

}