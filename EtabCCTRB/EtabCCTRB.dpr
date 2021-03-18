program EtabCCTRB;

uses
  System.StartUpCopy,
  FMX.Forms,
  fPrincipale in 'fPrincipale.pas' {frmPrincipale},
  uDM in 'uDM.pas' {dm: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmPrincipale, frmPrincipale);
  Application.Run;
end.
