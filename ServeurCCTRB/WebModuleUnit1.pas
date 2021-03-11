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
  private
    FDBConnexion: TFDConnection;
    function GetFDBConnexion: TFDConnection;
    { Déclarations privées }
  protected
    property DBConnexion: TFDConnection read GetFDBConnexion;
  public
    { Déclarations publiques }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}

uses
  System.json;

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
      DBParams.Values['Database'] := 'cctrb';
      DBParams.Values['User_Name'] := 'root';
      // TODO : change the DB user (never use 'root')
      DBParams.Values['Password'] := ''; // TODO : change the DB password
      DBParams.Values['DriverID'] := 'MySQL';
      FDManager.AddConnectionDef(_ConnectionDefName, 'MySQL', DBParams);
    end;
    FDBConnexion := TFDConnection.Create(self);
    FDBConnexion.LoginPrompt := false;
    FDBConnexion.ConnectionDefName := _ConnectionDefName;
    FDBConnexion.Open;
  end;
  result := FDBConnexion;
end;

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content := '<html>' +
    '<head><title>Application Serveur Web</title></head>' +
    '<body>Application Serveur Web</body>' + '</html>';
end;

procedure TWebModule1.WebModule1ListeTypesEtablissementsAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  qry: tfdquery;
  jsa: tjsonarray;
begin
  // http://localhost:8080/types
  try
    qry := tfdquery.Create(self);
    try
      qry.Connection := DBConnexion;
      qry.Open('select * from typesetablissements');
      jsa := tjsonarray.Create;
      try
        while not qry.Eof do
        begin
          jsa.Add(TJSONObject.Create.AddPair('id',
            tjsonnumber.Create(qry.fieldbyname('IDTypeEtablissement').AsInteger)
            ).AddPair('label', qry.fieldbyname('IDTypeEtablissement')
            .asstring));
          qry.next;
        end;
        Response.StatusCode := 200;
        Response.ContentType := 'application/json';
        Response.Content := jsa.ToJSON;
      finally
        jsa.Free;
      end;
    finally
      qry.Free;
    end;
  except
    Response.StatusCode := 404;
    Response.Content := '';
  end;
end;

end.
