unit uCCTRBPrivateKey;

interface

/// <summary>
/// Fourni la cl� priv�e du projet (pour checksum sur cr�ations et autres)
/// </summary>
function getCCTRBPrivateKey: string;

implementation

function getCCTRBPrivateKey: string;
begin
  // d�but tests d'API KO
  // result := 'rien';
  // exit;
  // fin test

{$IFDEF DEBUG}
{$INCLUDE 'uCCTRBPrivateKey-debug.inc'}
{$ELSE}
{$INCLUDE '_PRIVE/uCCTRBPrivateKey-release.inc'}
{$ENDIF}
end;

end.
