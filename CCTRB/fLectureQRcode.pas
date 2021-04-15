unit fLectureQRcode;

interface // TODO : gérer la mise en tache de fond suite à appel téléphonique (AppEvent)

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Media, ZXing.ReadResult,
  ZXing.BarCodeFormat,
  ZXing.ScanManager, FMX.Platform;

type
  TonQRCodeLuEvent = procedure(QRCode: string) of object;

  TfrmLectureQRcode = class(TForm)
    ToolBar1: TToolBar;
    lblTitre: TLabel;
    btnBack: TButton;
    CameraComponent1: TCameraComponent;
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure CameraComponent1SampleBufferReady(Sender: TObject;
      const ATime: TMediaTime);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FonQRCodeLu: TonQRCodeLuEvent;
    procedure SetonQRCodeLu(const Value: TonQRCodeLuEvent);
    function AppEvent(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
  protected
    ScanEnCours: Boolean;
    ScanBitmap: TBitmap;
    ScanManager: TScanManager;
    function isQRCodeConforme(QRCode: string): Boolean;
  public
    { Déclarations publiques }
    property onQRCodeLu: TonQRCodeLuEvent read FonQRCodeLu write SetonQRCodeLu;
  end;

var
  frmLectureQRcode: TfrmLectureQRcode;

implementation

{$R *.fmx}

uses
  System.Permissions, System.Threading;

function TfrmLectureQRcode.AppEvent(AAppEvent: TApplicationEvent;
  AContext: TObject): Boolean;
begin
  case AAppEvent of
    TApplicationEvent.WillBecomeInactive, TApplicationEvent.EnteredBackground,
      TApplicationEvent.WillTerminate:
      CameraComponent1.Active := false;
  end;
end;

procedure TfrmLectureQRcode.btnBackClick(Sender: TObject);
begin
  close;
end;

procedure TfrmLectureQRcode.CameraComponent1SampleBufferReady(Sender: TObject;
  const ATime: TMediaTime);
begin
  CameraComponent1.SampleBufferToBitmap(Image1.Bitmap, true);
  if not ScanEnCours then
  begin
    ScanEnCours := true;
    try
      ScanBitmap.Assign(Image1.Bitmap);
      ttask.run(
        procedure
        var
          QRCode: string;
          SMResult: TReadResult;
        begin
          try
            SMResult := ScanManager.Scan(ScanBitmap);
            if (SMResult <> nil) then
              try
                QRCode := SMResult.text.Trim;
                tthread.Queue(nil,
                  procedure
                  begin
                    if isQRCodeConforme(QRCode) then
                    begin
                      if assigned(onQRCodeLu) then
                        onQRCodeLu(QRCode);
                      close;
                    end;
                  end);
              finally
                SMResult.Free;
              end;
          finally
            ScanEnCours := false;
          end;
        end);
    except
      ScanEnCours := false;
    end;
  end;
end;

procedure TfrmLectureQRcode.FormClose(Sender: TObject;
var Action: TCloseAction);
begin
  tthread.ForceQueue(nil,
    procedure
    begin
      Self.Free;
    end);
end;

procedure TfrmLectureQRcode.FormCreate(Sender: TObject);
var
  AppEventSvc: IFMXApplicationEventService;
begin
  if TPlatformServices.Current.SupportsPlatformService
    (IFMXApplicationEventService, IInterface(AppEventSvc)) then
  begin
    AppEventSvc.SetApplicationEventHandler(AppEvent);
  end; // TODO : tester comportement en perte de focus (y compris lorsque la fiche est fermée)

  ScanEnCours := false;
  ScanBitmap := TBitmap.Create;
  ScanManager := TScanManager.Create(TBarcodeFormat.QR_CODE, nil);
end;

procedure TfrmLectureQRcode.FormDestroy(Sender: TObject);
begin
  ScanManager.Free;
  ScanBitmap.Free;
end;

procedure TfrmLectureQRcode.FormHide(Sender: TObject);
begin
  CameraComponent1.Active := false;
end;

procedure TfrmLectureQRcode.FormShow(Sender: TObject);
begin
{$IFDEF ANDROID}
  PermissionsService.RequestPermissions(['android.permission.CAMERA'],
    procedure(const APermissions: TArray<string>;
      const AGrantResults: TArray<TPermissionStatus>)
    begin
      if (Length(AGrantResults) = 1) and
        (AGrantResults[0] = TPermissionStatus.Granted) then
        CameraComponent1.Active := true
      else
      begin
        showmessage('Caméra nécessaire');
        close;
      end;
    end (* ,
    procedure(const APermissions: TArray<string>;
    const APostRationaleProc: TProc)
    begin
    end *) );
{$ELSE}
  CameraComponent1.Active := true;
{$ENDIF}
end;

function TfrmLectureQRcode.isQRCodeConforme(QRCode: string): Boolean;
begin
  Result := (QRCode.Length > 0) and (QRCode.StartsWith('https://cctrb.fr/#'));
end;

procedure TfrmLectureQRcode.SetonQRCodeLu(const Value: TonQRCodeLuEvent);
begin
  FonQRCodeLu := Value;
end;

end.
