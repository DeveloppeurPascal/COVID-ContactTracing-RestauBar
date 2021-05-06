unit UAPI_cli;

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
  /// API "cliadd" - inscription du client
  /// </summary>
procedure API_CliAdd(var ID: integer; var KPriv, KPub: string);

/// <summary>
/// API "cliadd" - inscription du client en asynchrone avec retour de son ID
/// </summary>
procedure API_CliAddASync(Callback: TProc<integer, string, string>); overload;
procedure API_CliAddASync(Callback: TProcEvent<integer, string,
  string>); overload;

/// <summary>
/// API "deccovidplus" - déclaration en tant que COVID+
/// </summary>
procedure API_CliDecCOVIDPlus(IDClient: integer; KPriv: string);

/// <summary>
/// API "deccovidplus" - déclaration en tant que COVID+ en asynchrone
/// </summary>
procedure API_CliDecCOVIDPlusASync(IDClient: integer; KPriv: string;
  Callback: TProc); overload;
procedure API_CliDecCOVIDPlusASync(IDClient: integer; KPriv: string;
  Callback: TProcEvent); overload;

/// <summary>
/// API "clicascontact" - Test si cas contact pour le client et retourne la liste des périodes
/// </summary>
function API_CliCasContact(IDClient: integer; KPriv: string): tfdmemtable;

/// <summary>
/// API "clicascontact" - Test si cas contact pour le client et retourne la liste des périodes en asynchrone
/// </summary>
procedure API_CliCasContactASync(IDClient: integer; KPriv: string;
  Callback: TProc<tfdmemtable>); overload;
procedure API_CliCasContactASync(IDClient: integer; KPriv: string;
  Callback: TProcEvent<tfdmemtable>); overload;

/// <summary>
/// API "cliinetb" - entrée dans un établissement
/// </summary>
procedure API_CliEntreDansEtablissement(IDClient, IDEtablissement: integer;
  KPriv: string);

/// <summary>
/// API "cliinetb" - entrée dans un établissement en asynchrone
/// </summary>
procedure API_CliEntreDansEtablissementASync(IDClient, IDEtablissement: integer;
  KPriv: string; Callback: TProc); overload;
procedure API_CliEntreDansEtablissementASync(IDClient, IDEtablissement: integer;
  KPriv: string; Callback: TProcEvent); overload;

/// <summary>
/// API "clioutetb" - sortie d'un établissement
/// </summary>
procedure API_CliSortDUnEtablissement(IDClient, IDEtablissement: integer;
  KPriv: string);

/// <summary>
/// API "clioutetb" - sortie d'un établissement en asynchrone
/// </summary>
procedure API_CliSortDUnEtablissementASync(IDClient, IDEtablissement: integer;
  KPriv: string; Callback: TProc); overload;
procedure API_CliSortDUnEtablissementASync(IDClient, IDEtablissement: integer;
  KPriv: string; Callback: TProcEvent); overload;

implementation

uses
  System.Net.HttpClient, uAPI, System.JSON, System.Classes, System.Threading,
  uCCTRBPrivateKey, uChecksumVerif, uConfig;

procedure API_CliAdd(var ID: integer; var KPriv, KPub: string);
var
  serveur: thttpclient;
  reponse: ihttpresponse;
  jso: tjsonobject;
begin
  ID := -1;
  serveur := thttpclient.Create;
  try
    try
      reponse := serveur.get(getAPIURL('cliadd') + '?v=' +
        ChecksumVerif.get(getCCTRBPrivateKey));
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
                ID := (jso.GetValue('id') as tjsonnumber).AsInt;
              except
                ID := -1;
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
    serveur.free;
  end;
end;

procedure API_CliAddASync(Callback: TProc<integer, string, string>);
begin
  ttask.run(
    procedure
    var
      ID: integer;
      KPriv, KPub: string;
    begin
      if assigned(Callback) then
      begin
        API_CliAdd(ID, KPriv, KPub);
        tthread.Queue(nil,
          procedure
          begin
            Callback(ID, KPriv, KPub);
          end);
      end;
    end);
end;

procedure API_CliAddASync(Callback: TProcEvent<integer, string, string>);
begin
  API_CliAddASync(
    procedure(ID: integer; KPriv, KPub: string)
    begin
      if assigned(Callback) then
        Callback(ID, KPriv, KPub);
    end);
end;

function API_CliCasContact(IDClient: integer; KPriv: string): tfdmemtable;
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
      reponse := serveur.get(getAPIURL('clicascontact') + '?c=' +
        IDClient.tostring + '&v=' + ChecksumVerif.get(KPriv,
        IDClient.tostring));
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

procedure API_CliCasContactASync(IDClient: integer; KPriv: string;
Callback: TProc<tfdmemtable>); overload;
begin
  ttask.run(
    procedure
    var
      tab: tfdmemtable;
    begin
      if assigned(Callback) then
      begin
        tab := API_CliCasContact(IDClient, KPriv);
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

procedure API_CliCasContactASync(IDClient: integer; KPriv: string;
Callback: TProcEvent<tfdmemtable>); overload;
begin
  API_CliCasContactASync(IDClient, KPriv,
    procedure(tab: tfdmemtable)
    begin
      if assigned(Callback) then
        Callback(tab);
    end);
end;

procedure API_CliDecCOVIDPlus(IDClient: integer; KPriv: string);
var
  serveur: thttpclient;
begin
  serveur := thttpclient.Create;
  try
    try
      serveur.get(getAPIURL('deccovidplus') + '?c=' + IDClient.tostring + '&v='
        + ChecksumVerif.get(KPriv, IDClient.tostring));
      // TODO : gérer réponse (code de retour et éventuellement erreur si <> 200)
    except

    end;
  finally
    serveur.free;
  end;
end;

procedure API_CliDecCOVIDPlusASync(IDClient: integer; KPriv: string;
Callback: TProc); overload; // TODO: ajouter un callback en cas d'erreur
begin
  ttask.run(
    procedure
    begin
      API_CliDecCOVIDPlus(IDClient, KPriv);
      if assigned(Callback) then
      begin
        tthread.Queue(nil,
          procedure
          begin
            Callback;
          end);
      end;
    end);
end;

procedure API_CliDecCOVIDPlusASync(IDClient: integer; KPriv: string;
Callback: TProcEvent); overload;
begin
  API_CliDecCOVIDPlusASync(IDClient, KPriv,
    procedure
    begin
      if assigned(Callback) then
        Callback;
    end);
end;

procedure API_CliEntreDansEtablissement(IDClient, IDEtablissement: integer;
KPriv: string);
var
  serveur: thttpclient;
begin
  serveur := thttpclient.Create;
  try
    try
      serveur.get(getAPIURL('cliinetb') + '?c=' + IDClient.tostring + '&i=' +
        IDEtablissement.tostring + '&v=' + ChecksumVerif.get(KPriv,
        IDClient.tostring, IDEtablissement.tostring));
      // TODO : gérer réponse (code de retour et éventuellement erreur si <> 200)
    except

    end;
  finally
    serveur.free;
  end;
end;

procedure API_CliEntreDansEtablissementASync(IDClient, IDEtablissement: integer;
KPriv: string; Callback: TProc); overload;
begin
  ttask.run(
    procedure
    begin
      API_CliEntreDansEtablissement(IDClient, IDEtablissement, KPriv);
      if assigned(Callback) then
      begin
        tthread.Queue(nil,
          procedure
          begin
            Callback;
          end);
      end;
    end);
end;

procedure API_CliEntreDansEtablissementASync(IDClient, IDEtablissement: integer;
KPriv: string; Callback: TProcEvent); overload;
begin
  API_CliEntreDansEtablissementASync(IDClient, IDEtablissement, KPriv,
    procedure
    begin
      if assigned(Callback) then
        Callback;
    end);
end;

procedure API_CliSortDUnEtablissement(IDClient, IDEtablissement: integer;
KPriv: string);
var
  serveur: thttpclient;
begin
  serveur := thttpclient.Create;
  try
    try
      serveur.get(getAPIURL('clioutetb') + '?c=' + IDClient.tostring + '&i=' +
        IDEtablissement.tostring + '&v=' + ChecksumVerif.get(KPriv,
        IDClient.tostring, IDEtablissement.tostring));
      // TODO : gérer réponse (code de retour et éventuellement erreur si <> 200)
    except

    end;
  finally
    serveur.free;
  end;
end;

procedure API_CliSortDUnEtablissementASync(IDClient, IDEtablissement: integer;
KPriv: string; Callback: TProc); overload;
begin
  ttask.run(
    procedure
    begin
      API_CliSortDUnEtablissement(IDClient, IDEtablissement, KPriv);
      if assigned(Callback) then
      begin
        tthread.Queue(nil,
          procedure
          begin
            Callback;
          end);
      end;
    end);
end;

procedure API_CliSortDUnEtablissementASync(IDClient, IDEtablissement: integer;
KPriv: string; Callback: TProcEvent); overload;
begin
  API_CliSortDUnEtablissementASync(IDClient, IDEtablissement, KPriv,
    procedure
    begin
      if assigned(Callback) then
        Callback;
    end);
end;

end.
