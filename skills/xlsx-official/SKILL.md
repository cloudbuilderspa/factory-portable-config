---
name: xlsx-official
description: "Comprehensive spreadsheet creation, editing, and analysis with support for formulas, formatting, data analysis, and visualization. When Claude needs to work with spreadsheets (.xlsx, .xlsm, .csv), use this skill."
user-invocable: true
disable-model-invocation: false
---

# XLSX Skill - Excel Creation, Editing, and Analysis

## Overview

This skill enables working with Excel spreadsheets (.xlsx, .xlsm, .csv) using Python libraries like **pandas** and **openpyxl**.

## When to Use

- Creating new Excel files with data
- Editing existing spreadsheets
- Analyzing spreadsheet data
- Adding formulas and formatting
- Converting between formats

## Quick Start

### Data Analysis with Pandas

```python
import pandas as pd

# Read Excel
df = pd.read_excel('file.xlsx')
all_sheets = pd.read_excel('file.xlsx', sheet_name=None)

# Analyze
df.head()      # Preview data
df.info()      # Column info
df.describe()  # Statistics

# Write Excel
df.to_excel('output.xlsx', index=False)
```

### Creating Excel Files with openpyxl

```python
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment

wb = Workbook()
sheet = wb.active

# Add data
sheet['A1'] = 'Value'
sheet['B1'] = 100

# Add formula (use formulas, NOT hardcoded values!)
sheet['B2'] = '=SUM(B1:B10)'
sheet['B3'] = '=AVERAGE(A1:A10)'

# Formatting
sheet['A1'].font = Font(bold=True, color='FF0000')
sheet['A1'].fill = PatternFill('solid', start_color='FFFF00')
sheet.column_dimensions['A'].width = 20

wb.save('output.xlsx')
```

### Editing Existing Files

```python
from openpyxl import load_workbook

wb = load_workbook('existing.xlsx')
sheet = wb.active

# Modify cells
sheet['A1'] = 'New Value'

# Add formula
sheet['C10'] = '=SUM(A1:A9)'

# Work with multiple sheets
for name in wb.sheetnames:
    sheet = wb[name]

wb.save('modified.xlsx')
```

## Math Operations in Excel

### Use Excel Formulas (NOT Python calculations)

| Operation | Excel Formula |
|-----------|---------------|
| Sum | `=SUM(A1:A10)` |
| Average | `=AVERAGE(A1:A10)` |
| Count | `=COUNT(A1:A10)` |
| Max | `=MAX(A1:A10)` |
| Min | `=MIN(A1:A10)` |
| Addition | `=A1+B1` |
| Subtraction | `=A1-B1` |
| Multiplication | `=A1*B1` |
| Division | `=A1/B1` |
| Percentage | `=A1/B1*100` |
| Power | `=POWER(A1,2)` or `=A1^2` |
| Square root | `=SQRT(A1)` |

### Example: Basic Math Operations

```python
from openpyxl import Workbook

wb = Workbook()
ws = wb.active
ws.title = "Math Operations"

# Headers
ws['A1'] = 'Value 1'
ws['B1'] = 'Value 2'
ws['C1'] = 'Sum'
ws['D1'] = 'Difference'
ws['E1'] = 'Product'
ws['F1'] = 'Quotient'

# Data
ws['A2'] = 10
ws['B2'] = 5

# Formulas (NOT hardcoded results!)
ws['C2'] = '=A2+B2'   # Sum: 15
ws['D2'] = '=A2-B2'   # Difference: 5
ws['E2'] = '=A2*B2'   # Product: 50
ws['F2'] = '=A2/B2'   # Quotient: 2

wb.save('math_operations.xlsx')
```

## Color Coding Standards

| Color | Use |
|-------|-----|
| Blue (0,0,255) | Hardcoded inputs |
| Black (0,0,0) | Formulas |
| Green (0,128,0) | Links to other sheets |
| Red (255,0,0) | External links |
| Yellow background | Key assumptions |

## Number Formatting

```python
# Currency
sheet['A1'].number_format = '$#,##0.00'

# Percentage
sheet['B1'].number_format = '0.00%'

# Thousands separator
sheet['C1'].number_format = '#,##0'
```

## Best Practices

1. **Use Excel formulas** instead of calculating in Python and hardcoding
2. **Use pandas** for data analysis and bulk operations
3. **Use openpyxl** for formatting, formulas, and Excel-specific features
4. **Cell indices are 1-based** (row=1, column=1 = A1)
5. **Avoid `data_only=True`** when saving - it replaces formulas with values

## Common Libraries

```bash
pip install pandas openpyxl
```

## Error Prevention

- Verify cell references before using
- Handle division by zero with `IFERROR()`
- Check for null values with `pd.notna()`
- Test formulas on sample cells first
