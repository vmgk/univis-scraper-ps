# Faculty Data Scraper (PowerShell Automation)
*Created as part of an IT Infrastructure internship at the University of Bamberg (2026).*

> **DISCLAIMER:** This script is for educational purposes only. The author is not responsible for any misuse of this tool or for any data harvested using this script. Users must comply with the terms of service of the target website and applicable data privacy laws (such as GDPR).

## Project Overview
The goal of this project was to automate the collection of faculty contact information from the university’s web directory. The script processes approximately 4,000+ entries, ensuring that only high-quality, relevant staff data is extracted. 

## Key Features
* **Automated Parsing**: Efficiently navigates university web directories (UnivIS-style) to extract staff data.
* **Non-Recursive BFS**: Implements a Breadth-First Search (BFS) algorithm for non-recursive directory traversal, ensuring process stability and memory efficiency.
* **Advanced Data Validation**: Features custom logic to filter out generic or technical email addresses. Correctly handles German special characters (umlauts and diacritics) during the name and email matching process.



## Data Privacy & Scope
* **Public Data Only**: This script interacts exclusively with publicly accessible web directory data available to any unauthenticated visitor. 
* **No Authentication Required**: The script does not bypass any login mechanisms, does not access password-protected areas, and does not harvest private or sensitive information.
* **Educational Purpose**: This tool was developed to demonstrate automation techniques for processing public datasets and is not intended for large-scale production scraping.
* **Local Processing**: All extracted data is saved to a local file and is never transmitted to external servers.

## How it works
The process is split into two primary scripts:
1. **`Dep.ps1`**: Iterates through the university's department index and generates a CSV file containing all individual profile URLs.
2. **`start.ps1`**: Parses the list of URLs, scrapes full names and email addresses, and applies validation logic to filter out generic or technical contact addresses.

## Configuration
To use this script for your specific needs, you need to set the target URL. The script is designed to work with directory structures similar to the UnivIS system.

1. Open `Dep.ps1` in a text editor (e.g., VS Code or Notepad++).
2. Locate the `$baseUrl` and `$rootUrl` variables at the top of the script.
3. Replace the placeholder with your target directory URL:
   
   ```powershell
   $baseUrl = "https://your-target-university-directory-link"
   $rootUrl = "https://your-target-university-directory-link"
   ```
*Note: For the University of Bamberg, the URL can typically be found in the UnivIS search form under the "Directory" or "Telephone" section or you can ask me.*

## Acknowledgments
* **University of Bamberg**: Heartfelt thanks to the IT Department (IT-Servicezentrum) for providing the technical task and professional environment across the Serverinfrastruktur and Serverdienste departments.
* **Development**: This project was built using modern AI-assisted development tools to optimize PowerShell logic and error handling.

## License
This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.