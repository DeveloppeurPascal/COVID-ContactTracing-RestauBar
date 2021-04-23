unit uAPI_etb;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys, System.SysUtils;

type
  TProcEvent = procedure of object;
  TProcEvent<T> = procedure(Arg1: T) of object;
  TProcEvent<T1, T2, T3> = procedure(Arg1: T1; Arg2: T2; Arg3: T3) of object;

  /// <summary>
  /// API "etbadd" - inscription de l'établissement
  /// </summary>
procedure API_EtbAdd(RaisonSociale: string; IDTypeEtablissement: integer;
  var IDEtb: integer; var KPriv, KPub: string);

/// <summary>
/// API "etbadd" - inscription de l'établissement en asynchrone avec retour de son ID
/// </summary>
procedure API_EtbAddASync(RaisonSociale: string; IDTypeEtablissement: integer;
  Callback: TProc<integer, string, string>); overload;
procedure API_EtbAddASync(RaisonSociale: string; IDTypeEtablissement: integer;
  Callback: TProcEvent<integer, string, string>); overload;

/// <summary>
/// API "etbchg" - modification de l'établissement
/// </summary>
procedure API_EtbChg(IDEtablissement: integer; RaisonSociale: string;
  IDTypeEtablissement: integer; KPriv: string);

/// <summary>
/// API "etbchg" - modification de l'établissement en asynchrone
/// </summary>
procedure API_EtbChgASync(IDEtablissement: integer; RaisonSociale: string;
  IDTypeEtablissement: integer; KPriv: string; Callback: TProc); overload;
procedure API_EtbChgASync(IDEtablissement: integer; RaisonSociale: string;
  IDTypeEtablissement: integer; KPriv: string; Callback: TProcEvent); overload;

/// <summary>
/// API "etbcascontact" - Test si cas contact dans l'établissement et retourne la liste des périodes
/// </summary>
function API_EtbCasContact(IDEtablissement: integer; KPriv: string)
  : tfdmemtable;

/// <summary>
/// API "etbcascontact" - Test si cas contact dans l'établissement et retourne la liste des périodes en asynchrone
/// </summary>
procedure API_EtbCasContactASync(IDEtablissement: integer; KPriv: string;
  Callback: TProc<tfdmemtable>); overload;
procedure API_EtbCasContactASync(IDEtablissement: integer; KPriv: string;
  Callback: TProcEvent<tfdmemtable>); overload;

implementation

uses
  System.Net.HttpClient, uAPI, System.JSON, System.Classes, System.Threading,
  uCCTRBPrivateKey, uChecksumVerif;

procedure API_EtbAdd(RaisonSociale: string; IDTypeEtablissement: integer;
  var IDEtb: integer; var KPriv, KPub: string);
var
  serveur: thttpclient;
  reponse: ihttpresponse;
  jso: tjsonobject;
  params: tstringlist;
begin
  IDEtb := -1;
  serveur := thttpclient.Create;
  try
    params := tstringlist.Create;
    try
      params.AddPair('l', RaisonSociale);
      params.AddPair('t', IDTypeEtablissement.tostring);
      params.AddPair('v', ChecksumVerif.get(getCCTRBPrivateKey, RaisonSociale,
        IDTypeEtablissement.tostring));
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
                  IDEtb := (jso.GetValue('id') as tjsonnumber).AsInt;
                except
                  IDEtb := -1;
                end;
                try
                  KPriv := (jso.GetValue('kpriv') as tjsonstring).Value;
                except
                  KPriv := '';
                end;
                try
                  KPub := (jso.GetValue('kpub') as tjsonstring).Value;
                except
                  KPub := '';
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
  Callback: TProc<integer, string, string>);
begin
  ttask.run(
    procedure
    var
      id: integer;
      KPriv, KPub: string;
    begin
      if assigned(Callback) then
      begin
        API_EtbAdd(RaisonSociale, IDTypeEtablissement, id, KPriv, KPub);
        tthread.Queue(nil,
          procedure
          begin
            Callback(id, KPriv, KPub);
          end);
      end;
    end);
end;

procedure API_EtbAddASync(RaisonSociale: string; IDTypeEtablissement: integer;
Callback: TProcEvent<integer, string, string>);
begin
  API_EtbAddASync(RaisonSociale, IDTypeEtablissement,
    procedure(id: integer; KPriv, KPub: string)
    begin
      if assigned(Callback) then
        Callback(id, KPriv, KPub);
    end);
end;

procedure API_EtbChg(IDEtablissement: integer; RaisonSociale: string;
IDTypeEtablissement: integer; KPriv: string);
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
      params.AddPair('v1', ChecksumVerif.get(getCCTRBPrivateKey,
        IDEtablissement.tostring, RaisonSociale, IDTypeEtablissement.tostring));
      params.AddPair('v2', ChecksumVerif.get(KPriv, IDEtablissement.tostring,
        RaisonSociale, IDTypeEtablissement.tostring));
      try
        reponse := serveur.post(getAPIURL + 'etbchg', params);
        // TODO : gérer code retour (notamment 404 ou 500)
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
IDTypeEtablissement: integer; KPriv: string; Callback: TProc); overload;
begin
  ttask.run(
    procedure
    begin
      if assigned(Callback) then
      begin
        API_EtbChg(IDEtablissement, RaisonSociale, IDTypeEtablissement, KPriv);
        tthread.Queue(nil,
          procedure
          begin
            Callback;
          end);
      end;
    end);
end;

procedure API_EtbChgASync(IDEtablissement: integer; RaisonSociale: string;
IDTypeEtablissement: integer; KPriv: string; Callback: TProcEvent); overload;
begin
  API_EtbChgASync(IDEtablissement, RaisonSociale, IDTypeEtablissement, KPriv,
    procedure
    begin
      if assigned(Callback) then
        Callback;
    end);
end;

function API_EtbCasContact(IDEtablissement: integer; KPriv: string)
  : tfdmemtable;
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
        IDEtablissement.tostring + '&v=' + ChecksumVerif.get(KPriv,
        IDEtablissement.tostring));
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
                Date1 := (jso.GetValue('StartDate') as tjsonstring).Value;
                try
                  Date2 := (jso.GetValue('EndDate') as tjsonstring).Value;
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

procedure API_EtbCasContactASync(IDEtablissement: integer; KPriv: string;
Callback: TProc<tfdmemtable>); overload;
begin
  ttask.run(
    procedure
    var
      tab: tfdmemtable;
    begin
      if assigned(Callback) then
      begin
        tab := API_EtbCasContact(IDEtablissement, KPriv);
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

procedure API_EtbCasContactASync(IDEtablissement: integer; KPriv: string;
Callback: TProcEvent<tfdmemtable>); overload;
begin
  API_EtbCasContactASync(IDEtablissement, KPriv,
    procedure(tab: tfdmemtable)
    begin
      if assigned(Callback) then
        Callback(tab);
    end);
end;

end.
