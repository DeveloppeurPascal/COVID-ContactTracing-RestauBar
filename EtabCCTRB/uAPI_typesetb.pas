unit uAPI_typesetb;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys;

type
  TListeTypesEtbProc = reference to procedure(TabListeTypesEtb: TFDMemtable);
  TListeTypesEtbEvent = procedure(TabListeTypesEtb: TFDMemtable) of object;

  /// <summary>
  /// API "types" - Retourne la liste des types d'établissements
  /// </summary>
function API_ListeTypeEtablissements: TFDMemtable;

/// <summary>
/// API "types" - Passe la liste des types d'établissements à la fonction de callback en asynchrone
/// </summary>
procedure API_ListeTypeEtablissementsAsync
  (Callback: TListeTypesEtbProc); overload;
procedure API_ListeTypeEtablissementsAsync
  (Callback: TListeTypesEtbEvent); overload;

implementation

uses
  system.net.HttpClient, uAPI, system.json, system.Threading, system.Classes, system.SysUtils;

function API_ListeTypeEtablissements: TFDMemtable;
var
  serveur: thttpclient;
  reponse: ihttpresponse;
  jsa: tjsonarray;
  jso: tjsonobject;
  jsv: tjsonvalue;
  id: integer;
  libelle: string;
begin
  result := TFDMemtable.Create(nil);
  result.FieldDefs.Add('id', tfieldtype.ftInteger);
  result.FieldDefs.Add('label', tfieldtype.ftString, 100);
  result.open;
  serveur := thttpclient.Create;
  try
    try
      reponse := serveur.get(getAPIURL('types'));
      if (reponse.StatusCode = 200) then
      begin
        try
          jsa := tjsonobject.ParseJSONValue(reponse.ContentAsString)
            as tjsonarray;
        except
          jsa := tjsonarray.Create;
        end;
        if assigned(jsa) then
        begin
          for jsv in jsa do
            try
              jso := jsv as tjsonobject;
              try
                id := (jso.GetValue('id') as tjsonnumber).AsInt;
                try
                  libelle := (jso.GetValue('label') as TJSONString).Value;
                  result.Insert;
                  result.FieldByName('id').AsInteger := id;
                  result.FieldByName('label').Asstring := libelle;
                  result.post;
                except

                end;
              except

              end;
            except

            end;
          jsa.free;
        end;
      end;
    except

    end;
  finally
    serveur.free;
  end;
end;

procedure API_ListeTypeEtablissementsAsync(Callback: TListeTypesEtbProc);
begin
  ttask.run(
    procedure
    var
      tab: TFDMemtable;
    begin
      if assigned(Callback) then
      begin
        tab := API_ListeTypeEtablissements;
        if assigned(tab) then
          tthread.Queue(nil,
            procedure
            begin
              if assigned(Callback) then
                Callback(tab);
              tab.free;
            end);
      end;
    end);
end;

procedure API_ListeTypeEtablissementsAsync(Callback: TListeTypesEtbEvent);
begin
  API_ListeTypeEtablissementsAsync(
    procedure(tab: TFDMemtable)
    begin
      if assigned(Callback) then
        Callback(tab);
    end);
end;

end.
