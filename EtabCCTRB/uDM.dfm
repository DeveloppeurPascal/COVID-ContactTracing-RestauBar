object dm: Tdm
  OldCreateOrder = False
  Height = 600
  Width = 804
  object RESTClient1: TRESTClient
    BaseURL = 'http://localhost:8080/types'
    Params = <>
    Left = 544
    Top = 160
  end
  object RESTRequest1: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    Left = 552
    Top = 168
  end
  object RESTResponse1: TRESTResponse
    Left = 560
    Top = 176
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    Dataset = tabTypesEtablissements
    FieldDefs = <>
    Response = RESTResponse1
    TypesMode = Rich
    Left = 568
    Top = 184
  end
  object tabTypesEtablissements: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    Left = 568
    Top = 240
  end
end
