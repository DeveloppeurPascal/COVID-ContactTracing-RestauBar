unit uAPI;

interface

/// <summary>
/// Retourne l'adresse du serveur selon la configuration de l'appareil et le système d'exploitation
/// </summary>
function getAPIURL(endpoint:string): string;

implementation

function getAPIURL(endpoint:string): string;
begin
{$IFDEF DEBUG}
{$IF Defined(CCTRB_WEBBROCKER)}
{$IFDEF MSWINDOWS}
  result := 'http://localhost:8080/'+endpoint;
{$ELSE}
  result := 'http://192.168.1.169:8080/'+endpoint;
{$ENDIF}
{$ELSEIF Defined(CCTRB_WAMP)}
{$IFDEF MSWINDOWS}
  result := 'http://localhost/cctrb/'+endpoint+'/';
{$ELSE}
  result := 'http://192.168.1.169/cctrb/'+endpoint+'/';
{$ENDIF}
{$ELSE}
{$MESSAGE FATAL 'Choisir un serveur d''API.'}
{$ENDIF}
{$ELSE}
  result := 'https://api.cctrb.fr/'+endpoint+'/';
{$ENDIF}
end;

end.
