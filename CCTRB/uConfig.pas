unit uConfig;

interface

type
  TConfig = class
  private
    class procedure SetID(const Value: integer); static;
    class function GetID: integer; static;
    class function GetPublicKey: string; static;
    class procedure SetPublicKey(const Value: string); static;
    class function GetPrivateKey: string; static;
    class procedure SetPrivateKey(const Value: string); static;
  public
    class property ID: integer read GetID write SetID;
    class property PublicKey: string read GetPublicKey write SetPublicKey;
    class property PrivateKey: string read GetPrivateKey write SetPrivateKey;
  end;

implementation

uses
  Olf.RTL.Params;

const
  CKEYID = 'CliID';
  CKEYPublic = 'PublicKey';
  CKEYPrivate = 'PrivateKey';

  { TConfig }

class function TConfig.GetID: integer;
begin
  result := tParams.getValue(CKEYID, -1);
end;

class function TConfig.GetPrivateKey: string;
begin
  result := tParams.getValue(CKEYPrivate, '');
end;

class function TConfig.GetPublicKey: string;
begin
  result := tParams.getValue(CKEYPublic, '');
end;

class procedure TConfig.SetID(const Value: integer);
begin
  tParams.setValue(CKEYID, Value);
end;

class procedure TConfig.SetPrivateKey(const Value: string);
begin
  tParams.setValue(CKEYPrivate, Value);
end;

class procedure TConfig.SetPublicKey(const Value: string);
begin
  tParams.setValue(CKEYPublic, Value);
end;

// TODO : modifier le chemin de stockage des paramètres sur Android/iOS pour que ça dépende de l'arborescence de l'application et soit viré avec elle
end.
