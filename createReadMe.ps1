function Set-Readme {
    [CmdletBinding()]
    param (
        [String]    
        $TargetPath
    )

    # private helper function with extra param for receiving the root
    function Set-ReadMe-Helper {
        [CmdletBinding(DefaultParameterSetName = "StringPaths")]
        param (
            [Parameter(Position = 0, Mandatory, ParameterSetName = "StringPaths")]
            [String]
            $TargetPath,
            [Parameter(Position = 1, Mandatory, ParameterSetName = "StringPaths")]
            [String]
            $Root
        )
        Push-Location $Root
        # base case 1: the target path is a file
        # provide a relative path to file in an img html tag
        if (Test-Path $TargetPath -PathType Leaf) {
            Write-Verbose -Message "TargetPath '$TargetPath' is a file"
            $relPath = Resolve-Path $TargetPath -Relative
            $baseName = (Get-Item -Path $TargetPath).BaseName
            $relPath = $relPath.Replace('\', '/')
            # Check for common file extensions
            if ($relPath -match '\.(png|jpg|jpeg|gif|bmp|svg)$') {
                return "[<img src='$relPath' width='30vw' alt='$baseName'/>]($relPath)"
            }
            elseif ($relPath -match '\.(md|markdown|mdown|mkdn|mkd|mdwn|mdtxt|mdtext|text|txt)$') {
                return "[📃]($relPath '$baseName')"
            }
            elseif ($relPath -match '\.(mp4|avi|mov|webm)$') {
                return "[🎬]($relPath '$baseName')"
            }
            else {
                return "[📎]($relPath '$baseName')"
            }
            # Other relevant emojis for files:
            # 📁 📂 📅 📇 📈 📉 📊 📋 📌 📍 📎 📏 📐 📑 📒 📓 📔 📕 📖 📗 📘 📙 📚 📛 📜 📝 📞 📟 📠 📡 📢 📣

        }
    

        # base case 2: the target path is a directory with no contents
        # provide the name of the directory as a heading
        if ((Test-Path $TargetPath -PathType Container) -and (Get-ChildItem $TargetPath).Count -eq 0) {
            Write-Verbose -Message "TargetPath '$TargetPath' is a directory with no contents"
            $dirName = $TargetPath.Split('\')[-1]
            # Calculate distance from root to target directory
            $distance = $TargetPath.Split('\').Count - $Root.Split('\').Count
            return "#" * $distance + " " + $dirName
        }

        # recursive case: the target path is a directory with contents
        # provide the name of the directory as a heading
        Write-Verbose -Message "TargetPath '$TargetPath' is a directory with contents"
        # recursively call the function on each of the contents
        $fileContents = Get-ChildItem $TargetPath -File
        $dirContents = Get-ChildItem $TargetPath -Directory
        
        $dirName = $TargetPath.Split('\')[-1]
        # Calculate distance from root to target directory
        $distance = $TargetPath.Split('\').Count - $Root.Split('\').Count
        $returnString = "`n" + "#" * $distance + " " + $dirName + "`n"
        foreach ($file in $fileContents) {
            $returnString += (Set-ReadMe-Helper $file.FullName $Root) + " "
        }
        foreach ($dir in $dirContents) {
            $returnString += (Set-ReadMe-Helper $dir.FullName $Root)
        }
        return $returnString + "`n"
    }
    Set-ReadMe-Helper (Resolve-Path $TargetPath) (Resolve-Path $TargetPath)

<<<<<<< HEAD
}
# To run the above scripts, try the following command in the root directory:
#   Import-Module -FullyQualifiedName .\createReadMe.ps1 -Function Set-ReadMe -Force; Set-Readme -TargetPath . | Out-File README.md -Force
=======
}
>>>>>>> c4aa72a432475741fed882403eb7b680d10bc14c
