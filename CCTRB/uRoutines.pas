unit uRoutines;

interface

function isQRCodeConforme(QRCode: string): Boolean;

implementation

uses
  system.sysutils;

function isQRCodeConforme(QRCode: string): Boolean;
begin
  Result := (QRCode.Length > 0) and (QRCode.StartsWith('https://cctrb.fr/#'));
end;

end.
