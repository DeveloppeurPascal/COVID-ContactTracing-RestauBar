unit uCCTRBPrivateKey;

interface

/// <summary>
/// Fourni la clé privée du projet (pour checksum sur créations et autres)
/// </summary>
function getCCTRBPrivateKey: string;

implementation

function getCCTRBPrivateKey: string;
begin
{$IFDEF DEBUG}
{$INCLUDE 'uCCTRBPrivateKey-debug.inc'}
{$ELSE}
{$INCLUDE '_PRIVE/uCCTRBPrivateKey-release.inc'}
{$ENDIF}
end;

end.
