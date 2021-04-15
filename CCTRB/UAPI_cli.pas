unit UAPI_cli;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys, System.SysUtils;

type
  TProcEvent = procedure of object;
  TProcEvent<T> = procedure(Arg1: T) of object;

  /// <summary>
  /// API "cliadd" - inscription du client
  /// </summary>
function API_CliAdd: integer;

/// <summary>
/// API "cliadd" - inscription du client en asynchrone avec retour de son ID
/// </summary>
procedure API_CliAddASync(Callback: TProc<integer>); overload;
procedure API_CliAddASync(Callback: TProcEvent<integer>); overload;

/// <summary>
/// API "deccovidplus" - déclaration en tant que COVID+
/// </summary>
procedure API_CliDecCOVIDPlus(IDClient: integer);

/// <summary>
/// API "deccovidplus" - déclaration en tant que COVID+ en asynchrone
/// </summary>
procedure API_CliDecCOVIDPlusASync(IDClient: integer; Callback: TProc);
  overload;
procedure API_CliDecCOVIDPlusASync(IDClient: integer;
  Callback: TProcEvent); overload;

/// <summary>
/// API "clicascontact" - Test si cas contact pour le client et retourne la liste des périodes
/// </summary>
function API_CliCasContact(IDClient: integer): tfdmemtable;

/// <summary>
/// API "clicascontact" - Test si cas contact pour le client et retourne la liste des périodes en asynchrone
/// </summary>
procedure API_CliCasContactASync(IDClient: integer;
  Callback: TProc<tfdmemtable>); overload;
procedure API_CliCasContactASync(IDClient: integer;
  Callback: TProcEvent<tfdmemtable>); overload;

/// <summary>
/// API "cliinetb" - entrée dans un établissement
/// </summary>
procedure API_CliEntreDansEtablissement(IDClient, IDEtablissement: integer);

/// <summary>
/// API "cliinetb" - entrée dans un établissement en asynchrone
/// </summary>
procedure API_CliEntreDansEtablissementASync(IDClient, IDEtablissement: integer;
  Callback: TProc); overload;
procedure API_CliEntreDansEtablissementASync(IDClient, IDEtablissement: integer;
  Callback: TProcEvent); overload;

/// <summary>
/// API "clioutetb" - sortie d'un établissement
/// </summary>
procedure API_CliSortDUnEtablissement(IDClient, IDEtablissement: integer);

/// <summary>
/// API "clioutetb" - sortie d'un établissement en asynchrone
/// </summary>
procedure API_CliSortDUnEtablissementASync(IDClient, IDEtablissement: integer;
  Callback: TProc); overload;
procedure API_CliSortDUnEtablissementASync(IDClient, IDEtablissement: integer;
  Callback: TProcEvent); overload;

implementation

uses
  System.Net.HttpClient, uAPI, System.JSON, System.Classes, System.Threading;

function API_CliAdd: integer;
var
  serveur: thttpclient;
  reponse: ihttpresponse;
  jso: tjsonobject;
begin
  result := -1;
  serveur := thttpclient.Create;
  try
    try
      reponse := serveur.get(getAPIURL + 'cliadd');
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
    serveur.free;
  end;
end;

procedure API_CliAddASync(Callback: TProc<integer>);
begin
  ttask.run(
    procedure
    var
      id: integer;
    begin
      if assigned(Callback) then
      begin
        id := API_CliAdd;
        tthread.Queue(nil,
          procedure
          begin
            Callback(id);
          end);
      end;
    end);
end;

procedure API_CliAddASync(Callback: TProcEvent<integer>);
begin
  API_CliAddASync(
    procedure(id: integer)
    begin
      if assigned(Callback) then
        Callback(id);
    end);
end;

function API_CliCasContact(IDClient: integer): tfdmemtable;
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
      reponse := serveur.get(getAPIURL + 'clicascontact?c=' +
        IDClient.tostring);
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

procedure API_CliCasContactASync(IDClient: integer;
Callback: TProc<tfdmemtable>); overload;
begin
  ttask.run(
    procedure
    var
      tab: tfdmemtable;
    begin
      if assigned(Callback) then
      begin
        tab := API_CliCasContact(IDClient);
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

procedure API_CliCasContactASync(IDClient: integer;
Callback: TProcEvent<tfdmemtable>); overload;
begin
  API_CliCasContactASync(IDClient,
    procedure(tab: tfdmemtable)
    begin
      if assigned(Callback) then
        Callback(tab);
    end);
end;

procedure API_CliDecCOVIDPlus(IDClient: integer);
var
  serveur: thttpclient;
begin
  serveur := thttpclient.Create;
  try
    try
      serveur.get(getAPIURL + 'deccovidplus?c=' + IDClient.tostring);
      // TODO : gérer réponse (code de retour et éventuellement erreur si <> 200)
    except

    end;
  finally
    serveur.free;
  end;
end;

procedure API_CliDecCOVIDPlusASync(IDClient: integer; Callback: TProc);
  overload;              // TODO: ajouter un callback en cas d'erreur
begin
  ttask.run(
    procedure
    begin
      API_CliDecCOVIDPlus(IDClient);
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

procedure API_CliDecCOVIDPlusASync(IDClient: integer;
Callback: TProcEvent); overload;
begin
  API_CliDecCOVIDPlusASync(IDClient,
    procedure
    begin
      if assigned(Callback) then
        Callback;
    end);
end;

procedure API_CliEntreDansEtablissement(IDClient, IDEtablissement: integer);
var
  serveur: thttpclient;
begin
  serveur := thttpclient.Create;
  try
    try
      serveur.get(getAPIURL + 'cliinetb?c=' + IDClient.tostring + '&i=' +
        IDEtablissement.tostring);
      // TODO : gérer réponse (code de retour et éventuellement erreur si <> 200)
    except

    end;
  finally
    serveur.free;
  end;
end;

procedure API_CliEntreDansEtablissementASync(IDClient, IDEtablissement: integer;
Callback: TProc); overload;
begin
  ttask.run(
    procedure
    begin
      API_CliEntreDansEtablissement(IDClient, IDEtablissement);
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
Callback: TProcEvent); overload;
begin
  API_CliEntreDansEtablissementASync(IDClient, IDEtablissement,
    procedure
    begin
      if assigned(Callback) then
        Callback;
    end);
end;

procedure API_CliSortDUnEtablissement(IDClient, IDEtablissement: integer);
var
  serveur: thttpclient;
begin
  serveur := thttpclient.Create;
  try
    try
      serveur.get(getAPIURL + 'clioutetb?c=' + IDClient.tostring + '&i=' +
        IDEtablissement.tostring);
      // TODO : gérer réponse (code de retour et éventuellement erreur si <> 200)
    except

    end;
  finally
    serveur.free;
  end;
end;

procedure API_CliSortDUnEtablissementASync(IDClient, IDEtablissement: integer;
Callback: TProc); overload;
begin
  ttask.run(
    procedure
    begin
      API_CliSortDUnEtablissement(IDClient, IDEtablissement);
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
Callback: TProcEvent); overload;
begin
  API_CliSortDUnEtablissementASync(IDClient, IDEtablissement,
    procedure
    begin
      if assigned(Callback) then
        Callback;
    end);
end;

end.
