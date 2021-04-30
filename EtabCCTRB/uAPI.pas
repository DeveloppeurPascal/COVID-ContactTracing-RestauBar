unit uAPI;

interface

/// <summary>
/// Retourne l'adresse du serveur selon la configuration de l'appareil et le système d'exploitation
/// </summary>
function getAPIURL: string;

implementation

function getAPIURL: string;
begin
{$IFDEF DEBUG}
{$IF Defined(CCTRB_WEBBROCKER)}
{$IFDEF MSWINDOWS}
  result := 'http://localhost:8080/';
{$ELSE}
  result := 'http://192.168.1.169:8080/';
{$ENDIF}
{$ELSEIF Defined(CCTRB_WAMP)}
{$IFDEF MSWINDOWS}
  result := 'http://localhost/cctrb/';
{$ELSE}
  result := 'http://192.168.1.169/cctrb/';
{$ENDIF}
{$ELSE}
{$MESSAGE FATAL 'Choisir un serveur d''API.'}
{$ENDIF}
{$ELSE}
  result := 'https://api.cctrb.fr/';
{$ENDIF}
end;

end.
