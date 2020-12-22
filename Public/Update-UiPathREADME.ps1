function Update-UiPathREADME {
    <#
    .SYNOPSIS
    Creates a markdown-file for UiPath Library
    
    .DESCRIPTION
    Creates a markdown-file compatible with github-markdown for a UiPath Library
    Excludes .xaml in folder Test*
    
    .PARAMETER ProjectFolder
    Folder for the UiPath Library. Uses current directory if nothing is provided
    
    .PARAMETER FileNameOutput
    If you want another filename then README.md use this parameter.
    
    .EXAMPLE
    Update-UiPathKKReadme
    Uses Current directory and output to README.md

    .EXAMPLE
    Update-UiPathKKReadme UiPath-Library1
    Uses Current directory and output to README.md

    .EXAMPLE
    Update-UiPathKKReadme C:\UiPath\UiPath-Library1 test.md
    Uses project directory C:\UiPath\UiPath-Library1 and outputs to test.md

    .NOTES
    NAME: Update-UiPathREADME
    AUTHOR: Jesper Jeansson, Kalmar Kommun
    LASTEDIT: den 16 oktober 2020 15:26:51
    KEYWORDS: UiPath, Markdown
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$ProjectFolder = ".",
        [string]$FileNameOutput = "README.md"
    )
    
    begin {
        Set-Location $ProjectFolder
        $projectfile = "project.json"
        
        # Create markdown-variable
        $Md = ""
        $Project = Get-Content -Raw -Path $projectfile | ConvertFrom-Json
                
        $Md += "# " + $Project.Name
        $Md += "`n" + $Project.description
        $Md += "`nVersion "+ $Project.projectVersion +" built with Studio version "+ $Project.studioVersion +" with expression language "+ $Project.expressionLanguage
        
        $Md += "`n# Dependencies"
        foreach ($dependencie in $project.dependencies.psobject.properties.name) {
            $Md += "`n* "+ $dependencie + " "+ $project.dependencies.$dependencie
        }
        
        $Md += "`n## Worflows"
        $WorkflowFiles = Get-ChildItem -Recurse "*.xaml" -Exclude "Test*"

        foreach ($WorkflowFile in $WorkflowFiles) {
            [xml]$XAML = Get-Content -Raw -Path $WorkflowFile
            
            # foreach workflow
            $Md += "`n### "+ $WorkflowFile.Name #$XAML.Activity.Sequence.DisplayName # replace with filename?
            
            $Md += "`n#### Description"
            $Md += "`n"+ $XAML.Activity.Sequence.'Annotation.AnnotationText'
            
            $Md += "`n#### Arguments"
            $Md += "`n| Argument | Description | Type |"
            $Md += "`n| --- | --- | --- |"
            foreach ($argument in $xaml.Activity.Members.Property) {
                $Md += "`n| "+ $argument.Name +" | "+ $argument.'Annotation.AnnotationText' +" | "+ $argument.'Type' +" |"
            }
            
        }
        
        # Create file
        $Md | Out-File $FileNameOutput
        
    }
}
