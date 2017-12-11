$path = <# "path to files" #>
$files =  Get-ChildItem $path | Sort-Object -Property length
$counter = 0
$substart = 1
$n = 1 # width of dup. file search
foreach ($file in $files){
	$file.name
	foreach($subfile in $files[$substart..($substart+$n)]){
	"	"+$subfile.name
		if (((Get-FileHash $path\$file).hash) -ne ((Get-FileHash -Path $path\$subfile).hash)) { #diff hash values
			continue
		} else { #same hash values
			$counter = $counter + 1
			### Send to RecycleBin
			$shell = new-object -comobject "Shell.Application"
			$item = $shell.Namespace(0).ParseName($path+"\"+$file.name)
			$item.InvokeVerb("delete")
			"	match"
			break
		}
	}
	$substart = $substart + 1
}

$counter
