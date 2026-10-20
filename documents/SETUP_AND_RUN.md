# Setup and Run – Practical Lab 2

## Prerequisites
- Windows 10/11 with PowerShell, **Python 3.11 or newer** on PATH, Git.
- VS Code with the **Python** and **Jupyter** extensions (only to open the notebook interactively).
- Internet access for `pip install`. The dataset ships with scikit-learn; nothing else is downloaded.

## 1. Clone

```powershell
git clone https://github.com/antoniosg2025-stack/CSCN8010_PracticalLab2_DiabetesRegression.git
cd CSCN8010_PracticalLab2_DiabetesRegression
```

## 2. Set up and run (one step)

Double-click `setup_and_run.bat`, or run:

```powershell
powershell -ExecutionPolicy Bypass -File .\setup_and_run.ps1
```

The script stops with a clear `ERROR:` message if any step fails. It:
1. checks that Python 3.11+ is available;
2. creates the project virtual environment `.venv`;
3. installs the pinned packages from `requirements.txt`;
4. prints each package with its required and installed version, fails on any mismatch, then runs `pip check`;
5. registers the Jupyter kernel **"Python (CSCN8010 Lab 2)"**;
6. executes the whole notebook from a fresh kernel.

**Success:** the last line is `SUCCESS: environment ready and notebook executed without errors.`

### Manual alternative

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe -m pip check
.\.venv\Scripts\python.exe -m jupyter nbconvert --to notebook --execute --inplace CSCN8010_PracticalLab2_DiabetesRegression.ipynb
```

## 3. Open in VS Code
Open the folder, open `CSCN8010_PracticalLab2_DiabetesRegression.ipynb`, click **Select Kernel → Python (CSCN8010 Lab 2)** (or the `.venv` interpreter), then **Restart → Run All**.

## Expected results
| Item | Expected value |
|---|---|
| Part 2 selected model | Degree 1, `progression = -130.87 + 10.77 × BMI` |
| Part 2 test metrics | R² ≈ 0.20, MAE ≈ 54.93, MAPE ≈ 48.75 % |
| Part 3 selected regression model | kNN k=15, test R² ≈ 0.41, MAE ≈ 46.28, MAPE ≈ 42.29 % |
| Logistic regression (C=1.0), test | accuracy ≈ 0.75, recall ≈ 0.73, ROC-AUC ≈ 0.82 |

## Project structure
```text
.
├── CSCN8010_PracticalLab2_DiabetesRegression.ipynb   # Full report: code, results, answers
├── images/                                          # Figures exported from the executed notebook
├── documents/SETUP_AND_RUN.md                       # This file
├── requirements.txt                                 # Pinned dependencies
├── setup_and_run.ps1 / setup_and_run.bat            # Setup + verification + execution
├── .gitignore                                       # Excludes .venv, caches and secrets
└── README.md
```

`.venv` is not committed (it is machine-specific); the script creates it.

## Troubleshooting
- *"running scripts is disabled on this system"* → use the `.bat` or the exact command above (the bypass applies to this run only; no system setting changes).
- *Kernel not listed in VS Code* → choose the interpreter `.venv\Scripts\python.exe`, then reload the VS Code window.
