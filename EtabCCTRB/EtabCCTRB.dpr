program EtabCCTRB;

uses
  System.StartUpCopy,
  FMX.Forms,
  fPrincipale in 'fPrincipale.pas' {frmPrincipale},
  uAPI_etb in 'uAPI_etb.pas',
  uAPI_typesetb in 'uAPI_typesetb.pas',
  uAPI in 'uAPI.pas',
  uDM in 'uDM.pas' {dm: TDataModule},
  uParam in '..\..\Librairies\uParam.pas',
  uConfig in 'uConfig.pas',
  fVisualiser in 'fVisualiser.pas' {frmVisualiser},
  fModifier in 'fModifier.pas' {frmModifier},
  fTestCasContact in 'fTestCasContact.pas' {frmTestCasContact},
  fGenerationQRCode in 'fGenerationQRCode.pas' {frmGenerationQRCode},
  DelphiZXIngQRCode in '..\..\..\foxitsoftware\DelphiZXingQRCode\Source\DelphiZXIngQRCode.pas',
  uChecksumVerif in '..\..\Librairies\uChecksumVerif.pas',
  uCCTRBPrivateKey in '..\uCCTRBPrivateKey.pas',
  u_md5 in '..\..\Librairies\u_md5.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmPrincipale, frmPrincipale);
  Application.Run;
end.
