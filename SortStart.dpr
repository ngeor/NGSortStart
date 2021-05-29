
{
NGSortStart
Version 0.0.1 (16/6/1999)
Author: Nick Georgiou
}

program SortStart;

uses Windows;

{$DEFINE LANG_ENGLISH}

{$IFDEF LANG_GREEK}
{$R Greek.Res}
const
  sConfirmSort       = 'NGSortStart'#13#10 +
                       'Έκδοση 0.0.1 (16/6/1999)'#13#10 +
                       'Ένα πρόγραμμα του Νίκου Γεωργίου'#13#10 +
                       'Επισκεφθείτε με στο http://members.xoom.com/nickgeorgiou'#13#10 +
                       'E-mail: el98048@central.ntua.gr'#13#10#13#10 +
                       'Θέλετε να ταξινομήσετε το μενού Έναρξη;';
  sQuestion          = 'Ερώτηση';
  sErrRegistryRead   = 'Απέτυχε η ανάγνωση ενός κλειδιού του μητρώου συστήματος.';
  sErrRegistryDelete = 'Απέτυχε η διαγραφή ενός κλειδιού του μητρώου συστήματος.';
  sReboot            = 'Το μενού Έναρξη ταξινομήθηκε με επιτυχία! Για να δείτε την αλλαγή πρέπει να επανεκκινήσετε τον υπολογιστή σας. Θέλετε να επανεκιννήσετε τον υπολογιστή σας τώρα;';
{$ELSE}
{$IFDEF LANG_ENGLISH}
{$R English.Res}
const
  sConfirmSort       = 'NGSortStart'#13#10 +
                       'Version 0.0.1 (16/6/1999)'#13#10 +
                       'A program by Nick Georgiou'#13#10 +
                       'Visit me at http://members.xoom.com/nickgeorgiou'#13#10 +
                       'E-mail: el98048@central.ntua.gr'#13#10#13#10 +
                       'Do you want to sort the Start Menu?';
  sQuestion          = 'Question';
  sErrRegistryRead   = 'NGSortStart couldn''t read a system registry key.';
  sErrRegistryDelete = 'NGSortStart couldn''t delete a system registry key.';
  sReboot            = 'NGSortStart has successfully sorted the Start Menu! For this change to take efffect you must restart your computer. Do you want to restart your computer now?';
{$ENDIF}
{$ENDIF}

var
  h: HKEY;
  success: Boolean;
begin
  // get the user's OK
  if MessageBox(0, sConfirmSort, sQuestion, MB_ICONQUESTION or MB_YESNO) = ID_YES then begin
    // open the proper registry key
    success:= RegOpenKeyEx(HKEY_CURRENT_USER,
      'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer',
      0, KEY_ALL_ACCESS, h) = ERROR_SUCCESS;
    // did that work?
    if not success then begin
      MessageBox(0, sErrRegistryRead, nil, MB_ICONERROR);
      Exit;
    end;
    // delete the subkey MenuOrder and there you go!!!
    success:=RegDeleteKey(h, 'MenuOrder') = ERROR_SUCCESS;
    // God, I hope that worked...
    if not success then begin
      MessageBox(0, sErrRegistryDelete, nil, MB_ICONERROR);
      // key probably open so we just close it here
      RegCloseKey(h);
      Exit;
    end;
    // Great, close the registry key!
    RegCloseKey(h);
    // Tell him that he MUST reboot
    if MessageBox(0, sReboot, sQuestion, MB_ICONQUESTION or MB_YESNO) = ID_YES then
      ExitWindowsEx(EWX_REBOOT, 0);
  end;
end.
