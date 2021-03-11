object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 0
    Top = 0
    Width = 635
    Height = 49
    Align = alTop
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 0
    Top = 49
    Width = 635
    Height = 250
    Align = alClient
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
    ExplicitLeft = 232
    ExplicitTop = 128
    ExplicitWidth = 185
    ExplicitHeight = 89
  end
end
