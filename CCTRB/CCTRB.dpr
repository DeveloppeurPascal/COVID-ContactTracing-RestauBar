program CCTRB;

uses
  System.StartUpCopy,
  FMX.Forms,
  fPrincipale in 'fPrincipale.pas' {frmPrincipale},
  uAPI in '..\EtabCCTRB\uAPI.pas',
  uParam in '..\..\Librairies\uParam.pas',
  uConfig in 'uConfig.pas',
  UAPI_cli in 'UAPI_cli.pas',
  fLectureQRcode in 'fLectureQRcode.pas' {frmLectureQRcode};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipale, frmPrincipale);
  Application.CreateForm(TfrmLectureQRcode, frmLectureQRcode);
  Application.Run;
end.
