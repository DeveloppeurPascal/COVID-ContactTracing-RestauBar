unit WebModuleUnit1;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL;

type
  TWebModule1 = class(TWebModule)
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1ListeTypesEtablissementsAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1InscriptionEtablissementAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1ModificationEtablissementAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1TestCasContactEtablissementAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1InscriptionclientAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1EntreeDansEtablissementAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1SortieDEtablissementAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1DeclarationCOVIDPositifAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1TestCasContactClientAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    FDBConnexion: TFDConnection;
    function GetFDBConnexion: TFDConnection;
    { D�clarations priv�es }
  protected
    property DBConnexion: TFDConnection read GetFDBConnexion;
  public
    { D�clarations publiques }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}

uses
  System.json, System.SyncObjs, uTools, uCCTRBPrivateKey, uChecksumVerif;

var
  MUTEXInscriptionEtablissementAction, MUTEXInscriptionClientAction: tmutex;

function TWebModule1.GetFDBConnexion: TFDConnection;
const
  _ConnectionDefName = '{E6089F63-1C77-41BD-A882-3E00F0B009C2}';
var
  DBParams: tstringlist;
begin
  if not assigned(FDBConnexion) then
  begin
    if not FDManager.IsConnectionDef(_ConnectionDefName) then
    begin
      DBParams := tstringlist.Create;
{$IFDEF DEBUG}
      DBParams.Values['Database'] := 'cctrb';
      DBParams.Values['User_Name'] := 'root';
      // TODO : change the DB user (never use 'root')
      DBParams.Values['Password'] := ''; // TODO : change the DB password
      DBParams.Values['DriverID'] := 'MySQL';

{$ELSE}
      // TODO : mettre identifiants base de production diff�rents de la base de d�veloppement
      DBParams.Values['Database'] := 'XXX';
      DBParams.Values['User_Name'] := 'XXX';
      DBParams.Values['Password'] := 'XXX';
      DBParams.Values['DriverID'] := 'MySQL';
{$ENDIF}
      FDManager.AddConnectionDef(_ConnectionDefName, 'MySQL', DBParams);
    end;
    FDBConnexion := TFDConnection.Create(self);
    FDBConnexion.LoginPrompt := false;
    FDBConnexion.ConnectionDefName := _ConnectionDefName;
    FDBConnexion.Open;
  end;
  result := FDBConnexion;
end;

procedure TWebModule1.WebModule1DeclarationCOVIDPositifAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  idcli: integer;
  kpriv: string;
  Checksum: string;
  // http://localhost:8080/deccovidplus (GET avec c=idcli)
begin
  // r�cup�ration et test de l'existence de l'ID du client
  try
    idcli := Request.QueryFields.Values['c'].ToInteger;
  except
    idcli := -1;
  end;
  if not((idcli > 0) and (idcli = DBConnexion.ExecSQLScalar
    ('select IDClient from clients where IDClient=:id', [idcli]))) then
  begin
    Response.StatusCode := 400;
    Response.Content := 'unknown cli';
    exit;
  end;
  kpriv := DBConnexion.ExecSQLScalar
    ('select ClePrivee from clients where IDClient=:id', [idcli]);
  // R�cup�ration et v�rification du checksum V
  try
    Checksum := Request.ContentFields.Values['v'];
  except
    Checksum := '';
  end;
  if not ChecksumVerif.check(Checksum, kpriv, idcli.tostring) then
  begin
    Response.StatusCode := 500;
    Response.Content := 'internal server error';
    exit;
  end;
  // traitement de la demande puisque tout est ok
  try
    if (0 < DBConnexion.ExecSQL
      ('insert into declarations (IDClient, DateHeureDeclarationPositif) values (:idc, :dhdp)',
      [idcli, DateTimeToString14.Substring(0, 12)])) then
    begin
      // TODO : impacter les "cas contact" sur la base de donn�es d'historiques
      Response.StatusCode := 200;
      Response.Content := '';
      exit;
    end
    else
    begin
      Response.StatusCode := 400;
      Response.Content := 'SQL insert KO';
      exit;
    end;
  except
    Response.StatusCode := 404;
    Response.Content := '';
  end;
end;

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content := '<html>' +
    '<head><title>Application Serveur Web</title></head>' +
    '<body>Application Serveur Web</body>' + '</html>';
end;

procedure TWebModule1.WebModule1EntreeDansEtablissementAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  idetb, idcli: integer;
  kpriv: string;
  Checksum: string;
  // http://localhost:8080/cliinetb (GET avec i=idetb, c=idcli)
begin
  // r�cup�ration et test de l'existence de l'ID du client
  try
    idcli := Request.QueryFields.Values['c'].ToInteger;
  except
    idcli := -1;
  end;
  if not((idcli > 0) and (idcli = DBConnexion.ExecSQLScalar
    ('select IDClient from clients where IDClient=:id', [idcli]))) then
  begin
    Response.StatusCode := 400;
    Response.Content := 'unknown cli';
    exit;
  end;
  kpriv := DBConnexion.ExecSQLScalar
    ('select ClePrivee from clients where IDClient=:id', [idcli]);
  // r�cup�ration et test de l'existence de l'ID d'�tablissement
  try
    idetb := Request.QueryFields.Values['i'].ToInteger;
  except
    idetb := -1;
  end;
  if not((idetb > 0) and (idetb = DBConnexion.ExecSQLScalar
    ('select IDEtablissement from etablissements where IDEtablissement=:id',
    [idetb]))) then
  begin
    Response.StatusCode := 400;
    Response.Content := 'unknown etb';
    exit;
  end;
  // R�cup�ration et v�rification du checksum V
  try
    Checksum := Request.ContentFields.Values['v'];
  except
    Checksum := '';
  end;
  if not ChecksumVerif.check(Checksum, kpriv, idcli.tostring, idetb.tostring)
  then
  begin
    Response.StatusCode := 500;
    Response.Content := 'internal server error';
    exit;
  end;
  // traitement de la demande puisque tout est ok
  try
    if (0 < DBConnexion.ExecSQL
      ('insert into historiques (IDClient, IDEtablissement, DateHeureEntree) values (:idc, :ide, :dhe)',
      [idcli, idetb, DateTimeToString14.Substring(0, 12)])) then
    begin
      Response.StatusCode := 200;
      Response.Content := '';
      exit;
    end
    else
    begin
      Response.StatusCode := 400;
      Response.Content := 'SQL insert KO';
      exit;
    end;
  except
    Response.StatusCode := 404;
    Response.Content := '';
  end;
end;

procedure TWebModule1.WebModule1InscriptionclientAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  jso: tjsonobject;
  idcli: integer;
  kpriv, kpub: string;
  Checksum: string;
  // http://localhost:8080/cliadd (GET sans param�tre)
begin
  // R�cup�ration et v�rification du checksum
  try
    Checksum := Request.ContentFields.Values['v'];
  except
    Checksum := '';
  end;
  if not ChecksumVerif.check(Checksum, getCCTRBPrivateKey) then
  begin
    Response.StatusCode := 500;
    Response.Content := 'internal server error';
    exit;
  end;
  // traitement de la demande puisque tout est ok
  try
    kpub := getKeyPrivPub;
    kpriv := getKeyPrivPub;
    MUTEXInscriptionClientAction.Acquire;
    try
      if (0 < DBConnexion.ExecSQL
        ('insert into clients (ClePublique,ClePrivee) values (:kpu,:kpr)',
        [kpub, kpriv])) then
        idcli := DBConnexion.GetLastAutoGenValue('')
      else
        idcli := -1;
    finally
      MUTEXInscriptionClientAction.Release;
    end;
    if (idcli > -1) then
    begin
      jso := tjsonobject.Create;
      try
        jso.AddPair('id', tjsonnumber.Create(idcli));
        jso.AddPair('kpriv', kpriv);
        jso.AddPair('kpub', kpub);
        Response.StatusCode := 200;
        Response.ContentType := 'application/json';
        Response.Content := jso.ToJSON;
      finally
        jso.free;
      end;
    end
    else
    begin
      Response.StatusCode := 400;
      Response.Content := 'SQL insert KO';
      exit;
    end;
  except
    Response.StatusCode := 404;
    Response.Content := '';
  end;
end;

procedure TWebModule1.WebModule1InscriptionEtablissementAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  jso: tjsonobject;
  raisonsociale: string;
  idtypetablissement: integer;
  idetb: integer;
  kpriv, kpub: string;
  Checksum: string;
  // http://localhost:8080/etbadd (POST avec l=raisonsociale et t=idetablissement)
begin
  // r�cup�ration et test de l'existence de la raison sociale de l'�tablissement
  try
    raisonsociale := Request.ContentFields.Values['l'];
  except
    raisonsociale := '';
  end;
  // r�cup�ration et test de l'existence de l'ID du type d'�tablissement
  try
    idtypetablissement := Request.ContentFields.Values['t'].ToInteger;
  except
    idtypetablissement := -1;
  end;
  // R�cup�ration et v�rification du checksum
  try
    Checksum := Request.ContentFields.Values['v'];
  except
    Checksum := '';
  end;
  if not ChecksumVerif.check(Checksum, getCCTRBPrivateKey, raisonsociale,
    idtypetablissement.tostring) then
  begin
    Response.StatusCode := 500;
    Response.Content := 'internal server error';
    exit;
  end;
  // test validit� raison sociale
  if raisonsociale.IsEmpty then
  begin
    Response.StatusCode := 400;
    Response.Content := 'missing label parameter';
    exit;
  end;
  // test validit� type �tablissement
  if not((idtypetablissement > 0) and
    (idtypetablissement = DBConnexion.ExecSQLScalar
    ('select IDTypeEtablissement from typesetablissements where IDTypeEtablissement=:id',
    [idtypetablissement]))) then
  begin
    Response.StatusCode := 400;
    Response.Content := 'unknown etb type';
    exit;
  end;
  // traitement de la demande puisque tout est ok
  try
    kpriv := getKeyPrivPub;
    kpub := getKeyPrivPub;
    MUTEXInscriptionEtablissementAction.Acquire;
    try
      if (0 < DBConnexion.ExecSQL
        ('insert into etablissements (RaisonSociale,IDTypeEtablissement,ClePublique,ClePrivee) values (:rs,:idte,:kpub,:kpriv)',
        [raisonsociale, idtypetablissement, kpub, kpriv])) then
        idetb := DBConnexion.GetLastAutoGenValue('')
      else
        idetb := -1;
    finally
      MUTEXInscriptionEtablissementAction.Release;
    end;
    if (idetb > -1) then
    begin
      jso := tjsonobject.Create;
      try
        jso.AddPair('id', tjsonnumber.Create(idetb));
        jso.AddPair('kpriv', kpriv);
        jso.AddPair('kpub', kpub);
        Response.StatusCode := 200;
        Response.ContentType := 'application/json';
        Response.Content := jso.ToJSON;
      finally
        jso.free;
      end;
    end
    else
    begin
      Response.StatusCode := 400;
      Response.Content := 'SQL insert KO';
      exit;
    end;
  except
    Response.StatusCode := 404;
    Response.Content := '';
  end;
end;

procedure TWebModule1.WebModule1ListeTypesEtablissementsAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  qry: tfdquery;
  jsa: tjsonarray;
  // http://localhost:8080/types
begin
  // TODO : passer la langue en param�tre IN et sortir les textes dans la bonne langue
  try
    qry := tfdquery.Create(self);
    try
      qry.Connection := DBConnexion;
      qry.Open('select * from typesetablissements');
      jsa := tjsonarray.Create;
      try
        while not qry.Eof do
        begin
          jsa.Add(tjsonobject.Create.AddPair('id',
            tjsonnumber.Create(qry.fieldbyname('IDTypeEtablissement').AsInteger)
            ).AddPair('label', qry.fieldbyname('libelle').asstring));
          qry.next;
        end;
        Response.StatusCode := 200;
        Response.ContentType := 'application/json';
        Response.Content := jsa.ToJSON;
      finally
        jsa.free;
      end;
    finally
      qry.free;
    end;
  except
    Response.StatusCode := 404;
    Response.Content := '';
  end;
end;

procedure TWebModule1.WebModule1ModificationEtablissementAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  idetb: integer;
  raisonsociale: string;
  idtypetablissement: integer;
  Checksum: string;
  kpriv: string;
  // http://localhost:8080/etbchg (POST avec i=idetb l=raisonsociale et t=idetablissement)
begin
  // r�cup�ration et test de l'existence de l'ID d'�tablissement
  try
    idetb := Request.ContentFields.Values['i'].ToInteger;
  except
    idetb := -1;
  end;
  // r�cup�ration et test de l'existence de la raison sociale de l'�tablissement
  try
    raisonsociale := Request.ContentFields.Values['l'];
  except
    raisonsociale := '';
  end;
  // r�cup�ration et test de l'existence de l'ID du type d'�tablissement
  try
    idtypetablissement := Request.ContentFields.Values['t'].ToInteger;
  except
    idtypetablissement := -1;
  end;
  // R�cup�ration et v�rification du checksum V1
  try
    Checksum := Request.ContentFields.Values['v1'];
  except
    Checksum := '';
  end;
  if not ChecksumVerif.check(Checksum, getCCTRBPrivateKey, idetb.tostring,
    raisonsociale, idtypetablissement.tostring) then
  begin
    Response.StatusCode := 500;
    Response.Content := 'internal server error';
    exit;
  end;
  // v�rification �tablissement
  if not((idetb > 0) and (idetb = DBConnexion.ExecSQLScalar
    ('select IDEtablissement from etablissements where IDEtablissement=:id',
    [idetb]))) then
  begin
    Response.StatusCode := 400;
    Response.Content := 'unknown etb';
    exit;
  end;
  kpriv := DBConnexion.ExecSQLScalar
    ('select ClePrivee from etablissements where IDEtablissement=:id', [idetb]);
  // R�cup�ration et v�rification du checksum V2
  try
    Checksum := Request.ContentFields.Values['v2'];
  except
    Checksum := '';
  end;
  if not ChecksumVerif.check(Checksum, kpriv, idetb.tostring, raisonsociale,
    idtypetablissement.tostring) then
  begin
    Response.StatusCode := 500;
    Response.Content := 'internal server error';
    exit;
  end;
  // v�rification raison sociale
  if raisonsociale.IsEmpty then
  begin
    Response.StatusCode := 400;
    Response.Content := 'missing label parameter';
    exit;
  end;
  // v�rification type �tablissement
  if not((idtypetablissement > 0) and
    (idtypetablissement = DBConnexion.ExecSQLScalar
    ('select IDTypeEtablissement from typesetablissements where IDTypeEtablissement=:id',
    [idtypetablissement]))) then
  begin
    Response.StatusCode := 400;
    Response.Content := 'unknown etb type';
    exit;
  end;
  // traitement de la demande puisque tout est ok
  try
    if (0 < DBConnexion.ExecSQL
      ('update etablissements set RaisonSociale=:rs, IDTypeEtablissement=:idte where IDEtablissement=:id',
      [raisonsociale, idtypetablissement, idetb])) then
    begin
      Response.StatusCode := 200;
      Response.ContentType := 'application/json';
      Response.Content := '';
    end
    else
    begin
      Response.StatusCode := 400;
      Response.Content := 'SQL update KO';
      exit;
    end;
  except
    Response.StatusCode := 404;
    Response.Content := '';
  end;
end;

procedure TWebModule1.WebModule1SortieDEtablissementAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  idetb, idcli: integer;
  dhe: string;
  kpriv: string;
  Checksum: string;
  // http://localhost:8080/clioutetb (GET avec i=idetb, c=idcli)
begin
  // r�cup�ration et test de l'existence de l'ID du client
  try
    idcli := Request.QueryFields.Values['c'].ToInteger;
  except
    idcli := -1;
  end;
  if not((idcli > 0) and (idcli = DBConnexion.ExecSQLScalar
    ('select IDClient from clients where IDClient=:id', [idcli]))) then
  begin
    Response.StatusCode := 400;
    Response.Content := 'unknown cli';
    exit;
  end;
  kpriv := DBConnexion.ExecSQLScalar
    ('select ClePrivee from clients where IDClient=:id', [idcli]);
  // r�cup�ration et test de l'existence de l'ID d'�tablissement
  try
    idetb := Request.QueryFields.Values['i'].ToInteger;
  except
    idetb := -1;
  end;
  if not((idetb > 0) and (idetb = DBConnexion.ExecSQLScalar
    ('select IDEtablissement from etablissements where IDEtablissement=:id',
    [idetb]))) then
  begin
    Response.StatusCode := 400;
    Response.Content := 'unknown etb';
    exit;
  end;
  // R�cup�ration et v�rification du checksum V
  try
    Checksum := Request.ContentFields.Values['v'];
  except
    Checksum := '';
  end;
  if not ChecksumVerif.check(Checksum, kpriv, idcli.tostring, idetb.tostring)
  then
  begin
    Response.StatusCode := 500;
    Response.Content := 'internal server error';
    exit;
  end;
  // r�cup�ration de l'heure d'entr�e dans l'�tablissement
  try
    dhe := DBConnexion.ExecSQLScalar
      ('select DateHeureEntree from historiques where IDClient=:idc and IDEtablissement=:ide and ((DateHeureSortie is null) or (DateHeureSortie="000000000000")) order by DateHeureEntree desc',
      [idcli, idetb]);
    if (dhe.Length <> 12) then
    begin
      Response.StatusCode := 301; // redirection
      Response.Content := 'no entry found, submit one';
      exit;
    end;
  except
    Response.StatusCode := 400;
    Response.Content := 'unknown dhe';
    exit;
  end;
  // traitement de la demande puisque tout est ok
  try
    if (0 < DBConnexion.ExecSQL
      ('update historiques set DateHeureSortie=:dhs where IDClient=:idc and IDEtablissement=:ide and DateHeureEntree=:dhe',
      [DateTimeToString14.Substring(0, 12), idcli, idetb, dhe])) then
    begin
      Response.StatusCode := 200;
      Response.Content := '';
      exit;
    end
    else
    begin
      Response.StatusCode := 400;
      Response.Content := 'SQL update KO';
      exit;
    end;
  except
    Response.StatusCode := 404;
    Response.Content := '';
  end;
end;

procedure TWebModule1.WebModule1TestCasContactClientAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  idcli: integer;
  qry: tfdquery;
  jsa: tjsonarray;
  kpriv: string;
  Checksum: string;
  // http://localhost:8080/clicascontact (GET avec c=idcli)
begin
  // r�cup�ration et test de l'existence de l'ID du client
  try
    idcli := Request.QueryFields.Values['c'].ToInteger;
  except
    idcli := -1;
  end;
  if not((idcli > 0) and (idcli = DBConnexion.ExecSQLScalar
    ('select IDClient from clients where IDClient=:id', [idcli]))) then
  begin
    Response.StatusCode := 400;
    Response.Content := 'unknown cli';
    exit;
  end;
  kpriv := DBConnexion.ExecSQLScalar
    ('select ClePrivee from clients where IDClient=:id', [idcli]);
  // R�cup�ration et v�rification du checksum V
  try
    Checksum := Request.ContentFields.Values['v'];
  except
    Checksum := '';
  end;
  if not ChecksumVerif.check(Checksum, kpriv, idcli.tostring) then
  begin
    Response.StatusCode := 500;
    Response.Content := 'internal server error';
    exit;
  end;
  // traitement de la demande puisque tout est ok
  try
    jsa := tjsonarray.Create;
    try
      qry := tfdquery.Create(self);
      try
        qry.Connection := DBConnexion;
        qry.Open('select DateHeureEntree,DateHeureSortie from historiques where IDClient=:id and CasContact=1 order by DateHeureEntree,DateHeureSortie',
          [idcli]);
        while not qry.Eof do
        begin
          jsa.Add(tjsonobject.Create.AddPair('StartDate',
            qry.fieldbyname('DateHeureEntree').asstring).AddPair('EndDate',
            qry.fieldbyname('DateHeureSortie').asstring));
          qry.next;
        end;
      finally
        qry.free;
      end;
      Response.StatusCode := 200;
      Response.ContentType := 'application/json';
      Response.Content := jsa.ToJSON;
    finally
      jsa.free;
    end;
  except
    Response.StatusCode := 404;
    Response.Content := '';
  end;
end;

procedure TWebModule1.WebModule1TestCasContactEtablissementAction
  (Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  idetb: integer;
  qry: tfdquery;
  jsa: tjsonarray;
  Checksum: string;
  kpriv: string;
  // http://localhost:8080/etbcascontact (GET avec i=idetb)
begin
  // r�cup�ration et test de l'existence de l'ID d'�tablissement
  try
    idetb := Request.QueryFields.Values['i'].ToInteger;
  except
    idetb := -1;
  end;
  if not((idetb > 0) and (idetb = DBConnexion.ExecSQLScalar
    ('select IDEtablissement from etablissements where IDEtablissement=:id',
    [idetb]))) then
  begin
    Response.StatusCode := 400;
    Response.Content := 'unknown etb';
    exit;
  end;
  kpriv := DBConnexion.ExecSQLScalar
    ('select ClePrivee from etablissements where IDEtablissement=:id', [idetb]);
  // R�cup�ration et v�rification du checksum V
  try
    Checksum := Request.ContentFields.Values['v'];
  except
    Checksum := '';
  end;
  if not ChecksumVerif.check(Checksum, kpriv, idetb.tostring) then
  begin
    Response.StatusCode := 500;
    Response.Content := 'internal server error';
    exit;
  end;
  // traitement de la demande puisque tout est ok
  try
    jsa := tjsonarray.Create;
    try
      qry := tfdquery.Create(self);
      try
        qry.Connection := DBConnexion;
        qry.Open('select DateHeureEntree,DateHeureSortie from historiques where IDEtablissement=:id and CasContact=1 order by DateHeureEntree,DateHeureSortie',
          [idetb]);
        while not qry.Eof do
        begin
          jsa.Add(tjsonobject.Create.AddPair('StartDate',
            qry.fieldbyname('DateHeureEntree').asstring).AddPair('EndDate',
            qry.fieldbyname('DateHeureSortie').asstring));
          qry.next;
        end;
      finally
        qry.free;
      end;
      Response.StatusCode := 200;
      Response.ContentType := 'application/json';
      Response.Content := jsa.ToJSON;
    finally
      jsa.free;
    end;
  except
    Response.StatusCode := 404;
    Response.Content := '';
  end;
end;

initialization

MUTEXInscriptionEtablissementAction := tmutex.Create;
MUTEXInscriptionClientAction := tmutex.Create;

finalization

MUTEXInscriptionClientAction.free;
MUTEXInscriptionEtablissementAction.free;

end.
