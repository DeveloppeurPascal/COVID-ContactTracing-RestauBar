unit uTools;

interface

/// <summary>Ressort la date du jour en AAAAMMJJ
/// </summary>
function DateToString8: string; overload;
/// <summary>Ressort la date passée en AAAAMMJJ
/// </summary>
function DateToString8(Const ADate: TDateTime): string; overload;
/// <summary>Transforme une date AAAAMMJJ dans son format d'affichage JJ/MM/AAAA
/// </summary>
function Date8ToString(Const Date8AAfficher: string): string;
/// <summary>Ressort l'heure en cours en HHMMSS
/// </summary>
function TimeToString6: string; overload;
/// <summary>Ressort l'heure passée en HHMMSS
/// </summary>
function TimeToString6(Const ATime: TDateTime): string; overload;
/// <summary>Transforme une heure HHMMSS dans son format d'affichage HH:MM:SS
/// </summary>
function Time6ToString(Const Time6AAfficher: string): string;
/// <summary>Transforme la date et heure du moment en AAAAMMJJHHMMSS
/// Ce format est utilisé dans le stockage d'infos de création et de modification dans la base de données et permettre des tris chronologiques sur l'ordre alphabétique.
/// </summary>
function DateTimeToString14: string; overload;
/// <summary>Transforme la date et heure passée en AAAAMMJJHHMMSS
/// Ce format est utilisé dans le stockage d'infos de création et de modification dans la base de données et permettre des tris chronologiques sur l'ordre alphabétique.
/// </summary>
function DateTimeToString14(Const ADateTime: TDateTime): string; overload;
/// <summary>Transforme une chaine de caractères AAAAMMJJHHMMSS en TDateTime
/// </summary>
function String14ToDateTime(const AAAAMMJJHHNNSS: string): TDateTime;

/// <summary>
/// Génère un identifiant pour la clé publique et la clé privée
/// </summary>
function getKeyPrivPub(Taille: integer = 64): string;

implementation

uses System.SysUtils, System.DateUtils;

function DateToString8: string;
begin
  Result := DateToString8(Now);
end;

function DateToString8(Const ADate: TDateTime): string;
begin
  Result := FormatDateTime('yyyymmdd', ADate);
end;

function Date8ToString(Const Date8AAfficher: string): string;
begin
  // TODO : gérer les formats de date non européens de l'ouest
  Result := Date8AAfficher.Substring(6, 2) + FormatSettings.DateSeparator +
    Date8AAfficher.Substring(4, 2) + FormatSettings.DateSeparator +
    Date8AAfficher.Substring(0, 4);
end;

function TimeToString6: string;
begin
  Result := TimeToString6(Now);
end;

function TimeToString6(Const ATime: TDateTime): string;
begin
  Result := FormatDateTime('hhnnss', ATime);
end;

function Time6ToString(Const Time6AAfficher: string): string;
begin
  Result := Time6AAfficher.Substring(0, 2) + FormatSettings.TimeSeparator +
    Time6AAfficher.Substring(2, 2) + FormatSettings.TimeSeparator +
    Time6AAfficher.Substring(4, 2);
end;

function DateTimeToString14: string;
begin
  Result := DateTimeToString14(Now);
end;

function DateTimeToString14(Const ADateTime: TDateTime): string;
begin
  Result := DateToString8(ADateTime) + TimeToString6(ADateTime);
end;

function String14ToDateTime(const AAAAMMJJHHNNSS: string): TDateTime;
begin
  Result := EncodeDate(AAAAMMJJHHNNSS.Substring(0, 4).ToInteger,
    AAAAMMJJHHNNSS.Substring(4, 2).ToInteger, AAAAMMJJHHNNSS.Substring(6, 2)
    .ToInteger) + EncodeTime(AAAAMMJJHHNNSS.Substring(8, 2).ToInteger,
    AAAAMMJJHHNNSS.Substring(10, 2).ToInteger, AAAAMMJJHHNNSS.Substring(12, 2)
    .ToInteger, 0);
end;

function getKeyPrivPub(Taille: integer): string;

  function CaractereAleatoire: char;
  var
    nb: integer;
  begin
    nb := random(10 + 26 + 26);
    case nb of
      0 .. 9: // chiffres
        Result := chr(ord('0') + nb);
      10 .. (10 + 26 - 1): // lettres minuscules
        Result := chr(ord('a') + nb - 10);
      (10 + 26) .. (10 + 26 + 26 - 1): // lettres majuscules
        Result := chr(ord('A') + nb - 10 - 26);
    else
      Result := '0';
    end;
  end;

var
  i: integer;
begin
  Result := '';
  for i := 1 to Taille do
    Result := Result + CaractereAleatoire;
end;

end.
