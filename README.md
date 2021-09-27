# Start-MonitorRobot
Start it on your own computer to monitor a remote UiPath robot using RDP Shadowing. When a active remote session exists it automatically connects to it and shows the robots screen.
```
Start-RobotMonitor Computer1
```

# Update-UiPathREADME
Use it to document your UiPath Library.
Run the script in a UiPath Library folder to generate a new [README.md](https://github.com/JesperJ/UiPath-Open-E/blob/main/README.md)

```
Update-UiPathKKReadme C:\UiPath\UiPath-Library1
```

# How to use
This is a powershell module, go to your PSModulePath and run
```
git clone https://github.com/JesperJ/UiPath-PowershellScripts.git
```

Find PSModulePath
```
$env:PSModulePath -split ";"
```