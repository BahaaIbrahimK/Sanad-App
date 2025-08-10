class APIConstances {
  static const String baseUrl = 'http://92.205.58.182:2001/api/';
  static const String contentType = "application/json";
  static const String accept = "application/json";

  // receiveTimeout
  static const int receiveTimeout = 20000;

// connectTimeout
  static const int connectTimeout = 20000;

}

abstract class EndPoints {
  static const String loginUrl = "Auth/Login";
  static const String getInspectorTypes = "WFInspection/GetLkupInspectorType";
  static const String getVisitsByInspectorId = "NewCosmInspection/GetVisitsByInspectorId";
  static const String getRequestsByVisitId = "WFInspection/GetRequestsByVisitId";
  static const String getRequestStatus = "CosmInspection/LkupRequestStatus";
  static const String getDocumentAsBase64ByDocPath = "Attachments/GetDocumentAsBase64";
  static const String uomTypes = "CosmInspection/LkupUomDTO";
  static const String packingTypes = "NewCosmInspection/GetAllLkupPackingTypes";
  static const String variationTypes = "WFInspection/GetVariationTypes";
  static const String getBolAndInvoicesData = "NewCosmInspection/GetBolByRequestId";
  static const String getLkupCurrency = "NewCosmInspection/GetLkupCurrency";
  static const String getLkupCountry = "NewICR/GetLkupCountry";
  static const String getLkupPorts = "NewCosmInspection/GetLkupPorts";
  static const String getApplicants = "NewICR/GetApplicants";
  static const String getProductByNotificationNo = "ICR/GetProductByNotificationNo";
  static const String getLkupSampleReason = "NewCosmInspection/GetLkupSampleReason";
  static const String getLkupFreezeReason = "NewCosmInspection/GetLkupHoldReason";
  static const String getLkupFlagReason = "NewCosmInspection/GetLkupFlagReason";

  static const String getRequestAndItems = "WFInspection/GetRequestAndItemsByIdAndInvoiceId";
  static const String createItemResultFlagReason = "ItemResult/CreateItemResultFlagReason";
  static const String createItemResultHoldReason = "ItemResult/CreateItemResultHoldReason";
  static const String createItemResultSampleReason = "ItemResult/CreateItemResultSampleReason";

  static const String getInspAttachmentsDataForScreen = "Attachments/GetInspAttachmentsDataForScreen";

  static const String getItemResultById = "ItemResult/GetItemResultById";


}