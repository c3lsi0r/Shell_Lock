
Linux Shell Script  to lock the Terminal when leaving the Computer Workstation
 
  Locks the terminal with a password - default password: "0000"
- The password is at the top of the source code. (Attention #chmod 700 Shell_Lock.sh)
  And it can be changed there too. The password itself is md5sum encrypted,
  You should pay attention to this so that it is not in plain text.
  Change password via the console. example = $echo PASSWORD| md5sum
  Password can also be changed with, ./Shell_Lock -p.
- For every incorrect entry, the time to pass doubles again
  to be able to give one.
- With ESpeak voice output -
- Signals ctrl+c and ctrl+z are intercepted -
- Even if you cancel with ctrl +c, the time doubles -
- With time and sec display. improved v1.7.2
- New version 1.8.0 with kill switch if password forgotten
  just run the kill switch. Default: "Killer"
  (can be a combination of keys or a second password etc.)
- Unauthorized access, as well as authorized access, are processed in one
  Hidden file logged/saved.
- The process id is also saved in a hidden file.


Usage (first run):

   shell_lock.sh --check = checks whether all existing programs are present.
   shell_lock.sh --install = installs all non-existent programs.
   shell_lock.sh --pass = create new password.
   shell_lock,sh --help = show help
 

