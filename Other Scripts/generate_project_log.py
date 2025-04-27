import os

# Directories and files to ignore
IGNORE_DIRS = ['.git', 'node_modules', '.venv', 'frontend', 'frontend/build', 'Other Scripts', 'Design Documents']
IGNORE_FILES = []

def write_file_content(file_path, log_file):
    """Writes the content of the file to the log file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            log_file.write(f"--- {file_path} ---\n")
            log_file.write(file.read())
            log_file.write("\n\n")
    except UnicodeDecodeError:
        # Handle files that can't be decoded as text
        log_file.write(f"--- {file_path} --- (non-text file, skipped)\n\n")
    except Exception as e:
        log_file.write(f"Error reading {file_path}: {e}\n")

def process_directory(base_dir, log_file_path):
    """Recursively process all files in the directory and append their content to the log file"""
    with open(log_file_path, 'a', encoding='utf-8') as log_file:  # Open in append mode
        for root, dirs, files in os.walk(base_dir):
            # Ignore certain directories
            dirs[:] = [d for d in dirs if d not in IGNORE_DIRS]

            for file in files:
                file_path = os.path.join(root, file)
                if file not in IGNORE_FILES:
                    write_file_content(file_path, log_file)

if __name__ == '__main__':
    # Set the base directory (folder containing your project)
    base_directory = '/Users/strix/Documents/Projects/smart_stock'  # Absolute path
    log_file_path = '/Users/strix/Documents/Projects/smart_stock/Other Scripts/directory_full.log'  # Absolute path

    print(f"Current working directory: {os.getcwd()}")  # Print current directory for debugging

    # Start processing the directory
    process_directory(base_directory, log_file_path)

    print(f"Project log has been generated in {log_file_path}")
