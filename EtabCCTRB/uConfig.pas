unit uConfig;

interface

const
  QRCodePixelParCase=20;

type
  TConfig = class
  private
    class function getID: integer; static;
    class function getIDTypeEtablissement: integer; static;
    class function getRaisonSociale: string; static;
    class procedure setID(const Value: integer); static;
    class procedure setIDTypeEtablissement(const Value: integer); static;
    class procedure setRaisonSociale(const Value: string); static;
  public
    class property id: integer read getID write setID;
    class property RaisonSociale: string read getRaisonSociale
      write setRaisonSociale;
    class property IDTypeEtablissement: integer read getIDTypeEtablissement
      write setIDTypeEtablissement;
  end;

implementation

uses uParam;

const
  CKEYID = 'EtbID';
  CKEYRaisonSociale = 'EtbRaisonSociale';
  CKEYIDTypeEtablissement = 'EtbIDTypeEtablissement';

  { TConfig }

class function TConfig.getID: integer;
begin
  result := tParams.getValue(CKEYID, -1);
end;

class function TConfig.getIDTypeEtablissement: integer;
begin
  result := tParams.getValue(CKEYIDTypeEtablissement, -1);
end;

class function TConfig.getRaisonSociale: string;
begin
  result := tParams.getValue(CKEYRaisonSociale, '');
end;

class procedure TConfig.setID(const Value: integer);
begin
  tParams.setValue(CKEYID, Value);
end;

class procedure TConfig.setIDTypeEtablissement(const Value: integer);
begin
  tParams.setValue(CKEYIDTypeEtablissement, Value);
end;

class procedure TConfig.setRaisonSociale(const Value: string);
begin
  tParams.setValue(CKEYRaisonSociale, Value);
end;

end.
