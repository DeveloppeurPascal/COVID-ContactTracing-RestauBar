unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  System.Threading;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Button1.Enabled := false;
  ttask.run(
    procedure
    begin
      TParallel.for(1, 1000,
        procedure(i: integer)
        var
          server: thttpclient;
          reponse: ihttpresponse;
        begin
          server := thttpclient.Create;
          try
            reponse := server.Get('http://localhost:8080/types');
            tthread.synchronize(nil,
              procedure
              begin
                Memo1.Lines.Add(i.tostring + '-' + reponse.StatusCode.tostring +
                  '-' + reponse.ContentAsString(TEncoding.UTF8));
              end);
          finally
            server.FRee;
          end;
        end);
    end);
end;

end.
