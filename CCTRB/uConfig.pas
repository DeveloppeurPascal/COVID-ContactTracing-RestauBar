unit uConfig;

interface

type
  TConfig = class
  private
    class procedure SetID(const Value: integer); static;
    class function GetID: integer; static;
  public
    class property ID: integer read GetID write SetID;
  end;

implementation

uses
  uparam;

const
  CKEYID = 'CliID';

  { TConfig }

class function TConfig.GetID: integer;
begin
  result := tParams.getValue(CKEYID, -1);
end;

class procedure TConfig.SetID(const Value: integer);
begin
  tParams.setValue(CKEYID, Value);
  tParams.save;
end;

end.
