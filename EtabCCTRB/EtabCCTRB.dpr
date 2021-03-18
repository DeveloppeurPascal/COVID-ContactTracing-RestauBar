program EtabCCTRB;

uses
  System.StartUpCopy,
  FMX.Forms,
  fPrincipale in 'fPrincipale.pas' {frmPrincipale};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipale, frmPrincipale);
  Application.Run;
end.
