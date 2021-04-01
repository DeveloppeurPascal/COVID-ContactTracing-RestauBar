unit uAPI_etb;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys, System.SysUtils;

type
  TProcEvent = procedure of object;
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
procedure API_EtbChg(IDEtablissement: integer; RaisonSociale: string;
  IDTypeEtablissement: integer);

/// <summary>
/// API "etbchg" - modification de l'établissement en asynchrone
/// </summary>
procedure API_EtbChgASync(IDEtablissement: integer; RaisonSociale: string;
  IDTypeEtablissement: integer; Callback: TProc); overload;
procedure API_EtbChgASync(IDEtablissement: integer; RaisonSociale: string;
  IDTypeEtablissement: integer; Callback: TProcEvent); overload;

/// <summary>
/// API "etbcascontact" - Test si cas contact dans l'établissement et retourne la liste des périodes
/// </summary>
function API_EtbCasContact(IDEtablissement: integer): tfdmemtable;

/// <summary>
/// API "etbcascontact" - Test si cas contact dans l'établissement et retourne la liste des périodes en asynchrone
/// </summary>
procedure API_EtbCasContactASync(IDEtablissement: integer;
  Callback: TProc<tfdmemtable>); overload;
procedure API_EtbCasContactASync(IDEtablissement: integer;
  Callback: TProcEvent<tfdmemtable>); overload;

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

procedure API_EtbChg(IDEtablissement: integer; RaisonSociale: string;
IDTypeEtablissement: integer);
var
  serveur: thttpclient;
  reponse: ihttpresponse;
  params: tstringlist;
begin
  serveur := thttpclient.Create;
  try
    params := tstringlist.Create;
    try
      params.AddPair('i', IDEtablissement.tostring);
      params.AddPair('l', RaisonSociale);
      params.AddPair('t', IDTypeEtablissement.tostring);
      try
        reponse := serveur.post(getAPIURL + 'etbchg', params);
      except

      end;
    finally
      params.free;
    end;
  finally
    serveur.free;
  end;
end;

procedure API_EtbChgASync(IDEtablissement: integer; RaisonSociale: string;
IDTypeEtablissement: integer; Callback: TProc); overload;
begin
  ttask.run(
    procedure
    begin
      if assigned(Callback) then
      begin
        API_EtbChg(IDEtablissement, RaisonSociale, IDTypeEtablissement);
        tthread.Queue(nil,
          procedure
          begin
            Callback;
          end);
      end;
    end);
end;

procedure API_EtbChgASync(IDEtablissement: integer; RaisonSociale: string;
IDTypeEtablissement: integer; Callback: TProcEvent); overload;
begin
  API_EtbChgASync(IDEtablissement, RaisonSociale, IDTypeEtablissement,
    procedure
    begin
      if assigned(Callback) then
        Callback;
    end);
end;

function API_EtbCasContact(IDEtablissement: integer): tfdmemtable;
var
  serveur: thttpclient;
  reponse: ihttpresponse;
  jsa: tjsonarray;
  jso: tjsonobject;
  jsv: tjsonvalue;
  Date1, Date2: string;
begin
  result := tfdmemtable.Create(nil);
  // TODO : convertir les dates AAAAMMJJHHMM en vraies dates
  result.FieldDefs.Add('StartDate', tfieldtype.ftString, 12);
  result.FieldDefs.Add('EndDate', tfieldtype.ftString, 12);
  result.open;
  serveur := thttpclient.Create;
  try
    try
      reponse := serveur.get(getAPIURL + 'etbcascontact?i=' +
        IDEtablissement.tostring);
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
                Date1 := (jso.GetValue('StartDate') as TJSONString).Value;
                try
                  Date2 := (jso.GetValue('EndDate') as TJSONString).Value;
                  result.Insert;
                  result.FieldByName('StartDate').AsString := Date1;
                  result.FieldByName('EndDate').AsString := Date2;
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

procedure API_EtbCasContactASync(IDEtablissement: integer;
Callback: TProc<tfdmemtable>); overload;
begin
  ttask.run(
    procedure
    var
      tab: tfdmemtable;
    begin
      if assigned(Callback) then
      begin
        tab := API_EtbCasContact(IDEtablissement);
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

procedure API_EtbCasContactASync(IDEtablissement: integer;
Callback: TProcEvent<tfdmemtable>); overload;
begin
  API_EtbCasContactASync(IDEtablissement,
    procedure(tab: tfdmemtable)
    begin
      if assigned(Callback) then
        Callback(tab);
    end);
end;

end.
