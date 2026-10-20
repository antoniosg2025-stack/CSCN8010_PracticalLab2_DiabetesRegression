# Creates the project virtual environment, installs the pinned dependencies,
# verifies them and executes the notebook end to end.
# Usage (from the project folder):  powershell -ExecutionPolicy Bypass -File .\setup_and_run.ps1

$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

function Fail($msg) { Write-Host "ERROR: $msg" -ForegroundColor Red; exit 1 }

# 1. Python 3.11 or newer
$py = Get-Command python -ErrorAction SilentlyContinue
if (-not $py) { Fail "Python was not found. Install Python 3.11+ and add it to PATH." }
$ver = & python -c "import sys; print(f'{sys.version_info[0]}.{sys.version_info[1]}')"
if ([version]$ver -lt [version]"3.11") { Fail "Python $ver found; Python 3.11 or newer is required." }
Write-Host "Python $ver found."

# 2. Virtual environment
if (-not (Test-Path ".venv\Scripts\python.exe")) {
    Write-Host "Creating .venv ..."
    & python -m venv .venv
    if ($LASTEXITCODE -ne 0) { Fail "Could not create the virtual environment." }
}
$venvPy = ".\.venv\Scripts\python.exe"

# 3. Install dependencies
& $venvPy -m pip install --upgrade pip
if ($LASTEXITCODE -ne 0) { Fail "pip upgrade failed." }
& $venvPy -m pip install -r requirements.txt
if ($LASTEXITCODE -ne 0) { Fail "Dependency installation failed." }

# 4. Verify every pinned package and version, then compatibility
& $venvPy -c @"
import sys
from importlib.metadata import version, PackageNotFoundError
bad = []
for line in open('requirements.txt'):
    line = line.strip()
    if not line or line.startswith('#'):
        continue
    name, wanted = line.split('==')
    try:
        got = version(name)
    except PackageNotFoundError:
        got = None
    status = 'OK' if got == wanted else 'MISMATCH'
    print(f'{name:15s} required {wanted:10s} installed {got}  {status}')
    if got != wanted:
        bad.append(name)
sys.exit(1 if bad else 0)
"@
if ($LASTEXITCODE -ne 0) { Fail "One or more packages are missing or have the wrong version." }
& $venvPy -m pip check
if ($LASTEXITCODE -ne 0) { Fail "pip check reported incompatible packages." }

# 5. Register the environment as a Jupyter kernel for VS Code
& $venvPy -m ipykernel install --user --name cscn8010-lab2 --display-name "Python (CSCN8010 Lab 2)"
if ($LASTEXITCODE -ne 0) { Fail "Kernel registration failed." }

# 6. Execute the notebook from a fresh kernel
Write-Host "Executing the notebook (about 1 minute) ..."
& $venvPy -m jupyter nbconvert --to notebook --execute --inplace CSCN8010_PracticalLab2_DiabetesRegression.ipynb
if ($LASTEXITCODE -ne 0) { Fail "Notebook execution failed." }

Write-Host "SUCCESS: environment ready and notebook executed without errors." -ForegroundColor Green
