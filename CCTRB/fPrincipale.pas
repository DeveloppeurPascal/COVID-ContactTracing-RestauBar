unit fPrincipale;

interface

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
    procedure btnEntrerClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmPrincipale: TfrmPrincipale;

implementation

{$R *.fmx}

procedure TfrmPrincipale.btnEntrerClick(Sender: TObject);
begin
  showmessage('test');
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

end.
