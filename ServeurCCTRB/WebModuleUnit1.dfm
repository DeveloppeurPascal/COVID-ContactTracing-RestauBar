object WebModule1: TWebModule1
  OldCreateOrder = False
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebModule1DefaultHandlerAction
    end
    item
      MethodType = mtGet
      Name = 'ListeTypesEtablissements'
      PathInfo = '/types'
      OnAction = WebModule1ListeTypesEtablissementsAction
    end
    item
      MethodType = mtPost
      Name = 'InscriptionEtablissement'
      PathInfo = '/etbadd'
      OnAction = WebModule1InscriptionEtablissementAction
    end>
  Height = 230
  Width = 415
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 192
    Top = 96
  end
end
