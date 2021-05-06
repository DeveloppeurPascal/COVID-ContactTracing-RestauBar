unit fPrincipale;

interface

// TODO : traiter une file d'attente d'envois à faire au serveur en cas de déconnexion
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  FMX.Objects, FMX.Effects;

type
  TfrmPrincipale = class(TForm)
    VertScrollBox1: TVertScrollBox;
    FlowLayout1: TFlowLayout;
    btnEntrer: TButton;
    StyleBook1: TStyleBook;
    btnSortir: TButton;
    btnDeclarerPositivite: TButton;
    btnTestCasContact: TButton;
    btnInfosSurLeLogiciel: TButton;
    VerrouillageInterface: TRectangle;
    VerrouillageInterfaceAnimation: TAniIndicator;
    Label1: TLabel;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDeclarerPositiviteClick(Sender: TObject);
    procedure btnInfosSurLeLogicielClick(Sender: TObject);
    procedure btnTestCasContactClick(Sender: TObject);
    procedure btnEntrerClick(Sender: TObject);
    procedure btnSortirClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure InterfaceBloque(AvecAnimation: boolean = true);
    procedure InterfaceDebloque;
    procedure ReferenceLAppareil;
    procedure EnvoiDeclarationCOVIDPositif;
    procedure QRCodeEntreeLu(QRCode: string);
    procedure QRCodeSortieLu(QRCode: string);
  public
    { Déclarations publiques }
  end;

var
  frmPrincipale: TfrmPrincipale;

implementation

{$R *.fmx}

uses uConfig, UAPI_cli, FMX.DialogService, fAPropos, fLectureQRcode,
  fTestCasContact, uAPI, uRoutines, uParam;

procedure TfrmPrincipale.btnDeclarerPositiviteClick(Sender: TObject);
begin
  InterfaceBloque(false);
  try
    TDialogService.MessageDialog
      ('Confirmez-vous avoir fait un test COVID positif ?',
      tmsgdlgtype.mtConfirmation, [tmsgdlgbtn.mbYes, tmsgdlgbtn.mbno],
      tmsgdlgbtn.mbno, 0,
      procedure(const AResult: TModalResult)
      begin
        InterfaceDebloque;
        if AResult = mryes then
          EnvoiDeclarationCOVIDPositif;
      end);
  except
    InterfaceDebloque;
  end;
end;

procedure TfrmPrincipale.btnEntrerClick(Sender: TObject);
var
  frm: TfrmLectureQRcode;
begin
  frm := TfrmLectureQRcode.Create(Self);
  frm.onQRCodeLu := QRCodeEntreeLu;
{$IF Defined(IOS) or Defined(ANDROID)}
  frm.Show;
{$ELSE}
  frm.ShowModal;
{$ENDIF}
end;

procedure TfrmPrincipale.btnInfosSurLeLogicielClick(Sender: TObject);
var
  frm: TfrmAPropos;
begin
  frm := TfrmAPropos.Create(Self);
{$IF Defined(IOS) or Defined(ANDROID)}
  frm.Show;
{$ELSE}
  frm.ShowModal;
{$ENDIF}
end;

procedure TfrmPrincipale.btnSortirClick(Sender: TObject);
var
  frm: TfrmLectureQRcode;
begin
  frm := TfrmLectureQRcode.Create(Self);
  frm.onQRCodeLu := QRCodeSortieLu;
{$IF Defined(IOS) or Defined(ANDROID)}
  frm.Show;
{$ELSE}
  frm.ShowModal;
{$ENDIF}
end;

procedure TfrmPrincipale.btnTestCasContactClick(Sender: TObject);
var
  frm: TfrmTestCasContact;
begin
  frm := TfrmTestCasContact.Create(Self);
{$IF Defined(IOS) or Defined(ANDROID)}
  frm.Show;
{$ELSE}
  frm.ShowModal;
{$ENDIF} end;

procedure TfrmPrincipale.EnvoiDeclarationCOVIDPositif;
begin
  // TODO : enregistrer l'information en attendant d'être sûr de l'avoir transférée (ou pour historique local)
  InterfaceBloque;
  try
    API_CliDecCOVIDPlusASync(tconfig.id, tconfig.PrivateKey,
      procedure
      begin
        InterfaceDebloque;
        // TODO : enregistrer l'information comme quoi l'envoi a été fait (si pas d'erreur)
      end);
  except
    InterfaceDebloque;
    raise;
  end;
end;

procedure TfrmPrincipale.FormCreate(Sender: TObject);
begin
{$IFDEF DEBUG}
  Label1.visible := true;
{$ELSE}
  Label1.visible := false;
{$ENDIF}
  ReferenceLAppareil;
end;

procedure TfrmPrincipale.FormResize(Sender: TObject);
var
  i: integer;
  c: tcontrol;
begin
  FlowLayout1.height := 100;
  for i := 0 to FlowLayout1.ChildrenCount - 1 do
    if FlowLayout1.Children[i] is tcontrol then
    begin
      c := FlowLayout1.Children[i] as tcontrol;
      if FlowLayout1.height < c.height + c.Position.y then
        FlowLayout1.height := c.height + c.Position.y + 10;
    end;
end;

procedure TfrmPrincipale.InterfaceBloque(AvecAnimation: boolean);
begin
  VerrouillageInterface.visible := true;
  VerrouillageInterface.BringToFront;
  VerrouillageInterface.HitTest := true;
  VerrouillageInterfaceAnimation.visible := AvecAnimation;
  VerrouillageInterfaceAnimation.Enabled :=
    VerrouillageInterfaceAnimation.visible;
end;

procedure TfrmPrincipale.InterfaceDebloque;
begin
  VerrouillageInterfaceAnimation.Enabled := false;
  VerrouillageInterface.visible := false;
end;

procedure TfrmPrincipale.QRCodeEntreeLu(QRCode: string);
var
  IDEtb: integer;
begin
  if isQRCodeConforme(QRCode) then
    IDEtb := QRCode.Substring(QRCode.IndexOf('#') + 1).ToInteger
  else
    IDEtb := -1;

  if (IDEtb > 0) then
  begin
    // TODO : enregistrer l'information en attendant d'être sûr de l'avoir transférée (ou pour historique local)
    InterfaceBloque;
    try
      API_CliEntreDansEtablissementASync(tconfig.id, IDEtb, tconfig.PrivateKey,
        procedure
        begin
          InterfaceDebloque;
          // TODO : enregistrer l'information comme quoi l'envoi a été fait (si pas d'erreur)
        end);
    except
      InterfaceDebloque;
      raise;
    end;
  end
  else
    raise exception.Create('Etablissement inconnu.');
end;

procedure TfrmPrincipale.QRCodeSortieLu(QRCode: string);
var
  IDEtb: integer;
begin
  if isQRCodeConforme(QRCode) then
    IDEtb := QRCode.Substring(QRCode.IndexOf('#') + 1).ToInteger
  else
    IDEtb := -1;

  if (IDEtb > 0) then
  begin
    // TODO : enregistrer l'information en attendant d'être sûr de l'avoir transférée (ou pour historique local)
    InterfaceBloque;
    try
      API_CliSortDUnEtablissementASync(tconfig.id, IDEtb, tconfig.PrivateKey,
        procedure
        begin
          InterfaceDebloque;
          // TODO : enregistrer l'information comme quoi l'envoi a été fait (si pas d'erreur)
        end);
    except
      InterfaceDebloque;
      raise;
    end;
  end
  else
    raise exception.Create('Etablissement inconnu.');
end;

procedure TfrmPrincipale.ReferenceLAppareil;
begin
  if (tconfig.id < 1) then
  begin
    InterfaceBloque;
    try
      API_CliAddASync(
        procedure(id: integer; KPriv, KPub: string)
        begin
          if (id < 1) then
          begin
            showmessage('Probleme d''accès au serveur ' + getAPIURL('') +
              ', merci de retenter dans quelques secondes.');
            ReferenceLAppareil;
          end
          else
          begin
            tconfig.id := id;
            tconfig.PublicKey := KPub;
            tconfig.PrivateKey := KPriv;
            tparams.save;
            InterfaceDebloque;
            Label1.Text := tconfig.id.ToString;
          end;
        end);
    except
      InterfaceDebloque;
      raise;
    end;
  end
  else
    Label1.Text := tconfig.id.ToString;
end;

initialization

TDialogService.PreferredMode := TDialogService.TPreferredMode.Async;

{$IFDEF DEBUG}
ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
