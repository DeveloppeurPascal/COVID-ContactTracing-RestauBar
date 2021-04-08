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
    end
    item
      MethodType = mtPost
      Name = 'ModificationEtablissement'
      PathInfo = '/etbchg'
      OnAction = WebModule1ModificationEtablissementAction
    end
    item
      MethodType = mtGet
      Name = 'TestCasContactEtablissement'
      PathInfo = '/etbcascontact'
      OnAction = WebModule1TestCasContactEtablissementAction
    end
    item
      MethodType = mtGet
      Name = 'InscriptionClient'
      PathInfo = '/cliadd'
      OnAction = WebModule1InscriptionclientAction
    end
    item
      MethodType = mtGet
      Name = 'EntreeDansEtablissement'
      PathInfo = '/cliinetb'
      OnAction = WebModule1EntreeDansEtablissementAction
    end
    item
      MethodType = mtGet
      Name = 'SortieDEtablissement'
      PathInfo = '/clioutetb'
      OnAction = WebModule1SortieDEtablissementAction
    end
    item
      MethodType = mtGet
      Name = 'DeclarationCOVIDPositif'
      PathInfo = '/deccovidplus'
      OnAction = WebModule1DeclarationCOVIDPositifAction
    end
    item
      MethodType = mtGet
      Name = 'TestCasContactClient'
      PathInfo = '/clicascontact'
      OnAction = WebModule1TestCasContactClientAction
    end>
  Height = 230
  Width = 415
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 192
    Top = 96
  end
end
