unit uConfig;

interface

type
  TConfig = class
  private
    procedure SetID(const Value: integer);
    function GetID: integer;
  public
    property ID: integer read GetID write SetID;
  end;

implementation

uses
  uparam;

const
  CKEYID = 'CliID';

  { TConfig }

function TConfig.GetID: integer;
begin
  result := tParams.getValue(CKEYID, -1);
end;

procedure TConfig.SetID(const Value: integer);
begin
  tParams.setValue(CKEYID, Value);

end;

end.
