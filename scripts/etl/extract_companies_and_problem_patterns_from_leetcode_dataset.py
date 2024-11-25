"""
extract list of companies and problem patterns from the leetcode dataset
"""

import openpyxl


def extract_from_column(column_name, ds):
    wb = openpyxl.load_workbook(ds)
    result = []

    for sheet in wb:
        column_index = column_name  # 'F', 'G'
        column = sheet[column_index]

        for cell in column[1:]:
            # print(cell.value) # 'Amazon,Google,Apple,Adobe,Microsoft,Bloomberg,Facebook,Oracle,Uber,Expedia,Twitter,Nagarro,SAP,Yahoo,Cisco,Qualcomm,tcs,Goldman Sachs,Yandex,ServiceNow'
            if cell.value:
                cell.value = cell.value.lower()
                _companies = cell.value.split(",")
                for _company in _companies:
                    _company = _company.replace(" ", "_").replace("-", "_").strip()
                    if _company not in result:
                        result.append(_company)
                    else:
                        pass
            else:
                pass

    return result


def export_to_txt(data, filename):
    with open(filename, "w") as f:
        for item in data:
            f.write(item + "\n")


if __name__ == "__main__":
    dataset = "../../ff/static/assets/datasets/leetcode_dataset.xlsx"

    companies = extract_from_column("F", dataset)
    patterns = extract_from_column("G", dataset)

    print("Companies count: ", len(companies))
    print("Patterns count: ", len(patterns))

    # Companies count: 200
    # Patterns count: 43

    export_to_txt(companies, "../../ff/static/assets/datasets/companies.txt")
    export_to_txt(patterns, "../../ff/static/assets/datasets/patterns.txt")
