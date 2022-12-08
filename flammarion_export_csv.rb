module Flammarion
  class Engraving
    def get_export_save_path
      if Gem.win_platform?
        `powershell "Add-Type -AssemblyName System.windows.forms|Out-Null;$f=New-Object System.Windows.Forms.SaveFileDialog;$f.InitialDirectory='%cd%';$f.Filter='Comma Separated Values|*.csv';$f.showHelp=$true;$f.ShowDialog()|Out-Null;$f.FileName"`.strip
      else
        `zenity --file-selection --filename=Export.csv --save --confirm-overwrite`.strip
      end
    end
  end
end
