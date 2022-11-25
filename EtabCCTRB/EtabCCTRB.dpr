program EtabCCTRB;

uses
  System.StartUpCopy,
  FMX.Forms,
  fPrincipale in 'fPrincipale.pas' {frmPrincipale},
  uAPI_etb in 'uAPI_etb.pas',
  uAPI_typesetb in 'uAPI_typesetb.pas',
  uAPI in 'uAPI.pas',
  uDM in 'uDM.pas' {dm: TDataModule},
  uConfig in 'uConfig.pas',
  fVisualiser in 'fVisualiser.pas' {frmVisualiser},
  fModifier in 'fModifier.pas' {frmModifier},
  fTestCasContact in 'fTestCasContact.pas' {frmTestCasContact},
  fGenerationQRCode in 'fGenerationQRCode.pas' {frmGenerationQRCode},
  uCCTRBPrivateKey in '..\uCCTRBPrivateKey.pas',
  Olf.RTL.Params in '..\lib-externes\librairies\Olf.RTL.Params.pas',
  uChecksumVerif in '..\lib-externes\librairies\uChecksumVerif.pas',
  u_md5 in '..\lib-externes\librairies\u_md5.pas',
  DelphiZXIngQRCode in '..\lib-externes\DelphiZXingQRCode\Source\DelphiZXIngQRCode.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmPrincipale, frmPrincipale);
  Application.Run;
end.
