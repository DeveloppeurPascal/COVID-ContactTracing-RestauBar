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
  fVisualiser in 'fVisualiser.pas' {frmVisualiser};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmPrincipale, frmPrincipale);
  Application.Run;
end.
