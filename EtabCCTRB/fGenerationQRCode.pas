unit fGenerationQRCode;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts;

type
  TfrmGenerationQRCode = class(TForm)
    Image1: TImage;
    btnFermer: TButton;
    SaveDialog1: TSaveDialog;
    GridPanelLayout1: TGridPanelLayout;
    btnEnregistrer: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnFermerClick(Sender: TObject);
    procedure btnEnregistrerClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure GenereQRCode;
  public
    { Déclarations publiques }
  end;

var
  frmGenerationQRCode: TfrmGenerationQRCode;

implementation

{$R *.fmx}

uses DelphiZXIngQRCode, uConfig, System.ioutils;

{ TfrmGenerationQRCode }

procedure TfrmGenerationQRCode.btnEnregistrerClick(Sender: TObject);
begin
  SaveDialog1.InitialDir := tpath.GetDocumentsPath;
  SaveDialog1.FileName := '';
  if SaveDialog1.Execute then
    Image1.Bitmap.SaveToFile
      (tpath.ChangeExtension(SaveDialog1.FileName, '.jpg'));
end;

procedure TfrmGenerationQRCode.btnFermerClick(Sender: TObject);
begin
  close;
end;

procedure TfrmGenerationQRCode.FormCreate(Sender: TObject);
begin
  GenereQRCode;
end;

procedure TfrmGenerationQRCode.GenereQRCode;
var
  QRCode: TDelphiZXingQRCode;
  Row, Column: Integer;
  QRCodeBitmap: TBitmap;
begin
  QRCode := TDelphiZXingQRCode.Create;
  try
    QRCodeBitmap := TBitmap.Create;
    try
      QRCode.Data := 'https://cctrb.fr/#' + tconfig.id.tostring;
      QRCode.Encoding := TQRCodeEncoding.qrAuto;
      QRCode.QuietZone := 1;
      QRCodeBitmap.SetSize(QRCode.Rows * QRCodePixelParCase,
        QRCode.Columns * QRCodePixelParCase);
      QRCodeBitmap.Canvas.beginscene;
      try
        QRCodeBitmap.Canvas.fill.Kind := tbrushkind.Solid;
        for Row := 0 to QRCode.Rows - 1 do
        begin
          for Column := 0 to QRCode.Columns - 1 do
          begin
            if (QRCode.IsBlack[Row, Column]) then
              QRCodeBitmap.Canvas.fill.Color := talphacolors.black
            else
              QRCodeBitmap.Canvas.fill.Color := talphacolors.white;
            QRCodeBitmap.Canvas.FillRect(rectf(Column * QRCodePixelParCase,
              Row * QRCodePixelParCase, Column * QRCodePixelParCase +
              QRCodePixelParCase, Row * QRCodePixelParCase +
              QRCodePixelParCase), 1);
          end;
        end;
      finally
        QRCodeBitmap.Canvas.endscene;
      end;
      Image1.Bitmap.SetSize(QRCodeBitmap.width, QRCodeBitmap.height);
      Image1.Bitmap.CopyFromBitmap(QRCodeBitmap,
        rect(0, 0, QRCodeBitmap.width, QRCodeBitmap.height), 0, 0);
    finally
      QRCodeBitmap.free;
    end;
  finally
    QRCode.free;
  end;
end;

end.
