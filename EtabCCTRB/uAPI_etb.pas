unit uAPI_etb;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys, FireDAC.Phys.SQLite, System.SysUtils;

type
  TProcEvent<T> = procedure(Arg1: T) of object;

  /// <summary>
  /// API "etbadd" - inscription de l'établissement
  /// </summary>
function API_EtbAdd(RaisonSociale: string;
  IDTypeEtablissement: integer): integer;

/// <summary>
/// API "etbadd" - inscription de l'établissement en asynchrone avec retour de son ID
/// </summary>
procedure API_EtbAddASync(RaisonSociale: string; IDTypeEtablissement: integer;
  Callback: TProc<integer>); overload;
procedure API_EtbAddASync(RaisonSociale: string; IDTypeEtablissement: integer;
  Callback: TProcEvent<integer>); overload;

/// <summary>
/// API "etbchg" - modification de l'établissement
/// </summary>
procedure API_EtbChange(IDEtablissement: integer; RaisonSociale: string;
  IDTypeEtablissement: integer);

/// <summary>
/// API "etbcascontact" - Test si cas contact dans l'établissement et retourne la liste des périodes
/// </summary>
function API_EtbCasContact(IDEtablissement: integer): tfdmemtable;

implementation

uses
  System.Net.HttpClient, uAPI, System.JSON, System.Classes, System.Threading;

function API_EtbAdd(RaisonSociale: string;
  IDTypeEtablissement: integer): integer;
var
  serveur: thttpclient;
  reponse: ihttpresponse;
  jso: tjsonobject;
  params: tstringlist;
begin
  result := -1;
  serveur := thttpclient.Create;
  try
    params := tstringlist.Create;
    try
      params.AddPair('l', RaisonSociale);
      params.AddPair('t', IDTypeEtablissement.tostring);
      try
        reponse := serveur.post(getAPIURL + 'etbadd', params);
        if (reponse.StatusCode = 200) then
          try
            try
              jso := tjsonobject.ParseJSONValue(reponse.ContentAsString)
                as tjsonobject;
            except
              jso := tjsonobject.Create;
            end;
            if assigned(jso) then
              try
                try
                  result := (jso.GetValue('id') as tjsonnumber).AsInt;
                except
                end;
              finally
                jso.free;
              end;
          except

          end;
      except

      end;
    finally
      params.free;
    end;
  finally
    serveur.free;
  end;
end;

procedure API_EtbAddASync(RaisonSociale: string; IDTypeEtablissement: integer;
  Callback: TProc<integer>);
begin
  ttask.run(
    procedure
    var
      id: integer;
    begin
      if assigned(Callback) then
      begin
        id := API_EtbAdd(RaisonSociale, IDTypeEtablissement);
        tthread.Queue(nil,
          procedure
          begin
            Callback(id);
          end);
      end;
    end);
end;

procedure API_EtbAddASync(RaisonSociale: string; IDTypeEtablissement: integer;
Callback: TProcEvent<integer>);
begin
  API_EtbAddASync(RaisonSociale, IDTypeEtablissement,
    procedure(id: integer)
    begin
      if assigned(Callback) then
        Callback(id);
    end);
end;

procedure API_EtbChange(IDEtablissement: integer; RaisonSociale: string;
IDTypeEtablissement: integer);
begin
  // TODO : à compléter
end;

function API_EtbCasContact(IDEtablissement: integer): tfdmemtable;
begin
  // TODO : à compléter
  result := nil;
end;

end.
