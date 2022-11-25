program CCTRB;

uses
  System.StartUpCopy,
  FMX.Forms,
  fPrincipale in 'fPrincipale.pas' {frmPrincipale},
  uAPI in '..\EtabCCTRB\uAPI.pas',
  uConfig in 'uConfig.pas',
  UAPI_cli in 'UAPI_cli.pas',
  fLectureQRcode in 'fLectureQRcode.pas' {frmLectureQRcode},
  fAPropos in 'fAPropos.pas' {frmAPropos},
  fTestCasContact in 'fTestCasContact.pas' {frmTestCasContact},
  uRoutines in 'uRoutines.pas',
  uCCTRBPrivateKey in '..\uCCTRBPrivateKey.pas',
  Olf.RTL.Params in '..\lib-externes\librairies\Olf.RTL.Params.pas',
  uChecksumVerif in '..\lib-externes\librairies\uChecksumVerif.pas',
  u_md5 in '..\lib-externes\librairies\u_md5.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipale, frmPrincipale);
  Application.Run;
end.
