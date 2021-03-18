object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 443
  Width = 755
  object tabTypesEtablissements: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 496
    Top = 80
  end
end
