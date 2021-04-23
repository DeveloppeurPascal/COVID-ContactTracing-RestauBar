program CCTRB;

uses
  System.StartUpCopy,
  FMX.Forms,
  fPrincipale in 'fPrincipale.pas' {frmPrincipale},
  uAPI in '..\EtabCCTRB\uAPI.pas',
  uParam in '..\..\Librairies\uParam.pas',
  uConfig in 'uConfig.pas',
  UAPI_cli in 'UAPI_cli.pas',
  fLectureQRcode in 'fLectureQRcode.pas' {frmLectureQRcode},
  fAPropos in 'fAPropos.pas' {frmAPropos},
  fTestCasContact in 'fTestCasContact.pas' {frmTestCasContact},
  ZXing.ScanManager in '..\..\..\Spelt\ZXing.Delphi\Lib\Classes\ZXing.ScanManager.pas',
  ZXing.BarcodeFormat in '..\..\..\Spelt\ZXing.Delphi\Lib\Classes\Common\ZXing.BarcodeFormat.pas',
  ZXing.ReadResult in '..\..\..\Spelt\ZXing.Delphi\Lib\Classes\Common\ZXing.ReadResult.pas',
  uRoutines in 'uRoutines.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipale, frmPrincipale);
  Application.Run;
end.
